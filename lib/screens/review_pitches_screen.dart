import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ReviewPitchesScreen extends StatelessWidget {
  final String projectId;

  const ReviewPitchesScreen({super.key, required this.projectId});

  @override
  Widget build(BuildContext context) {
    final pitchesRef = FirebaseFirestore.instance
        .collection('projects')
        .doc(projectId)
        .collection('pitches');

    return Scaffold(
      appBar: AppBar(title: const Text("Review Pitches")),
      body: StreamBuilder<QuerySnapshot>(
        stream: pitchesRef.orderBy('submittedAt', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          final docs = snapshot.data!.docs;
          if (docs.isEmpty) return const Center(child: Text("No pitches submitted"));

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;

              return Card(
                margin: const EdgeInsets.all(10),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("📧 ${data['userEmail'] ?? 'Unknown'}", style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text("✍️ Write-up:\n${data['text'] ?? ''}"),
                      const SizedBox(height: 8),
                      if ((data['video'] ?? '').isNotEmpty)
                        Text("🎥 Video URL: ${data['video']}"),
                      if ((data['driveLink'] ?? '').isNotEmpty)
                        Text("📂 Drive Link: ${data['driveLink']}"),
                      const SizedBox(height: 8),
                      Text("📅 Submitted at: ${data['submittedAt']?.toDate().toLocal()}"),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
