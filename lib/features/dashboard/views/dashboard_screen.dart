import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kipcount/app/theme/app_colors.dart';
import 'package:kipcount/app/theme/app_text_styles.dart';
import 'package:kipcount/core/widgets/balance_card.dart';
import 'package:kipcount/core/widgets/section_header.dart';
import 'package:kipcount/core/widgets/transaction_tile.dart';
import 'package:kipcount/features/dashboard/controllers/dashboard_controller.dart';

class DashboardScreen extends GetView<DashboardController> {
  const DashboardScreen({super.key});

  IconData _getIcon(String iconName) {
    switch (iconName) {
      case 'shopping_cart':
        return Icons.shopping_cart_rounded;
      case 'account_balance':
        return Icons.account_balance_rounded;
      case 'play_circle':
        return Icons.play_circle_rounded;
      case 'bolt':
        return Icons.bolt_rounded;
      case 'home':
        return Icons.home_rounded;
      default:
        return Icons.receipt_rounded;
    }
  }

  Color _getBgColor(String type) {
    switch (type) {
      case 'grocery':
        return AppColors.groceryBg;
      case 'salary':
        return AppColors.salaryBg;
      case 'entertainment':
        return AppColors.entertainmentBg;
      case 'utility':
        return AppColors.utilityBg;
      case 'rent':
        return AppColors.rentBg;
      default:
        return AppColors.primaryLight;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              // App Bar
              _buildAppBar(),
              const SizedBox(height: 24),
              // Balance Card
              Obx(
                () => BalanceCard(
                  totalBalance: controller.totalBalance.value,
                  income: controller.income.value,
                  expenses: controller.expenses.value,
                  savings: controller.savings.value,
                ),
              ),
              const SizedBox(height: 28),
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
                        iconBgColor: _getBgColor(tx['bgColor']),
                        title: tx['title'],
                        subtitle: tx['subtitle'],
                        amount: tx['amount'],
                        isPositive: tx['isPositive'],
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 20),
              // Upcoming Bills
              SectionHeader(
                title: 'Upcoming Bills',
                actionText: 'View All',
                onActionTap: () {},
              ),
              const SizedBox(height: 14),
              Obx(
                () => Column(
                  children: controller.upcomingBills.map((bill) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: TransactionTile(
                        icon: _getIcon(bill['icon']),
                        iconBgColor: _getBgColor(bill['bgColor']),
                        title: bill['title'],
                        subtitle: bill['subtitle'],
                        amount: bill['amount'],
                        isPositive: false,
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Row(
      children: [
        // Avatar
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primaryLight,
            border: Border.all(color: AppColors.primary, width: 2),
          ),
          child: const Icon(
            Icons.person_rounded,
            color: AppColors.primary,
            size: 24,
          ),
        ),
        const SizedBox(width: 12),
        // Greeting
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Welcome back,', style: AppTextStyles.bodySmall),
            Obx(
              () => Text(
                controller.userName.value,
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const Spacer(),
        // Search Icon
        _buildIconButton(Icons.search_rounded),
        const SizedBox(width: 8),
        // Notification Icon
        _buildIconButton(Icons.notifications_outlined),
      ],
    );
  }

  Widget _buildIconButton(IconData icon) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(icon, color: AppColors.textDark, size: 22),
    );
  }
}
