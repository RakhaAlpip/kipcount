import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterController extends GetxController {
  final fullName = ''.obs;
  final email = ''.obs;
  final password = ''.obs;
  final isLoading = false.obs;
  final isPasswordVisible = false.obs;
  final agreeToTerms = false.obs;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void togglePasswordVisibility() {
    isPasswordVisible.toggle();
  }

  void toggleTerms() {
    agreeToTerms.toggle();
  }

  void register() async {
    if (fullName.value.isEmpty ||
        email.value.isEmpty ||
        password.value.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill in all fields',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (!email.value.contains('@')) {
      Get.snackbar(
        'Error',
        'Please enter a valid email address',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (password.value.length < 6) {
      Get.snackbar(
        'Error',
        'Password must be at least 6 characters',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (!agreeToTerms.value) {
      Get.snackbar(
        'Error',
        'Please agree to the Terms and Conditions',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading.value = true;
    try {
      // Create user with Firebase Auth
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.value.trim(),
        password: password.value,
      );

      // Update display name
      await credential.user?.updateDisplayName(fullName.value.trim());

      // Save user profile to Firestore
      await _firestore.collection('users').doc(credential.user!.uid).set({
        'fullName': fullName.value.trim(),
        'email': email.value.trim(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      Get.offAllNamed('/main');
    } on FirebaseAuthException catch (e) {
      String message = 'Registration failed';
      switch (e.code) {
        case 'email-already-in-use':
          message = 'This email is already registered.';
          break;
        case 'weak-password':
          message = 'Password is too weak. Use at least 6 characters.';
          break;
        case 'invalid-email':
          message = 'Invalid email address.';
          break;
        default:
          message = e.message ?? 'Registration failed';
      }
      Get.snackbar('Error', message, snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Registration failed: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
