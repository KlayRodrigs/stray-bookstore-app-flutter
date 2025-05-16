import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:stray_bookstore_app/app/repositories/errors/signup_error.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<bool> isEmailVerified() async {
    final user = _auth.currentUser;
    if (user != null) {
      await user.reload();
      return user.emailVerified;
    }
    return false;
  }

  Future<void> sendEmailVerification() async {
    final user = _auth.currentUser;
    if (user != null) {
      await user.sendEmailVerification();
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Stream<User?> authStateChanges() {
    return _auth.authStateChanges();
  }

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  Future<UserCredential?> signIn(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<UserCredential?> signUp(String email, String password) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);

      await userCredential.user?.sendEmailVerification();

      final userData = {'email': email, 'createdAt': FieldValue.serverTimestamp(), 'updatedAt': FieldValue.serverTimestamp(), 'isVerified': false};

      await _firestore.collection('users').doc(userCredential.user?.uid).set(userData);

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseError(e);
    } catch (e) {
      throw SignupError.unknown;
    }
  }

  SignupError _handleFirebaseError(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return SignupError.emailAlreadyInUse;
      case 'invalid-email':
        return SignupError.invalidEmail;
      case 'weak-password':
        return SignupError.weakPassword;
      default:
        return SignupError.unknown;
    }
  }
}
