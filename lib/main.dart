import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'auth/google_sign_in_service.dart';
import 'screens/admin_home_redirector.dart'; // ✅ Make sure this file exists
import 'screens/profile_form_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const SkillBridgeApp());
}

class SkillBridgeApp extends StatelessWidget {
  const SkillBridgeApp({super.key});

  @override
  Widget build(BuildContext context) {
    final signInService = GoogleSignInService();

    return MaterialApp(
      title: 'SkillBridge',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(title: const Text('SkillBridge Login')),
        body: Center(
          child: ElevatedButton(
            onPressed: () async {
              final user = await signInService.signInWithGoogle();
              if (context.mounted && user != null) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AdminHomeRedirector(), // ✅ changed here
                  ),
                );
              } else if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Login failed or cancelled')),
                );
              }
            },
            child: const Text('Sign in with Google'),
          ),
        ),
      ),
    );
  }
}
