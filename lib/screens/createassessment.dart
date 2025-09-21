import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CreateAssessmentScreen extends StatefulWidget {
  const CreateAssessmentScreen({Key? key}) : super(key: key);

  @override
  State<CreateAssessmentScreen> createState() => _CreateAssessmentScreenState();
}

class _CreateAssessmentScreenState extends State<CreateAssessmentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _subjectController = TextEditingController();

  String? _selectedTrack;
  List<Map<String, dynamic>> _tracks = [];
  List<Map<String, dynamic>> _students = [];
  List<Map<String, dynamic>> _questions = [];

  bool _loadingTracks = true;
  bool _loadingStudents = false;

  @override
  void initState() {
    super.initState();
    _fetchTracks();
  }

  Future<void> _fetchTracks() async {
    setState(() => _loadingTracks = true);
    try {
      final res = await http.get(Uri.parse('http://localhost:3000/api/tracks'));
      if (res.statusCode == 200) {
        setState(() {
          _tracks = List<Map<String, dynamic>>.from(json.decode(res.body));
          _loadingTracks = false;
        });
      } else {
        throw Exception('Failed to fetch tracks');
      }
    } catch (e) {
      setState(() => _loadingTracks = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> _fetchStudents(String trackId) async {
    setState(() {
      _loadingStudents = true;
      _students.clear();
    });
    try {
      final res = await http
          .get(Uri.parse('http://localhost:3000/api/students?track=$trackId'));
      if (res.statusCode == 200) {
        setState(() {
          _students = List<Map<String, dynamic>>.from(json.decode(res.body));
          _loadingStudents = false;
        });
      } else {
        throw Exception('Failed to fetch students');
      }
    } catch (e) {
      setState(() => _loadingStudents = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  void _addQuestion() {
    setState(() {
      _questions.add({
        "questionText": "",
        "options": ["", "", "", ""],
        "correctAnswer": "",
        "points": 1
      });
    });
  }

  Future<void> _submitAssessment(String status) async {
    if (!_formKey.currentState!.validate() || _selectedTrack == null) return;

    final assignedTo = _students
        .map((s) => {
              "studentId": s['id'],
              "name": s['name'],
              "completionStatus": "Pending",
              "score": null
            })
        .toList();

    final body = {
      "title": _titleController.text.trim(),
      "subject": _subjectController.text.trim(),
      "status": status, // "Draft" or "Active"
      "questions": _questions,
      "assignedTo": assignedTo,
    };

    try {
      final res = await http.post(
        Uri.parse('http://localhost:3000/api/assessments'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );
      if (res.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Assessment $status successfully')));
        Navigator.pop(context);
      } else {
        throw Exception('Failed with ${res.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Added AppBar close button for dialog usage
      appBar: AppBar(
        title: const Text('Create Assessment'),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            tooltip: 'Close',
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: _loadingTracks
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration:
                        const InputDecoration(labelText: 'Assessment Title'),
                    validator: (val) =>
                        val == null || val.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _subjectController,
                    decoration: const InputDecoration(
                        labelText: 'Subject (e.g. Mathematics)'),
                    validator: (val) =>
                        val == null || val.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _selectedTrack,
                    decoration: const InputDecoration(labelText: 'Select Track'),
                    items: _tracks
                        .map((track) => DropdownMenuItem<String>(
                              value: track['id'],
                              child: Text(track['name']),
                            ))
                        .toList(),
                    onChanged: (val) {
                      setState(() => _selectedTrack = val);
                      if (val != null) _fetchStudents(val);
                    },
                    validator: (val) =>
                        val == null ? 'Please select a track' : null,
                  ),
                  const SizedBox(height: 24),
                  const Text('Questions',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ..._questions.asMap().entries.map((entry) {
                    final index = entry.key;
                    final q = entry.value;
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          children: [
                            TextFormField(
                              initialValue: q["questionText"],
                              decoration: InputDecoration(
                                  labelText: 'Question ${index + 1}'),
                              onChanged: (val) =>
                                  _questions[index]["questionText"] = val,
                              validator: (val) =>
                                  val == null || val.isEmpty ? 'Required' : null,
                            ),
                            ...List.generate(4, (i) {
                              return TextFormField(
                                initialValue: q["options"][i],
                                decoration: InputDecoration(
                                    labelText: 'Option ${i + 1}'),
                                onChanged: (val) =>
                                    _questions[index]["options"][i] = val,
                                validator: (val) => val == null || val.isEmpty
                                    ? 'Required'
                                    : null,
                              );
                            }),
                            TextFormField(
                              initialValue: q["correctAnswer"],
                              decoration: const InputDecoration(
                                  labelText: 'Correct Answer'),
                              onChanged: (val) =>
                                  _questions[index]["correctAnswer"] = val,
                              validator: (val) =>
                                  val == null || val.isEmpty ? 'Required' : null,
                            ),
                            TextFormField(
                              initialValue: q["points"].toString(),
                              decoration:
                                  const InputDecoration(labelText: 'Points'),
                              keyboardType: TextInputType.number,
                              onChanged: (val) => _questions[index]["points"] =
                                  int.tryParse(val) ?? 1,
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                  TextButton.icon(
                    onPressed: _addQuestion,
                    icon: const Icon(Icons.add),
                    label: const Text('Add Question'),
                  ),
                  const SizedBox(height: 24),
                  _loadingStudents
                      ? const Center(child: CircularProgressIndicator())
                      : _students.isNotEmpty
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Assigned Students:',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                ..._students.map((s) => Text(
                                    '- ${s['name']} (${s['id']})')).toList(),
                              ],
                            )
                          : const Text('Select a track to load students'),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () => _submitAssessment("Draft"),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey),
                        child: const Text('Save as Draft'),
                      ),
                      ElevatedButton(
                        onPressed: () => _submitAssessment("Active"),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue),
                        child: const Text('Publish'),
                      ),
                    ],
                  )
                ],
              ),
            ),
    );
  }
}
