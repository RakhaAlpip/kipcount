import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kipcount/app/theme/app_colors.dart';
import 'package:kipcount/app/theme/app_text_styles.dart';
import 'package:kipcount/core/widgets/custom_text_field.dart';
import 'package:kipcount/core/widgets/custom_button.dart';
import 'package:kipcount/features/auth/controllers/register_controller.dart';

class RegisterScreen extends GetView<RegisterController> {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
          child: Column(
            children: [
              const SizedBox(height: 40),
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
              Text('Create Account', style: AppTextStyles.headingLarge),
              const SizedBox(height: 8),
              Text(
                'Join us and start managing your finances.',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textGrey,
                ),
              ),
              const SizedBox(height: 36),
              // Full Name Field
              CustomTextField(
                label: 'Full Name',
                hintText: 'Masukkan nama anda',
                onChanged: (val) => controller.fullName.value = val,
              ),
              const SizedBox(height: 18),
              // Email Field
              CustomTextField(
                label: 'Email',
                hintText: 'kipip@example.com',
                keyboardType: TextInputType.emailAddress,
                onChanged: (val) => controller.email.value = val,
              ),
              const SizedBox(height: 18),
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
              const SizedBox(height: 18),
              // Terms & Conditions
              Obx(
                () => Row(
                  children: [
                    GestureDetector(
                      onTap: controller.toggleTerms,
                      child: Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: controller.agreeToTerms.value
                                ? AppColors.primary
                                : AppColors.textGrey,
                            width: 2,
                          ),
                          color: controller.agreeToTerms.value
                              ? AppColors.primary
                              : Colors.transparent,
                        ),
                        child: controller.agreeToTerms.value
                            ? const Icon(
                                Icons.check,
                                color: AppColors.white,
                                size: 14,
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: AppTextStyles.bodySmall,
                          children: [
                            const TextSpan(text: 'I agree to the '),
                            TextSpan(
                              text: 'Terms and Conditions',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              // Sign Up Button
              Obx(
                () => CustomButton(
                  text: 'Sign Up',
                  isLoading: controller.isLoading.value,
                  onPressed: controller.register,
                ),
              ),
              const SizedBox(height: 24),
              // Login link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account? ',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textGrey,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Text(
                      'Log In',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
