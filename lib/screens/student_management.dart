import 'package:flutter/material.dart';

class StudentManagement extends StatelessWidget {
  const StudentManagement({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search students...',
                border: InputBorder.none,
                icon: Icon(Icons.search, color: Colors.grey[600]),
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Students Table
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        const Icon(Icons.people, size: 20, color: Color(0xFF4A90E2)),
                        const SizedBox(width: 8),
                        const Text(
                          'Enrolled Students',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          'Complete student roster with performance overview',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  // Table Header
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    color: Colors.grey[50],
                    child: Row(
                      children: [
                        const Expanded(flex: 2, child: Text('Student', style: TextStyle(fontWeight: FontWeight.w600))),
                        const Expanded(flex: 2, child: Text('Contact', style: TextStyle(fontWeight: FontWeight.w600))),
                        const Expanded(child: Text('Enrollment', style: TextStyle(fontWeight: FontWeight.w600))),
                        const Expanded(child: Text('Attendance', style: TextStyle(fontWeight: FontWeight.w600))),
                        const Expanded(child: Text('Grade', style: TextStyle(fontWeight: FontWeight.w600))),
                        const Expanded(child: Text('Status', style: TextStyle(fontWeight: FontWeight.w600))),
                        const Expanded(child: Text('Progress', style: TextStyle(fontWeight: FontWeight.w600))),
                        const SizedBox(width: 80, child: Text('Actions', style: TextStyle(fontWeight: FontWeight.w600))),
                      ],
                    ),
                  ),
                  // Table Rows
                  Expanded(
                    child: ListView(
                      children: [
                        _buildStudentRow('Alex Johnson', 'ID: 1', 'alex.johnson@email.com', '+1 (555) 123-4567', '2024-11-15', 'Last: 2 hours ago', '95%', 'A', 'ACTIVE', '8/10 assessments'),
                        _buildStudentRow('Sarah Chen', 'ID: 2', 'sarah.chen@email.com', '+1 (555) 234-5678', '2024-11-12', 'Last: 1 day ago', '88%', 'A-', 'ACTIVE', '7/10 assessments'),
                        _buildStudentRow('Mike Rodriguez', 'ID: 3', 'mike.rodriguez@email.com', '+1 (555) 345-6789', '2024-11-10', 'Last: 3 hours ago', '92%', 'B+', 'ACTIVE', '9/10 assessments'),
                        _buildStudentRow('Emma Thompson', 'ID: 4', 'emma.thompson@email.com', '+1 (555) 456-7890', '2024-11-08', 'Last: 1 week ago', '75%', 'B', 'HOLD', '5/10 assessments'),
                        _buildStudentRow('David Kim', 'ID: 5', 'david.kim@email.com', '+1 (555) 567-8901', '2024-11-05', 'Last: 2 weeks ago', '82%', 'B-', 'INACTIVE', '6/10 assessments'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentRow(String name, String id, String email, String phone, String enrollDate, String lastSeen, String attendance, String grade, String status, String progress) {
    Color statusColor;
    Color statusBgColor;
    switch (status) {
      case 'ACTIVE':
        statusColor = Colors.green;
        statusBgColor = Colors.green.withOpacity(0.1);
        break;
      case 'HOLD':
        statusColor = Colors.orange;
        statusBgColor = Colors.orange.withOpacity(0.1);
        break;
      case 'INACTIVE':
        statusColor = Colors.grey;
        statusBgColor = Colors.grey.withOpacity(0.1);
        break;
      default:
        statusColor = Colors.grey;
        statusBgColor = Colors.grey.withOpacity(0.1);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Row(
        children: [
          // Student Info
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                Text(
                  id,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          // Contact
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  email,
                  style: const TextStyle(fontSize: 12),
                ),
                Text(
                  phone,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          // Enrollment
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  enrollDate,
                  style: const TextStyle(fontSize: 12),
                ),
                Text(
                  lastSeen,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          // Attendance
          Expanded(
            child: Row(
              children: [
                Text(
                  attendance,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: LinearProgressIndicator(
                    value: double.parse(attendance.replaceAll('%', '')) / 100,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      double.parse(attendance.replaceAll('%', '')) >= 90
                          ? Colors.green
                          : double.parse(attendance.replaceAll('%', '')) >= 75
                              ? Colors.orange
                              : Colors.red,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Grade
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _getGradeColor(grade).withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                grade,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: _getGradeColor(grade),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          // Status
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: statusBgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                status,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: statusColor,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          // Progress
          Expanded(
            child: Text(
              progress,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ),
          // Actions
          SizedBox(
            width: 80,
            child: IconButton(
              icon: const Icon(Icons.visibility, size: 16),
              onPressed: () {},
              tooltip: 'View',
            ),
          ),
        ],
      ),
    );
  }

  Color _getGradeColor(String grade) {
    if (grade.startsWith('A')) return Colors.green;
    if (grade.startsWith('B')) return Colors.blue;
    if (grade.startsWith('C')) return Colors.orange;
    return Colors.red;
  }
}