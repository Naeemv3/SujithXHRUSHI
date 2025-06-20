import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'submit_pitch_screen.dart';
import 'review_pitches_screen.dart'; // ✅ Add this

class ViewProjectsScreen extends StatelessWidget {
  const ViewProjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(body: Center(child: Text("Login required")));
    }

    final isAdmin = user.email == 'admin@example.com';

    return Scaffold(
      appBar: AppBar(title: const Text("View Projects")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('projects')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          final docs = snapshot.data!.docs;
          if (docs.isEmpty) return const Center(child: Text("No projects available"));

          return ListView(
            padding: const EdgeInsets.all(16),
            children: docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              final projectId = doc.id;

              return Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: ListTile(
                  title: Text(data['title'] ?? 'Untitled'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(data['description'] ?? ''),
                      Text("🧠 Skills: ${(data['requiredSkills'] as List<dynamic>?)?.join(', ') ?? ''}"),
                      Text("🏢 ${data['company'] ?? ''}"),
                    ],
                  ),
                  trailing: isAdmin
                      ? ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ReviewPitchesScreen(projectId: projectId),
                              ),
                            );
                          },
                          child: const Text("Review Pitches"),
                        )
                      : ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => SubmitPitchScreen(projectId: projectId),
                              ),
                            );
                          },
                          child: const Text("Submit Pitch"),
                        ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
