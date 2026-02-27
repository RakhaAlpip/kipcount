import 'package:flutter/material.dart';
import 'package:kipcount/app/theme/app_colors.dart';
import 'package:kipcount/app/theme/app_text_styles.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final String? actionText;
  final VoidCallback? onActionTap;

  const SectionHeader({
    super.key,
    required this.title,
    this.actionText,
    this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTextStyles.headingSmall),
        if (actionText != null)
          GestureDetector(
            onTap: onActionTap,
            child: Text(
              actionText!,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }
}
