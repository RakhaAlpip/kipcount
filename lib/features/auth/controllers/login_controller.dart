import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginController extends GetxController {
  final email = ''.obs;
  final password = ''.obs;
  final isLoading = false.obs;
  final isPasswordVisible = false.obs;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  void togglePasswordVisibility() {
    isPasswordVisible.toggle();
  }

  void login() async {
    if (email.value.isEmpty || password.value.isEmpty) {
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

    isLoading.value = true;
    try {
      await _auth.signInWithEmailAndPassword(
        email: email.value.trim(),
        password: password.value,
      );
      Get.offAllNamed('/main');
    } on FirebaseAuthException catch (e) {
      String message = 'Login failed';
      switch (e.code) {
        case 'user-not-found':
          message = 'No user found with this email.';
          break;
        case 'wrong-password':
          message = 'Wrong password.';
          break;
        case 'invalid-email':
          message = 'Invalid email address.';
          break;
        case 'invalid-credential':
          message =
              'Invalid credentials. Please check your email and password.';
          break;
        default:
          message = e.message ?? 'Login failed';
      }
      Get.snackbar('Error', message, snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Login failed: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
