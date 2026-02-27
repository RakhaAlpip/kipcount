import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kipcount/app/theme/app_colors.dart';
import 'package:kipcount/app/theme/app_text_styles.dart';
import 'package:kipcount/core/widgets/custom_text_field.dart';
import 'package:kipcount/features/dashboard/controllers/dashboard_controller.dart';

class ProfileController extends GetxController {
  final userName = ''.obs;
  final email = ''.obs;
  final selectedLanguage = 'English'.obs;
  final isLoading = false.obs;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    _loadUserData();
  }

  void _loadUserData() {
    final user = _auth.currentUser;
    if (user != null) {
      userName.value =
          user.displayName ?? user.email?.split('@').first ?? 'User';
      email.value = user.email ?? '';
    }
  }

  void showChangeNameDialog() {
    final nameController = TextEditingController(text: userName.value);

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Change Name', style: AppTextStyles.headingSmall),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextField(
              label: 'Full Name',
              hintText: 'Enter your new name',
              controller: nameController,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textGrey,
              ),
            ),
          ),
          TextButton(
            onPressed: () => _updateName(nameController.text.trim()),
            child: Text(
              'Save',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _updateName(String newName) async {
    if (newName.isEmpty) {
      Get.snackbar(
        'Error',
        'Name cannot be empty',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading.value = true;
    try {
      final user = _auth.currentUser;
      if (user != null) {
        // Update Firebase Auth display name
        await user.updateDisplayName(newName);

        // Update Firestore user document
        await _firestore.collection('users').doc(user.uid).update({
          'fullName': newName,
        });

        userName.value = newName;

        // Also refresh dashboard user name
        if (Get.isRegistered<DashboardController>()) {
          Get.find<DashboardController>().refreshUserName();
        }

        Get.back(); // Close dialog
        Get.snackbar(
          'Success',
          'Name updated successfully!',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update name: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void logout() async {
    await _auth.signOut();
    Get.offAllNamed('/login');
  }
}
