import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreateProjectScreen extends StatefulWidget {
  const CreateProjectScreen({super.key});

  @override
  State<CreateProjectScreen> createState() => _CreateProjectScreenState();
}

class _CreateProjectScreenState extends State<CreateProjectScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _skillsController = TextEditingController();
  final _companyController = TextEditingController();

  Future<void> _submitProject() async {
    if (_formKey.currentState?.validate() != true) return;

    await FirebaseFirestore.instance.collection('projects').add({
      'title': _titleController.text,
      'description': _descriptionController.text,
      'requiredSkills': _skillsController.text.split(',').map((e) => e.trim()).toList(),
      'company': _companyController.text,
      'createdAt': DateTime.now().toIso8601String(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Project created successfully")),
    );

    _formKey.currentState?.reset();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user?.email != 'admin@example.com') {
      return const Scaffold(
        body: Center(child: Text("Access denied: Admins only")),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Create Project")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: "Project Title"),
                validator: (val) => val!.isEmpty ? "Title required" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: "Description"),
                maxLines: 3,
                validator: (val) => val!.isEmpty ? "Description required" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _skillsController,
                decoration: const InputDecoration(
                  labelText: "Required Skills (comma-separated)",
                ),
                validator: (val) => val!.isEmpty ? "Skills required" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _companyController,
                decoration: const InputDecoration(labelText: "Company Name"),
                validator: (val) => val!.isEmpty ? "Company name required" : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitProject,
                child: const Text("Create Project"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
