import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ViewPitchesScreen extends StatelessWidget {
  const ViewPitchesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user?.email != 'admin@example.com') {
      return const Scaffold(
        body: Center(child: Text("Access denied: Admins only")),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("View Pitches")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('projects').snapshots(),
        builder: (context, projectSnapshot) {
          if (!projectSnapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final projectDocs = projectSnapshot.data!.docs;

          return ListView(
            children: projectDocs.map((projectDoc) {
              final projectData = projectDoc.data() as Map<String, dynamic>;
              final projectId = projectDoc.id;

              return ExpansionTile(
                title: Text(projectData['title'] ?? 'Untitled Project'),
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
                        return const Padding(
                          padding: EdgeInsets.all(16),
                          child: CircularProgressIndicator(),
                        );
                      }

                      final pitches = pitchSnapshot.data!.docs;

                      if (pitches.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.all(16),
                          child: Text("No pitches submitted yet."),
                        );
                      }

                      return Column(
                        children: pitches.map((pitchDoc) {
                          final pitchData = pitchDoc.data() as Map<String, dynamic>;
                          return ListTile(
                            title: Text(pitchData['userEmail'] ?? 'Unknown User'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("📝 Write-up: ${pitchData['text'] ?? ''}"),
                                if ((pitchData['video'] ?? '').isNotEmpty)
                                  Text("🎬 Video: ${pitchData['video']}"),
                                if ((pitchData['driveLink'] ?? '').isNotEmpty)
                                  Text("🔗 Drive: ${pitchData['driveLink']}"),
                                const Divider(),
                              ],
                            ),
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
}
