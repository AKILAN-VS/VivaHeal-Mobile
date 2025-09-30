import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<Map<String, dynamic>?> loginPatient(
    {required String email, required String password}) async {
  try {
    // 1. Sign in with email and password
    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);

    final uid = userCredential.user?.uid;
    if (uid == null) return null;

    // 2. Fetch patient data from Firestore
    DocumentSnapshot patientSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    if (!patientSnapshot.exists) return null;

    return patientSnapshot.data() as Map<String, dynamic>;
  } on FirebaseAuthException catch (e) {
    print('Login Error: ${e.code} - ${e.message}');
    return null;
  } catch (e) {
    print('Unknown Error: $e');
    return null;
  }
}
