import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kipcount/app/theme/app_colors.dart';
import 'package:kipcount/app/theme/app_text_styles.dart';
import 'package:kipcount/core/widgets/section_header.dart';
import 'package:kipcount/core/widgets/transaction_tile.dart';
import 'package:kipcount/features/wallet/controllers/wallet_controller.dart';

class WalletScreen extends GetView<WalletController> {
  const WalletScreen({super.key});

  IconData _getIcon(String iconName) {
    switch (iconName) {
      case 'account_balance':
        return Icons.account_balance_rounded;
      case 'savings':
        return Icons.savings_rounded;
      case 'credit_card':
        return Icons.credit_card_rounded;
      case 'shopping_cart':
        return Icons.shopping_cart_rounded;
      default:
        return Icons.receipt_rounded;
    }
  }

  Color _getTxBgColor(String type) {
    switch (type) {
      case 'grocery':
        return AppColors.groceryBg;
      case 'salary':
        return AppColors.salaryBg;
      default:
        return AppColors.primaryLight;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Wallet'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.add_rounded,
                color: AppColors.primary,
                size: 22,
              ),
            ),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            // Total Balance Card
            _buildTotalBalanceCard(),
            const SizedBox(height: 24),
            // My Accounts
            Text('My Accounts', style: AppTextStyles.headingSmall),
            const SizedBox(height: 14),
            Obx(
              () => Column(
                children: controller.accounts.map((account) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildAccountCard(account),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),
            // Recent Transactions
            SectionHeader(
              title: 'Recent Transactions',
              actionText: 'View All',
              onActionTap: () {},
            ),
            const SizedBox(height: 14),
            Obx(
              () => Column(
                children: controller.recentTransactions.map((tx) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: TransactionTile(
                      icon: _getIcon(tx['icon']),
                      iconBgColor: _getTxBgColor(tx['bgColor']),
                      title: tx['title'],
                      subtitle: tx['subtitle'],
                      amount: tx['amount'],
                      isPositive: tx['isPositive'],
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalBalanceCard() {
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
          Text(
            'Total Balance',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.white.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 8),
          Obx(
            () => Text(
              controller.totalBalance.value,
              style: AppTextStyles.balanceAmount,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountCard(Map<String, dynamic> account) {
    final color = Color(account['color']);
    return Container(
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
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(_getIcon(account['icon']), color: color, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      account['name'],
                      style: AppTextStyles.bodyLarge.copyWith(fontSize: 15),
                    ),
                    const SizedBox(height: 3),
                    Text(account['number'], style: AppTextStyles.bodySmall),
                  ],
                ),
              ),
              Text(
                account['balance'],
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: () {},
              child: Text(
                'View Details',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
