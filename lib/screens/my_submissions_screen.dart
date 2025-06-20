import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MySubmissionsScreen extends StatelessWidget {
  const MySubmissionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Scaffold(body: Center(child: Text("Please log in first.")));
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("My Submissions"),
          bottom: const TabBar(tabs: [
            Tab(text: "📝 Pitches"),
            Tab(text: "🧠 Quiz Analysis"),
          ]),
        ),
        body: TabBarView(
          children: [
            _buildPitchTab(user.uid),
            _buildQuizTab(user.uid),
          ],
        ),
      ),
    );
  }

  Widget _buildPitchTab(String userId) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collectionGroup('pitches')
        .where('userId', isEqualTo: userId).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        final docs = snapshot.data!.docs;
        if (docs.isEmpty) return const Center(child: Text("No pitch submissions yet."));

        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final data = docs[index].data() as Map<String, dynamic>;
            return ListTile(
              title: Text(data['text'] ?? "No content"),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (data['videoUrl'] != null) Text("📹 Video: ${data['videoUrl']}"),
                  if (data['driveLink'] != null) Text("🔗 Drive: ${data['driveLink']}"),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildQuizTab(String userId) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('quizzes')
          .orderBy('date', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

        final quizzes = snapshot.data!.docs;
        if (quizzes.isEmpty) return const Center(child: Text("No quizzes taken yet."));

        return ListView.builder(
          itemCount: quizzes.length,
          itemBuilder: (context, index) {
            final data = quizzes[index].data() as Map<String, dynamic>;
            return Card(
              margin: const EdgeInsets.all(8),
              child: ListTile(
                title: Text("Skill: ${data['skill']}"),
                subtitle: Text("Score: ${data['score']}/10\n${data['date']}"),
              ),
            );
          },
        );
      },
    );
  }
}
