import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kipcount/app/theme/app_colors.dart';
import 'package:kipcount/app/theme/app_text_styles.dart';
import 'package:kipcount/core/widgets/custom_text_field.dart';
import 'package:kipcount/core/widgets/custom_button.dart';
import 'package:kipcount/features/auth/controllers/login_controller.dart';

class LoginScreen extends GetView<LoginController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
          child: Column(
            children: [
              const SizedBox(height: 48),
              // Bank Icon
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(
                  Icons.account_balance_rounded,
                  color: AppColors.primary,
                  size: 36,
                ),
              ),
              const SizedBox(height: 28),
              // Title
              Text('Welcome Back', style: AppTextStyles.headingLarge),
              const SizedBox(height: 8),
              Text(
                'Log in to manage your finances.',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textGrey,
                ),
              ),
              const SizedBox(height: 40),
              // Email Field
              CustomTextField(
                label: 'Email',
                hintText: 'you@example.com',
                keyboardType: TextInputType.emailAddress,
                onChanged: (val) => controller.email.value = val,
              ),
              const SizedBox(height: 20),
              // Password Field
              Obx(
                () => CustomTextField(
                  label: 'Password',
                  hintText: '••••••••',
                  obscureText: !controller.isPasswordVisible.value,
                  suffixIcon: controller.isPasswordVisible.value
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  onSuffixTap: controller.togglePasswordVisibility,
                  onChanged: (val) => controller.password.value = val,
                ),
              ),
              const SizedBox(height: 12),
              // Forgot Password
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    // TODO: Navigate to forgot password
                  },
                  child: Text(
                    'Forgot Password?',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              // Login Button
              Obx(
                () => CustomButton(
                  text: 'Log In',
                  isLoading: controller.isLoading.value,
                  onPressed: controller.login,
                ),
              ),
              const SizedBox(height: 24),
              // Sign Up link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textGrey,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Get.toNamed('/register'),
                    child: Text(
                      'Sign Up',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
