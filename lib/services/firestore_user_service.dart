import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreUserService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> createOrUpdateUser(User user) async {
    try {
      final userDoc = _db.collection('users').doc(user.uid);

      // Check if user document exists
      final docSnapshot = await userDoc.get();
      
      final userData = {
        'uid': user.uid,
        'email': user.email,
        'displayName': user.displayName,
        'photoURL': user.photoURL,
        'lastLogin': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (!docSnapshot.exists) {
        // Create new user document
        userData['createdAt'] = FieldValue.serverTimestamp();
        userData['profileCompleted'] = false;
        userData['isActive'] = true;
      }

      await userDoc.set(userData, SetOptions(merge: true));
      
      print('User data saved successfully for ${user.email}');
    } catch (e) {
      print('Error saving user data: $e');
      throw Exception('Failed to save user data: $e');
    }
  }

  Future<Map<String, dynamic>?> getUserData(String uid) async {
    try {
      final doc = await _db.collection('users').doc(uid).get();
      return doc.exists ? doc.data() : null;
    } catch (e) {
      print('Error getting user data: $e');
      return null;
    }
  }

  Future<void> updateUserProfile({
    required String uid,
    required Map<String, dynamic> profileData,
  }) async {
    try {
      await _db.collection('users').doc(uid).update({
        ...profileData,
        'profileCompleted': true,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error updating user profile: $e');
      throw Exception('Failed to update profile: $e');
    }
  }

  Stream<DocumentSnapshot> getUserStream(String uid) {
    return _db.collection('users').doc(uid).snapshots();
  }

  Future<bool> isProfileCompleted(String uid) async {
    try {
      final doc = await _db.collection('users').doc(uid).get();
      return doc.data()?['profileCompleted'] ?? false;
    } catch (e) {
      print('Error checking profile completion: $e');
      return false;
    }
  }
}