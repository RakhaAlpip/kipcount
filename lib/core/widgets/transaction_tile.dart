import 'package:flutter/material.dart';
import 'package:kipcount/app/theme/app_colors.dart';
import 'package:kipcount/app/theme/app_text_styles.dart';

class TransactionTile extends StatelessWidget {
  final IconData icon;
  final Color iconBgColor;
  final Color? iconColor;
  final String title;
  final String subtitle;
  final String amount;
  final bool isPositive;
  final VoidCallback? onTap;

  const TransactionTile({
    super.key,
    required this.icon,
    required this.iconBgColor,
    this.iconColor,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.isPositive,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: iconColor ?? AppColors.textDark,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.bodyLarge.copyWith(fontSize: 15),
                  ),
                  const SizedBox(height: 3),
                  Text(subtitle, style: AppTextStyles.bodySmall),
                ],
              ),
            ),
            Text(
              amount,
              style: AppTextStyles.bodyLarge.copyWith(
                color: isPositive ? AppColors.income : AppColors.textDark,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
