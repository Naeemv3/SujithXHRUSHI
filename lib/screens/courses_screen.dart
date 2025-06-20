import 'package:flutter/material.dart';

class CoursesScreen extends StatelessWidget {
  const CoursesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dummyCourses = [
      {'title': 'Flutter Basics', 'description': 'Learn to build apps with Flutter'},
      {'title': 'Python for Beginners', 'description': 'Introductory course to Python'},
      {'title': 'Web Development', 'description': 'HTML, CSS, JavaScript basics'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Courses")),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: dummyCourses.length,
        itemBuilder: (context, index) {
          final course = dummyCourses[index];
          return Card(
            elevation: 3,
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: ListTile(
              title: Text(course['title']!),
              subtitle: Text(course['description']!),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Clicked on ${course['title']}")),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
