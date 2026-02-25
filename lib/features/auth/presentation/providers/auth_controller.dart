
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../data/auth_repository.dart';
import '../../data/user_model.dart';

final authControllerProvider = AsyncNotifierProvider<AuthController, void>(() {
  return AuthController();
});

class AuthController extends AsyncNotifier<void> {
  late final AuthRepository _authRepository;

  @override
  Future<void> build() async {
    _authRepository = ref.watch(authRepositoryProvider);
  }

  Future<void> signInWithPhone(String phoneNumber, {
    required Function(String, int?) onCodeSent,
    required Function(String) onVerificationFailed,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await _authRepository.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        onCodeSent: onCodeSent,
        onVerificationFailed: (e) => onVerificationFailed(e.message ?? 'Verification failed'),
        onCodeAutoRetrievalTimeout: (verificationId) {},
        onVerificationCompleted: (credential) async {
           await _authRepository.signInWithCredential(credential);
        },
      );
    });
  }

  Future<void> verifyOtp(String verificationId, String smsCode) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      final userCredential = await _authRepository.signInWithCredential(credential);
      
      final user = await _authRepository.getUserData(userCredential.user!.uid);
      if (user == null) {
        await _authRepository.saveUserData(UserModel(
          uid: userCredential.user!.uid,
          phoneNumber: userCredential.user!.phoneNumber ?? '',
          createdAt: DateTime.now(),
        ));
      }
    });
  }

  Future<void> completeProfile() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final currentUser = _authRepository.currentUser;
      if (currentUser != null) {
        await _authRepository.updateUserData(currentUser.uid, {
          'isProfileCompleted': true,
        });
      }
    });
  }

  Future<void> updateProfile({
    required String firstName,
    required String lastName,
    required String email,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final currentUser = _authRepository.currentUser;
      if (currentUser != null) {
        await _authRepository.updateUserData(currentUser.uid, {
          'firstName': firstName,
          'lastName': lastName,
          'email': email,
        });
      }
    });
  }

  Future<void> signOut() async {
     await _authRepository.signOut();
  }

  Future<void> signUpWithEmail({
    required String email,
    required String password,
    required String fullName,
    required String phone,
    required Function() onSuccess,
    required Function(String) onError,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      try {
        // 1. Create User in Firebase Auth
        final credential = await _authRepository.signUpWithEmailAndPassword(email, password);
        final user = credential.user;

        if (user != null) {
          // 2. Save User Data to Firestore
          await _authRepository.saveUserData(UserModel(
            uid: user.uid,
            phoneNumber: phone,
            createdAt: DateTime.now(),
            // Add other fields to UserModel if needed, for now just basic
          ));
          
          // 3. Update Profile (DisplayName)
          await user.updateDisplayName(fullName);

          // 4. Start OTP Verification Flow
          await _authRepository.startEmailVerification(email);
          
          onSuccess();
        }
      } on FirebaseAuthException catch (e) {
        onError(e.message ?? 'Sign up failed');
        rethrow;
      } catch (e) {
        onError(e.toString());
        rethrow;
      }
    });
  }

  Future<void> verifyEmailOtp(String email, String otp, {
    required Function() onSuccess,
    required Function(String) onError,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final isValid = await _authRepository.verifyEmailOtp(email, otp);
      if (isValid) {
        onSuccess();
      } else {
        onError('Invalid OTP');
        throw Exception('Invalid OTP');
      }
    });
  }

  Future<void> signInWithEmail(String email, String password, {
    required Function() onSuccess,
    required Function(String) onError,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      try {
        await _authRepository.signInWithEmailAndPassword(email, password);
        onSuccess();
      } on FirebaseAuthException catch (e) {
        onError(e.message ?? 'Login failed');
        rethrow;
      }
    });
  }
}
