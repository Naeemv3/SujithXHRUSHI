import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileFormScreen extends StatefulWidget {
  @override
  _ProfileFormScreenState createState() => _ProfileFormScreenState();
}

class _ProfileFormScreenState extends State<ProfileFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  final nameController = TextEditingController();
  final collegeController = TextEditingController();
  final passingYearController = TextEditingController();
  final degreeController = TextEditingController();
  final skillsController = TextEditingController();
  final projectLinksController = TextEditingController();
  final resumeLinkController = TextEditingController();
  final socialsController = TextEditingController();

  Future<void> _submitProfile() async {
    if (!_formKey.currentState!.validate()) return;

    final user = _auth.currentUser;
    if (user == null) return;

    final profileData = {
      'name': nameController.text.trim(),
      'college': collegeController.text.trim(),
      'passingYear': passingYearController.text.trim(),
      'degree': degreeController.text.trim(),
      'skills': skillsController.text.trim().split(','),
      'projects': projectLinksController.text.trim(),
      'resumeLink': resumeLinkController.text.trim(),
      'socials': socialsController.text.trim(),
      'createdAt': FieldValue.serverTimestamp(),
    };

    await _db.collection('users').doc(user.uid).collection('profile').doc('info').set(profileData);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Profile saved! ✅")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Build Your Profile")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildField("Full Name", nameController),
              _buildField("College", collegeController),
              _buildField("Year of Passing", passingYearController, keyboardType: TextInputType.number),
              _buildField("Degree of Qualification", degreeController),
              _buildField("Skills (comma separated)", skillsController),
              _buildField("Projects (URLs)", projectLinksController),
              _buildField("Resume Drive Link", resumeLinkController),
              _buildField("Social Media Links", socialsController),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitProfile,
                child: Text("Submit Profile"),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController controller, {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        validator: (value) => value == null || value.isEmpty ? "Required field" : null,
      ),
    );
  }
}
