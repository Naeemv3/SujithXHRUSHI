import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../services/firestore_user_service.dart';

class GoogleSignInService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );
  final FirestoreUserService _firestoreService = FirestoreUserService();

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Auth state stream - FIXED: This was missing!
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<User?> signInWithGoogle() async {
    try {
      print('🔍 Starting Google Sign-In process');
      
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        print('❌ User cancelled Google Sign-In');
        return null;
      }

      print('✅ Google user obtained: ${googleUser.email}');

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      print('🔑 Google auth tokens obtained');

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      print('🎫 Firebase credential created');

      // Sign in to Firebase with the Google credential
      final UserCredential userCredential = await _auth.signInWithCredential(credential);

      print('🔥 Firebase sign-in successful: ${userCredential.user?.email}');

      // Save user data to Firestore
      if (userCredential.user != null) {
        await _firestoreService.createOrUpdateUser(userCredential.user!);
        print('💾 User data saved to Firestore');
      }

      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      print('🔥 Firebase Auth Error: ${e.code} - ${e.message}');
      throw Exception('Authentication failed: ${e.message}');
    } catch (e) {
      print('💥 Google Sign-In Error: $e');
      throw Exception('Sign-in failed: $e');
    }
  }

  Future<void> signOut() async {
    try {
      print('🚪 Starting sign out process');
      await Future.wait([
        _googleSignIn.signOut(),
        _auth.signOut(),
      ]);
      print('✅ Sign out successful');
    } catch (e) {
      print('💥 Sign out error: $e');
      throw Exception('Sign out failed: $e');
    }
  }

  // Check if user is signed in
  bool get isSignedIn => _auth.currentUser != null;

  // Get user display name
  String get userDisplayName => _auth.currentUser?.displayName ?? 'User';

  // Get user email
  String get userEmail => _auth.currentUser?.email ?? '';

  // Get user photo URL
  String? get userPhotoURL => _auth.currentUser?.photoURL;
}