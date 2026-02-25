
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'user_model.dart';

final authRepositoryProvider = Provider((ref) => AuthRepository(
      FirebaseAuth.instance,
      FirebaseFirestore.instance,
    ));

class AuthRepository {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  AuthRepository(this._auth, this._firestore);

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required Function(String, int?) onCodeSent,
    required Function(FirebaseAuthException) onVerificationFailed,
    required Function(String) onCodeAutoRetrievalTimeout,
    required Function(PhoneAuthCredential) onVerificationCompleted,
  }) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: onVerificationCompleted,
      verificationFailed: onVerificationFailed,
      codeSent: onCodeSent,
      codeAutoRetrievalTimeout: onCodeAutoRetrievalTimeout,
    );
  }

  Future<UserCredential> signInWithCredential(PhoneAuthCredential credential) async {
    return _auth.signInWithCredential(credential);
  }

  Future<void> saveUserData(UserModel user) async {
    await _firestore.collection('users').doc(user.uid).set(user.toMap(), SetOptions(merge: true));
  }

  Future<UserModel?> getUserData(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (doc.exists) {
      return UserModel.fromMap(doc.data()!);
    }
    return null;
  }
    
    Future<void> updateUserData(String uid, Map<String, dynamic> data) async {
    await _firestore.collection('users').doc(uid).update(data);
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Email/Password Auth & OTP Logic
  final Map<String, String> _emailOtps = {}; // Mock server-side storage

  Future<UserCredential> signUpWithEmailAndPassword(String email, String password) async {
    return _auth.createUserWithEmailAndPassword(email: email, password: password);
  }

  Future<UserCredential> signInWithEmailAndPassword(String email, String password) async {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> startEmailVerification(String email) async {
    // Generate 4-digit OTP
    final otp = (1000 + (DateTime.now().millisecondsSinceEpoch % 9000)).toString();
    _emailOtps[email] = otp;
    
    // Simulate sending email by printing to console
    print('--------------------------------------------------');
    print('[MOCK EMAIL SERVICE] Sending OTP to $email: $otp');
    print('--------------------------------------------------');
    
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
  }

  Future<bool> verifyEmailOtp(String email, String otp) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));
    
    if (_emailOtps.containsKey(email) && _emailOtps[email] == otp) {
      _emailOtps.remove(email); // Invalidate OTP after use
      return true;
    }
    return false;
  }

  Future<void> sendPasswordResetEmail(String email) async {
     await _auth.sendPasswordResetEmail(email: email);
  }
}
