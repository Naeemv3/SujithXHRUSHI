import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/firestore_user_service.dart';

class ProfileFormScreen extends StatefulWidget {
  const ProfileFormScreen({super.key});

  @override
  State<ProfileFormScreen> createState() => _ProfileFormScreenState();
}

class _ProfileFormScreenState extends State<ProfileFormScreen> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _firestoreService = FirestoreUserService();
  
  final _nameController = TextEditingController();
  final _collegeController = TextEditingController();
  final _passingYearController = TextEditingController();
  final _degreeController = TextEditingController();
  final _skillsController = TextEditingController();
  final _projectLinksController = TextEditingController();
  final _resumeLinkController = TextEditingController();
  final _socialsController = TextEditingController();

  bool _isSubmitting = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
    _loadExistingProfile();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _nameController.dispose();
    _collegeController.dispose();
    _passingYearController.dispose();
    _degreeController.dispose();
    _skillsController.dispose();
    _projectLinksController.dispose();
    _resumeLinkController.dispose();
    _socialsController.dispose();
    super.dispose();
  }

  Future<void> _loadExistingProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userData = await _firestoreService.getUserData(user.uid);
      if (userData != null && mounted) {
        setState(() {
          _nameController.text = userData['fullName'] ?? userData['displayName'] ?? '';
          _collegeController.text = userData['college'] ?? '';
          _passingYearController.text = userData['passingYear'] ?? '';
          _degreeController.text = userData['degree'] ?? '';
          _skillsController.text = (userData['skills'] as List<dynamic>?)?.join(', ') ?? '';
          _projectLinksController.text = userData['projectLinks'] ?? '';
          _resumeLinkController.text = userData['resumeLink'] ?? '';
          _socialsController.text = userData['socialLinks'] ?? '';
        });
      }
    }
  }

  Future<void> _submitProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('User not authenticated');

      final profileData = {
        'fullName': _nameController.text.trim(),
        'college': _collegeController.text.trim(),
        'passingYear': _passingYearController.text.trim(),
        'degree': _degreeController.text.trim(),
        'skills': _skillsController.text
            .split(',')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList(),
        'projectLinks': _projectLinksController.text.trim(),
        'resumeLink': _resumeLinkController.text.trim(),
        'socialLinks': _socialsController.text.trim(),
      };

      await _firestoreService.updateUserProfile(
        uid: user.uid,
        profileData: profileData,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 12),
                Text('Profile saved successfully!'),
              ],
            ),
            backgroundColor: const Color(0xFF10B981),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        );

        // Navigate to home screen
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error, color: Colors.white),
                const SizedBox(width: 12),
                Text('Error: ${e.toString()}'),
              ],
            ),
            backgroundColor: Colors.red.shade400,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          'Build Your Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF6366F1).withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.person_rounded,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 16),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Complete Your Profile',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Help us understand your skills and background',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Form Fields
                _buildFormField(
                  controller: _nameController,
                  label: 'Full Name',
                  hint: 'Enter your full name',
                  icon: Icons.person_rounded,
                  validator: (val) => val?.isEmpty == true ? 'Full name is required' : null,
                ),

                const SizedBox(height: 24),

                _buildFormField(
                  controller: _collegeController,
                  label: 'College/University',
                  hint: 'Enter your college or university name',
                  icon: Icons.school_rounded,
                  validator: (val) => val?.isEmpty == true ? 'College name is required' : null,
                ),

                const SizedBox(height: 24),

                Row(
                  children: [
                    Expanded(
                      child: _buildFormField(
                        controller: _passingYearController,
                        label: 'Year of Passing',
                        hint: 'e.g., 2024',
                        icon: Icons.calendar_today_rounded,
                        keyboardType: TextInputType.number,
                        validator: (val) => val?.isEmpty == true ? 'Passing year is required' : null,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildFormField(
                        controller: _degreeController,
                        label: 'Degree',
                        hint: 'e.g., B.Tech CSE',
                        icon: Icons.school_rounded,
                        validator: (val) => val?.isEmpty == true ? 'Degree is required' : null,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                _buildFormField(
                  controller: _skillsController,
                  label: 'Skills',
                  hint: 'Enter skills separated by commas (e.g., Flutter, Python, UI/UX)',
                  icon: Icons.psychology_rounded,
                  validator: (val) => val?.isEmpty == true ? 'Skills are required' : null,
                ),

                const SizedBox(height: 24),

                _buildFormField(
                  controller: _projectLinksController,
                  label: 'Project Links',
                  hint: 'GitHub, portfolio, or project URLs',
                  icon: Icons.link_rounded,
                  keyboardType: TextInputType.url,
                ),

                const SizedBox(height: 24),

                _buildFormField(
                  controller: _resumeLinkController,
                  label: 'Resume Link',
                  hint: 'Google Drive or cloud storage link to your resume',
                  icon: Icons.description_rounded,
                  keyboardType: TextInputType.url,
                ),

                const SizedBox(height: 24),

                _buildFormField(
                  controller: _socialsController,
                  label: 'Social Media Links',
                  hint: 'LinkedIn, Twitter, or other professional profiles',
                  icon: Icons.share_rounded,
                  keyboardType: TextInputType.url,
                ),

                const SizedBox(height: 32),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _isSubmitting ? null : _submitProfile,
                    icon: _isSubmitting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Icon(Icons.save_rounded, size: 20),
                    label: Text(
                      _isSubmitting ? 'Saving Profile...' : 'Save Profile',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6366F1),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: const Color(0xFF6366F1),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade500),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF6366F1), width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.red.shade400),
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
        ),
      ],
    );
  }
}