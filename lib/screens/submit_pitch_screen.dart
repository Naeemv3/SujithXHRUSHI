import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SubmitPitchScreen extends StatefulWidget {
  final String projectId;

  const SubmitPitchScreen({super.key, required this.projectId});

  @override
  State<SubmitPitchScreen> createState() => _SubmitPitchScreenState();
}

class _SubmitPitchScreenState extends State<SubmitPitchScreen> {
  final _formKey = GlobalKey<FormState>();
  final _textController = TextEditingController();
  final _videoController = TextEditingController();
  final _driveLinkController = TextEditingController();

  Future<void> _submitPitch() async {
    if (_formKey.currentState?.validate() != true) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance
        .collection('projects')
        .doc(widget.projectId)
        .collection('pitches')
        .add({
      'userId': user.uid,
      'userEmail': user.email,
      'text': _textController.text,
      'video': _videoController.text,
      'driveLink': _driveLinkController.text,
      'submittedAt': Timestamp.now(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Pitch submitted successfully")),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Submit Your Pitch")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _textController,
                maxLines: 5,
                decoration: const InputDecoration(labelText: "Text Write-up"),
                validator: (val) => val!.isEmpty ? "Enter your write-up" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _videoController,
                decoration: const InputDecoration(labelText: "Video URL (optional)"),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _driveLinkController,
                decoration: const InputDecoration(labelText: "Drive Link (must be public)"),
                validator: (val) => val!.isEmpty ? "Enter your Drive link" : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitPitch,
                child: const Text("Submit"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
