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
      return const Scaffold(
        body: Center(child: Text("Not signed in")),
      );
    }

    if (user.email == 'admin@example.com') {
      return const CreateProjectScreen();
    }

    return const MainHomeScreen();
  }
}
