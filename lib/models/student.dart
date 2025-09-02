class Student {
  final String id;
  final String name;
  final String email;
  final String phone;
  final DateTime enrollmentDate;
  final StudentStatus status;
  final double attendanceRate;
  final String grade;
  final int completedAssessments;
  final int totalAssessments;

  Student({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.enrollmentDate,
    required this.status,
    required this.attendanceRate,
    required this.grade,
    required this.completedAssessments,
    required this.totalAssessments,
  });
}

enum StudentStatus { active, hold, inactive }