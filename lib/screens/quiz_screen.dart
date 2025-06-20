import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../data/sample_quiz.dart'; // Make sure this file exists

class QuizScreen extends StatefulWidget {
  final String skill;

  const QuizScreen({super.key, required this.skill});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final _writtenControllers = <int, TextEditingController>{};
  final _selectedAnswers = <int, String?>{};
  bool _submitted = false;
  int _score = 0;

  Future<void> _submitAnswers() async {
    final mcqs = sampleQuiz.where((q) => q['type'] == 'mcq').toList();

    int correct = 0;
    for (int i = 0; i < mcqs.length; i++) {
      final correctAnswer = mcqs[i]['answer'];
      if (_selectedAnswers[i] == correctAnswer) correct++;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final docRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('quizzes')
          .doc(widget.skill);

      final writtenAnswers =
          _writtenControllers.entries.map((e) => e.value.text).toList();

      await docRef.set({
        'skill': widget.skill,
        'score': correct,
        'writtenAnswers': writtenAnswers,
        'date': DateTime.now().toIso8601String(),
      });
    }

    setState(() {
      _score = correct;
      _submitted = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final mcqs = sampleQuiz.where((q) => q['type'] == 'mcq').toList();
    final written = sampleQuiz.where((q) => q['type'] == 'written').toList();

    return Scaffold(
      appBar: AppBar(title: Text("Quiz on ${widget.skill}")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text("📘 Multiple Choice Questions",
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          ...mcqs.asMap().entries.map((entry) => _buildMCQ(entry.key, entry.value)).toList(),
          const SizedBox(height: 20),
          const Text("✍️ Written Questions",
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          ...written.asMap().entries.map((entry) => _buildWritten(entry.key, entry.value)).toList(),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _submitted ? null : _submitAnswers,
            child: const Text("Submit Quiz"),
          ),
          if (_submitted) ...[
            const SizedBox(height: 10),
            Text("✅ You scored $_score/${mcqs.length}",
                style: const TextStyle(fontSize: 18)),
            const Text("🧠 Written answers recorded."),
          ]
        ],
      ),
    );
  }

  Widget _buildMCQ(int index, Map<String, dynamic> q) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(padding: const EdgeInsets.all(8), child: Text(q['question'] ?? '')),
          ...List<String>.from(q['options']).map((option) {
            return RadioListTile<String>(
              title: Text(option),
              value: option,
              groupValue: _selectedAnswers[index],
              onChanged: _submitted
                  ? null
                  : (value) {
                      setState(() {
                        _selectedAnswers[index] = value;
                      });
                    },
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildWritten(int index, Map<String, dynamic> q) {
    final controller = _writtenControllers[index] ??= TextEditingController();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(q['question'] ?? ''),
            TextField(
              controller: controller,
              maxLines: 3,
              enabled: !_submitted,
              decoration: const InputDecoration(hintText: "Write your answer here..."),
            ),
          ],
        ),
      ),
    );
  }
}
