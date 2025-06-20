import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'dashboard_screen.dart';
import 'quiz_screen.dart';
import 'my_submissions_screen.dart';
import 'view_projects_screen.dart';
import 'courses_screen.dart';
import 'chat_screen.dart';
import 'create_project_screen.dart';
import 'view_pitches_screen.dart';

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const DashboardScreen(),
    QuizScreen(skill: "Python"), // Not const because skill is dynamic
    const MySubmissionsScreen(),
    const ViewProjectsScreen(),
    const CoursesScreen(),
    const ChatScreen(),
  ];

  final List<String> _titles = [
    'Dashboard',
    'Take Quiz',
    'My Submissions',
    'View Projects',
    'Courses',
    'Chat',
  ];

  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_titles[_selectedIndex])),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.indigo),
              child: Text('SkillBridge Menu', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            _buildDrawerItem(Icons.dashboard, 'Dashboard', 0),
            _buildDrawerItem(Icons.quiz, 'Take Quiz', 1),
            _buildDrawerItem(Icons.assignment, 'My Submissions', 2),
            _buildDrawerItem(Icons.work, 'View Projects', 3),
            _buildDrawerItem(Icons.school, 'Courses', 4),
            _buildDrawerItem(Icons.chat, 'Chat', 5),

            if (user?.email == 'admin@example.com') ...[
              const Divider(),
              ListTile(
                leading: const Icon(Icons.create),
                title: const Text('Create Project'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CreateProjectScreen()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.list_alt),
                title: const Text('View Pitches'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ViewPitchesScreen()),
                  );
                },
              ),
            ],
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            ),
          ],
        ),
      ),
      body: _pages[_selectedIndex],
    );
  }

  Widget _buildDrawerItem(IconData icon, String label, int index) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      selected: _selectedIndex == index,
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
        Navigator.pop(context);
      },
    );
  }
}
