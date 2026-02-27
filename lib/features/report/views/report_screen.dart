import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:kipcount/app/theme/app_colors.dart';
import 'package:kipcount/app/theme/app_text_styles.dart';
import 'package:kipcount/features/report/controllers/report_controller.dart';

class ReportScreen extends GetView<ReportController> {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Financial Report'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert_rounded),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            _buildPeriodToggle(),
            const SizedBox(height: 24),
            _buildSectionTitle('Executive Summary'),
            const SizedBox(height: 14),
            _buildSummaryCards(),
            const SizedBox(height: 12),
            _buildHealthIndicator(),
            const SizedBox(height: 28),
            _buildSectionTitle('Income vs Expense Trend'),
            const SizedBox(height: 14),
            _buildLineChart(),
            const SizedBox(height: 28),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSectionTitle('Expense Breakdown'),
                Text(
                  'View All',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            _buildDonutChart(),
            const SizedBox(height: 28),
            _buildSectionTitle('Period Comparison'),
            const SizedBox(height: 14),
            _buildPeriodComparison(),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title, style: AppTextStyles.headingSmall);
  }

  Widget _buildPeriodToggle() {
    final periods = ['Weekly', 'Monthly', 'Yearly'];
    return Obx(
      () => Container(
        padding: const EdgeInsets.all(4),
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
        child: Row(
          children: List.generate(3, (index) {
            final isSelected = controller.selectedPeriod.value == index;
            return Expanded(
              child: GestureDetector(
                onTap: () => controller.changePeriod(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.white : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: AppColors.shadow,
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : [],
                  ),
                  child: Text(
                    periods[index],
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w400,
                      color: isSelected
                          ? AppColors.textDark
                          : AppColors.textGrey,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildSummaryCards() {
    return Obx(
      () => Column(
        children: [
          _SummaryCard(
            label: 'Total Income',
            amount: controller.totalIncome.value,
            bgColor: AppColors.incomeBackground,
            textColor: AppColors.income,
            icon: Icons.trending_up_rounded,
          ),
          const SizedBox(height: 10),
          _SummaryCard(
            label: 'Total Expenses',
            amount: controller.totalExpenses.value,
            bgColor: AppColors.expenseBackground,
            textColor: AppColors.expense,
            icon: Icons.trending_down_rounded,
          ),
          const SizedBox(height: 10),
          _SummaryCard(
            label: 'Net Savings',
            amount: controller.netSavings.value,
            bgColor: AppColors.savingsBackground,
            textColor: AppColors.savings,
            icon: Icons.account_balance_rounded,
          ),
        ],
      ),
    );
  }

  Widget _buildHealthIndicator() {
    return Obx(() {
      Color statusColor;
      switch (controller.healthStatus.value) {
        case 'Excellent':
          statusColor = AppColors.income;
          break;
        case 'Good':
          statusColor = AppColors.savings;
          break;
        case 'Needs Attention':
          statusColor = AppColors.expense;
          break;
        default:
          statusColor = AppColors.textGrey;
      }

      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                style: AppTextStyles.bodyMedium,
                children: [
                  const TextSpan(text: 'Financial Health: '),
                  TextSpan(
                    text: controller.healthStatus.value,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: statusColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            Text(
              controller.healthMessage.value,
              style: AppTextStyles.bodySmall,
            ),
          ],
        ),
      );
    });
  }

  Widget _buildLineChart() {
    return Obx(() {
      final income = controller.rawIncome.value;
      final expenses = controller.rawExpenses.value;
      final maxY = (income > expenses ? income : expenses);

      // If no data, show empty state
      if (income == 0 && expenses == 0) {
        return Container(
          height: 200,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.show_chart_rounded,
                  size: 48,
                  color: AppColors.textGrey.withValues(alpha: 0.4),
                ),
                const SizedBox(height: 12),
                Text('No transaction data yet', style: AppTextStyles.bodySmall),
                Text(
                  'Add transactions to see trends',
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ),
        );
      }

      return Container(
        height: 200,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: maxY * 1.3,
            barTouchData: BarTouchData(enabled: false),
            titlesData: FlTitlesData(
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              leftTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    switch (value.toInt()) {
                      case 0:
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text('Income', style: AppTextStyles.caption),
                        );
                      case 1:
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text('Expenses', style: AppTextStyles.caption),
                        );
                      default:
                        return const SizedBox();
                    }
                  },
                ),
              ),
            ),
            borderData: FlBorderData(show: false),
            gridData: const FlGridData(show: false),
            barGroups: [
              BarChartGroupData(
                x: 0,
                barRods: [
                  BarChartRodData(
                    toY: income,
                    color: AppColors.income,
                    width: 32,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ],
              ),
              BarChartGroupData(
                x: 1,
                barRods: [
                  BarChartRodData(
                    toY: expenses,
                    color: AppColors.expense,
                    width: 32,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildDonutChart() {
    return Obx(() {
      final breakdown = controller.expenseBreakdown;

      if (breakdown.isEmpty) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Column(
                children: [
                  Icon(
                    Icons.donut_large_rounded,
                    size: 48,
                    color: AppColors.textGrey.withValues(alpha: 0.4),
                  ),
                  const SizedBox(height: 12),
                  Text('No expenses recorded', style: AppTextStyles.bodySmall),
                ],
              ),
            ),
          ),
        );
      }

      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            SizedBox(
              height: 180,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 3,
                  centerSpaceRadius: 50,
                  sections: breakdown.map((item) {
                    return PieChartSectionData(
                      value: (item['rawAmount'] as num).toDouble(),
                      color: Color(item['color']),
                      radius: 35,
                      showTitle: false,
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Legend
            Wrap(
              spacing: 16,
              runSpacing: 10,
              children: breakdown.map((item) {
                return SizedBox(
                  width: 140,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: Color(item['color']),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          '${item['label']} ${item['amount']}',
                          style: AppTextStyles.bodySmall,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildPeriodComparison() {
    return Obx(
      () => Column(
        children: [
          _ComparisonCard(
            label: 'Income',
            amount: controller.comparisonIncome.value,
            change: controller.incomeChange.value,
            isPositive: controller.incomeChangePositive.value,
            subtitle: 'vs last period',
          ),
          const SizedBox(height: 10),
          _ComparisonCard(
            label: 'Expenses',
            amount: controller.comparisonExpenses.value,
            change: controller.expenseChange.value,
            isPositive: controller.expenseChangePositive.value,
            subtitle: 'vs last period',
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String label;
  final String amount;
  final Color bgColor;
  final Color textColor;
  final IconData icon;

  const _SummaryCard({
    required this.label,
    required this.amount,
    required this.bgColor,
    required this.textColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.bodySmall.copyWith(color: textColor),
                ),
                const SizedBox(height: 4),
                Text(
                  amount,
                  style: AppTextStyles.headingMedium.copyWith(color: textColor),
                ),
              ],
            ),
          ),
          Icon(icon, color: textColor, size: 28),
        ],
      ),
    );
  }
}

class _ComparisonCard extends StatelessWidget {
  final String label;
  final String amount;
  final String change;
  final bool isPositive;
  final String subtitle;

  const _ComparisonCard({
    required this.label,
    required this.amount,
    required this.change,
    required this.isPositive,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyles.bodyMedium),
          const SizedBox(height: 6),
          Row(
            children: [
              Text(amount, style: AppTextStyles.headingMedium),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: isPositive
                      ? AppColors.incomeBackground
                      : AppColors.expenseBackground,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$change $subtitle',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: isPositive ? AppColors.income : AppColors.expense,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
