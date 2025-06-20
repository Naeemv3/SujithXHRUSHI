import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseTestService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // Test Firestore connection
  static Future<bool> testFirestoreConnection() async {
    try {
      await _firestore.collection('test').doc('connection').set({
        'timestamp': FieldValue.serverTimestamp(),
        'status': 'connected',
      });
      
      print('✅ Firestore connection successful');
      return true;
    } catch (e) {
      print('❌ Firestore connection failed: $e');
      return false;
    }
  }

  // Test Firebase Auth
  static Future<bool> testFirebaseAuth() async {
    try {
      final user = _auth.currentUser;
      print('✅ Firebase Auth initialized. Current user: ${user?.email ?? 'None'}');
      return true;
    } catch (e) {
      print('❌ Firebase Auth test failed: $e');
      return false;
    }
  }

  // Test data operations
  static Future<bool> testDataOperations() async {
    try {
      // Test write
      final docRef = await _firestore.collection('test_data').add({
        'message': 'Test data operation',
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Test read
      final doc = await docRef.get();
      if (doc.exists) {
        print('✅ Data operations test successful');
        
        // Clean up test data
        await docRef.delete();
        return true;
      }
      
      return false;
    } catch (e) {
      print('❌ Data operations test failed: $e');
      return false;
    }
  }

  // Run all tests
  static Future<void> runAllTests() async {
    print('🔍 Running Firebase integration tests...\n');
    
    await testFirebaseAuth();
    await testFirestoreConnection();
    await testDataOperations();
    
    print('\n✅ Firebase integration tests completed');
  }
}