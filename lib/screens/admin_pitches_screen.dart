import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminPitchesScreen extends StatelessWidget {
  const AdminPitchesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Review Submitted Pitches")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('projects')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, projectSnapshot) {
          if (!projectSnapshot.hasData) return const Center(child: CircularProgressIndicator());

          final projects = projectSnapshot.data!.docs;

          return ListView(
            children: projects.map((projectDoc) {
              final projectData = projectDoc.data() as Map<String, dynamic>;
              final projectId = projectDoc.id;

              return ExpansionTile(
                title: Text(projectData['title'] ?? 'Untitled Project'),
                subtitle: Text("📌 ${projectData['company'] ?? 'Unknown Company'}"),
                children: [
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('projects')
                        .doc(projectId)
                        .collection('pitches')
                        .orderBy('submittedAt', descending: true)
                        .snapshots(),
                    builder: (context, pitchSnapshot) {
                      if (!pitchSnapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final pitches = pitchSnapshot.data!.docs;

                      if (pitches.isEmpty) {
                        return const ListTile(title: Text("No pitches submitted yet."));
                      }

                      return Column(
                        children: pitches.map((pitchDoc) {
                          final pitch = pitchDoc.data() as Map<String, dynamic>;

                          return ListTile(
                            title: Text(pitch['userEmail'] ?? 'Unknown User'),
                            subtitle: Text(pitch['text']?.substring(0, 30) ?? ''),
                            onTap: () {
                              _showPitchDetails(context, pitch);
                            },
                          );
                        }).toList(),
                      );
                    },
                  )
                ],
              );
            }).toList(),
          );
        },
      ),
    );
  }

  void _showPitchDetails(BuildContext context, Map<String, dynamic> pitch) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Pitch by ${pitch['userEmail']}"),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("✍️ Write-up:", style: TextStyle(fontWeight: FontWeight.bold)),
              Text(pitch['text'] ?? ''),
              const SizedBox(height: 10),
              const Text("📹 Video URL:", style: TextStyle(fontWeight: FontWeight.bold)),
              Text(pitch['video'] ?? 'Not provided'),
              const SizedBox(height: 10),
              const Text("📁 Drive Link:", style: TextStyle(fontWeight: FontWeight.bold)),
              GestureDetector(
                onTap: () {
                  // Optional: use url_launcher to open link
                },
                child: Text(
                  pitch['driveLink'] ?? 'Not provided',
                  style: const TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Close")),
        ],
      ),
    );
  }
}
