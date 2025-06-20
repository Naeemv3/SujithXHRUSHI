import 'package:flutter/material.dart';

class CoursesScreen extends StatelessWidget {
  const CoursesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final courses = [
      CourseItem(
        title: 'Flutter Development',
        description: 'Master mobile app development with Flutter and Dart',
        duration: '8 weeks',
        level: 'Beginner',
        color: const Color(0xFF6366F1),
        icon: Icons.phone_android_rounded,
        rating: 4.8,
        students: 1250,
      ),
      CourseItem(
        title: 'Python for Data Science',
        description: 'Learn Python programming for data analysis and machine learning',
        duration: '10 weeks',
        level: 'Intermediate',
        color: const Color(0xFF10B981),
        icon: Icons.analytics_rounded,
        rating: 4.9,
        students: 2100,
      ),
      CourseItem(
        title: 'Web Development Bootcamp',
        description: 'Complete guide to HTML, CSS, JavaScript, and React',
        duration: '12 weeks',
        level: 'Beginner',
        color: const Color(0xFFF59E0B),
        icon: Icons.web_rounded,
        rating: 4.7,
        students: 3200,
      ),
      CourseItem(
        title: 'UI/UX Design Fundamentals',
        description: 'Design beautiful and user-friendly interfaces',
        duration: '6 weeks',
        level: 'Beginner',
        color: const Color(0xFF8B5CF6),
        icon: Icons.design_services_rounded,
        rating: 4.6,
        students: 890,
      ),
      CourseItem(
        title: 'Cloud Computing with AWS',
        description: 'Deploy and manage applications on Amazon Web Services',
        duration: '14 weeks',
        level: 'Advanced',
        color: const Color(0xFFEF4444),
        icon: Icons.cloud_rounded,
        rating: 4.8,
        students: 1560,
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: ListView.builder(
        padding: const EdgeInsets.all(24),
        itemCount: courses.length,
        itemBuilder: (context, index) {
          final course = courses[index];
          return _buildCourseCard(context, course);
        },
      ),
    );
  }

  Widget _buildCourseCard(BuildContext context, CourseItem course) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: course.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    course.icon,
                    color: course.color,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        course.title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        course.description,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 16,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Course Details
            Row(
              children: [
                _buildDetailChip(
                  Icons.schedule_rounded,
                  course.duration,
                  Colors.blue.shade600,
                ),
                const SizedBox(width: 12),
                _buildDetailChip(
                  Icons.signal_cellular_alt_rounded,
                  course.level,
                  _getLevelColor(course.level),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Stats
            Row(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.star_rounded,
                      color: Colors.amber.shade600,
                      size: 18,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      course.rating.toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 20),
                Row(
                  children: [
                    Icon(
                      Icons.people_rounded,
                      color: Colors.grey.shade600,
                      size: 18,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${course.students} students',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Action Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Enrolled in ${course.title}'),
                      backgroundColor: course.color,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.play_arrow_rounded, size: 20),
                label: const Text(
                  'Start Learning',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: course.color,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailChip(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withOpacity(0.2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Color _getLevelColor(String level) {
    switch (level.toLowerCase()) {
      case 'beginner':
        return const Color(0xFF10B981);
      case 'intermediate':
        return const Color(0xFFF59E0B);
      case 'advanced':
        return const Color(0xFFEF4444);
      default:
        return Colors.grey.shade600;
    }
  }
}

class CourseItem {
  final String title;
  final String description;
  final String duration;
  final String level;
  final Color color;
  final IconData icon;
  final double rating;
  final int students;

  CourseItem({
    required this.title,
    required this.description,
    required this.duration,
    required this.level,
    required this.color,
    required this.icon,
    required this.rating,
    required this.students,
  });
}