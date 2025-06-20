import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'create_project_screen.dart';
import 'main_home_screen.dart';

class AdminHomeRedirector extends StatelessWidget {
  const AdminHomeRedirector({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      // Redirect to login if not authenticated
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/');
      });
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6366F1)),
          ),
        ),
      );
    }

    // Check if user is admin
    if (user.email == 'admin@example.com') {
      return const CreateProjectScreen();
    }

    // Regular user - redirect to main home
    return const MainHomeScreen();
  }
}