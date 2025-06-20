import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Scaffold(body: Center(child: Text("User not logged in")));
    }

    final userDoc = FirebaseFirestore.instance.collection('users').doc(user.uid);
    final quizColl = userDoc.collection('quizzes');

    return Scaffold(
      appBar: AppBar(title: const Text("📊 My Dashboard")),
      body: FutureBuilder<DocumentSnapshot>(
        future: userDoc.get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final userData = snapshot.data!.data() as Map<String, dynamic>?;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text("👤 Name: ${userData?['fullName'] ?? ''}"),
              Text("🎓 Degree: ${userData?['degree'] ?? ''}"),
              Text("🏫 College: ${userData?['college'] ?? ''}"),
              const SizedBox(height: 20),
              const Divider(),
              const Text("📈 Quiz Performance", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              StreamBuilder<QuerySnapshot>(
                stream: quizColl.snapshots(),
                builder: (context, quizSnapshot) {
                  if (!quizSnapshot.hasData) return const Text("Loading...");
                  final quizzes = quizSnapshot.data!.docs;

                  if (quizzes.isEmpty) return const Text("No quizzes taken yet.");

                  return Column(
                    children: quizzes.map((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      return Card(
                        child: ListTile(
                          title: Text("🛠 ${data['skill']}"),
                          subtitle: Text("Score: ${data['score']}/10"),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
              const SizedBox(height: 20),
              const Divider(),
              const Text("🏆 Leaderboard (Coming Soon)", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text("🔧 Feature under development..."),
            ],
          );
        },
      ),
    );
  }
}
