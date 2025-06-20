import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreUserService {
  final _db = FirebaseFirestore.instance;

  Future<void> createOrUpdateUser(User user) async {
    final userDoc = _db.collection('users').doc(user.uid);

    await userDoc.set({
      'uid': user.uid,
      'name': user.displayName,
      'email': user.email,
      'photoURL': user.photoURL,
      'lastLogin': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}
