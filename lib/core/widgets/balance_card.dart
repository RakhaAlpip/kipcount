import 'package:flutter/material.dart';
import 'package:kipcount/app/theme/app_colors.dart';
import 'package:kipcount/app/theme/app_text_styles.dart';

class BalanceCard extends StatelessWidget {
  final String totalBalance;
  final String income;
  final String expenses;
  final String savings;
  final VoidCallback? onMoreTap;

  const BalanceCard({
    super.key,
    required this.totalBalance,
    required this.income,
    required this.expenses,
    required this.savings,
    this.onMoreTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardDark.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Balance',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.white.withValues(alpha: 0.7),
                ),
              ),
              GestureDetector(
                onTap: onMoreTap,
                child: Icon(
                  Icons.more_horiz,
                  color: AppColors.white.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(totalBalance, style: AppTextStyles.balanceAmount),
          const SizedBox(height: 20),
          Row(
            children: [
              _BalanceStat(
                label: 'Income',
                value: income,
                color: AppColors.income,
                prefix: '+',
              ),
              const SizedBox(width: 16),
              _BalanceStat(
                label: 'Expenses',
                value: expenses,
                color: AppColors.expense,
                prefix: '-',
              ),
              const SizedBox(width: 16),
              _BalanceStat(
                label: 'Savings',
                value: savings,
                color: AppColors.savings,
                prefix: '+',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BalanceStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final String prefix;

  const _BalanceStat({
    required this.label,
    required this.value,
    required this.color,
    required this.prefix,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.white.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$prefix$value',
            style: AppTextStyles.bodySmall.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
