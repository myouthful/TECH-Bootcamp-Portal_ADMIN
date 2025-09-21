import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'createassessment.dart';
import '../utils/app_colors.dart';

class AssessmentManagementScreen extends StatefulWidget {
  const AssessmentManagementScreen({super.key});

  @override
  State<AssessmentManagementScreen> createState() =>
      _AssessmentManagementScreenState();
}

class _AssessmentManagementScreenState
    extends State<AssessmentManagementScreen> {
  List<Assessment> assessments = [];
  bool loading = true;
  bool errorOccurred = false;

  @override
  void initState() {
    super.initState();
    _fetchAssessments();
  }

  Future<void> _fetchAssessments() async {
    setState(() {
      loading = true;
      errorOccurred = false;
    });
    try {
      final res =
          await http.get(Uri.parse('https://attendancebackend-gjjw.onrender.com/assessment/list'));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body) as List<dynamic>;
        setState(() {
          assessments = data.map((a) {
            return Assessment(
              title: a['title'],
              subject: a['subject'],
              duration: a['duration'] ?? '—',
              questions: '${a['questions'].length}',
              status: _mapStatus(a['status']),
              completion: a['completion'] ?? '0/0',
              performance: a['performance'] ?? '',
              createdDate: a['createdDate'] ?? '',
            );
          }).toList();
          loading = false;
        });
      } else {
        throw Exception('Failed: ${res.statusCode}');
      }
    } catch (e) {
      setState(() {
        loading = false;
        errorOccurred = true;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error fetching: $e')));
    }
  }

  AssessmentStatus _mapStatus(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return AssessmentStatus.active;
      case 'completed':
        return AssessmentStatus.completed;
      case 'draft':
        return AssessmentStatus.draft;
      case 'scheduled':
        return AssessmentStatus.scheduled;
      default:
        return AssessmentStatus.draft;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (errorOccurred) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Failed to load assessments.'),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _fetchAssessments,
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            ElevatedButton.icon(
              onPressed: () async {
                await showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => Dialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: SizedBox(
                      width: 600,
                      child: const CreateAssessmentScreen(),
                    ),
                  ),
                );
                _fetchAssessments(); // refresh after creating new assessment
              },
              icon: const Icon(Icons.add, size: 16),
              label: const Text('Create Assessment'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
            ),
          ]),
          const SizedBox(height: 24),
          _buildStatsCards(),
          const SizedBox(height: 24),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _fetchAssessments,
              child: _buildAssessmentsTable(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCards() {
    final total = assessments.length;
    final active =
        assessments.where((a) => a.status == AssessmentStatus.active).length;
    final completed =
        assessments.where((a) => a.status == AssessmentStatus.completed).length;
    final drafts =
        assessments.where((a) => a.status == AssessmentStatus.draft).length;

    return Row(
      children: [
        _buildStatCard(total.toString(), 'Total Assessments', AppColors.primary),
        const SizedBox(width: 16),
        _buildStatCard(active.toString(), 'Active', AppColors.success),
        const SizedBox(width: 16),
        _buildStatCard(completed.toString(), 'Completed', AppColors.warning),
        const SizedBox(width: 16),
        _buildStatCard(drafts.toString(), 'Drafts', Colors.grey),
      ],
    );
  }

  Widget _buildStatCard(String count, String label, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(
              count,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAssessmentsTable() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.assignment, size: 16, color: AppColors.primary),
                    SizedBox(width: 8),
                    Text('All Assessments',
                        style:
                            TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 4),
                Text('Manage and monitor all student assessments',
                    style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              ],
            ),
          ),
          Container(
            color: Colors.grey[50],
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: const Row(
              children: [
                Expanded(flex: 2, child: Text('Assessment', style: _headerStyle)),
                Expanded(flex: 1, child: Text('Subject', style: _headerStyle)),
                Expanded(flex: 1, child: Text('Duration', style: _headerStyle)),
                Expanded(flex: 1, child: Text('Questions', style: _headerStyle)),
                Expanded(flex: 1, child: Text('Status', style: _headerStyle)),
                Expanded(flex: 1, child: Text('Completion', style: _headerStyle)),
                Expanded(flex: 1, child: Text('Performance', style: _headerStyle)),
                Expanded(flex: 1, child: Text('Actions', style: _headerStyle)),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: assessments.length,
              itemBuilder: (context, index) =>
                  _buildAssessmentRow(assessments[index]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAssessmentRow(Assessment assessment) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(assessment.title,
                    style:
                        const TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
                Text('Created: ${assessment.createdDate}',
                    style:
                        TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              ],
            ),
          ),
          Expanded(flex: 1, child: Text(assessment.subject)),
          Expanded(
            flex: 1,
            child: Row(
              children: [
                const Icon(Icons.schedule, size: 12, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Text(assessment.duration),
              ],
            ),
          ),
          Expanded(flex: 1, child: Text(assessment.questions)),
          Expanded(flex: 1, child: _buildStatusChip(assessment.status)),
          Expanded(flex: 1, child: Text(assessment.completion)),
          Expanded(flex: 1, child: Text(assessment.performance)),
          Expanded(
            flex: 1,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.visibility, size: 16),
                  onPressed: () {},
                  tooltip: 'View',
                ),
                IconButton(
                  icon: const Icon(Icons.edit, size: 16),
                  onPressed: () {},
                  tooltip: 'Edit',
                ),
                IconButton(
                  icon: const Icon(Icons.bar_chart, size: 16),
                  onPressed: () {},
                  tooltip: 'Results',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(AssessmentStatus status) {
    Color color;
    String text;

    switch (status) {
      case AssessmentStatus.active:
        color = AppColors.success;
        text = 'active';
        break;
      case AssessmentStatus.completed:
        color = AppColors.primary;
        text = 'completed';
        break;
      case AssessmentStatus.draft:
        color = Colors.grey;
        text = 'draft';
        break;
      case AssessmentStatus.scheduled:
        color = AppColors.warning;
        text = 'scheduled';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(text,
          style: const TextStyle(
              color: Colors.white, fontSize: 10, fontWeight: FontWeight.w500)),
    );
  }
}

const _headerStyle =
    TextStyle(fontWeight: FontWeight.w600, fontSize: 12);

enum AssessmentStatus { active, completed, draft, scheduled }

class Assessment {
  final String title;
  final String subject;
  final String duration;
  final String questions;
  final AssessmentStatus status;
  final String completion;
  final String performance;
  final String createdDate;

  Assessment({
    required this.title,
    required this.subject,
    required this.duration,
    required this.questions,
    required this.status,
    required this.completion,
    required this.performance,
    required this.createdDate,
  });
}
