import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ReportController extends GetxController {
  final selectedPeriod = 1.obs; // 0=Weekly, 1=Monthly, 2=Yearly
  final totalIncome = 'Rp0'.obs;
  final totalExpenses = 'Rp0'.obs;
  final netSavings = 'Rp0'.obs;
  final healthStatus = 'No Data'.obs;
  final healthMessage =
      'Add some transactions to see your financial health.'.obs;

  // Raw values for charts
  final rawIncome = 0.0.obs;
  final rawExpenses = 0.0.obs;

  final expenseBreakdown = <Map<String, dynamic>>[].obs;

  // Line chart data (monthly income & expense per month)
  final incomeSpots = <Map<String, dynamic>>[].obs;
  final expenseSpots = <Map<String, dynamic>>[].obs;

  // Period comparison
  final comparisonIncome = '\$0.00'.obs;
  final comparisonExpenses = '\$0.00'.obs;
  final incomeChange = '0%'.obs;
  final expenseChange = '0%'.obs;
  final incomeChangePositive = true.obs;
  final expenseChangePositive = true.obs;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static const List<int> _categoryColors = [
    0xFF5B8DEF, // blue
    0xFFFF6B6B, // red
    0xFF2DCE89, // green
    0xFFFFC107, // amber
    0xFF9C27B0, // purple
    0xFF78909C, // grey
    0xFFFF9800, // orange
    0xFF00BCD4, // cyan
  ];

  @override
  void onInit() {
    super.onInit();
    _loadReportData();
  }

  void changePeriod(int index) {
    selectedPeriod.value = index;
    _loadReportData();
  }

  void _loadReportData() {
    final user = _auth.currentUser;
    if (user == null) return;

    _firestore
        .collection('users')
        .doc(user.uid)
        .collection('transactions')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((snapshot) {
          final now = DateTime.now();

          // Determine date range based on selected period
          DateTime periodStart;
          DateTime prevPeriodStart;
          DateTime prevPeriodEnd;

          switch (selectedPeriod.value) {
            case 0: // Weekly
              periodStart = now.subtract(Duration(days: now.weekday - 1));
              prevPeriodEnd = periodStart;
              prevPeriodStart = prevPeriodEnd.subtract(const Duration(days: 7));
              break;
            case 2: // Yearly
              periodStart = DateTime(now.year, 1, 1);
              prevPeriodEnd = periodStart;
              prevPeriodStart = DateTime(now.year - 1, 1, 1);
              break;
            default: // Monthly
              periodStart = DateTime(now.year, now.month, 1);
              prevPeriodEnd = periodStart;
              prevPeriodStart = DateTime(now.year, now.month - 1, 1);
          }

          double income = 0;
          double expenses = 0;
          double prevIncome = 0;
          double prevExpenses = 0;
          final Map<String, double> categoryTotals = {};

          for (var doc in snapshot.docs) {
            final data = doc.data();
            final amount = (data['amount'] as num?)?.toDouble() ?? 0;
            final type = data['type'] ?? 'expense';
            final category = data['category'] ?? 'Other';

            DateTime? txDate;
            if (data['createdAt'] != null) {
              txDate = (data['createdAt'] as Timestamp).toDate();
            }

            // Current period
            if (txDate != null && txDate.isAfter(periodStart)) {
              if (type == 'income') {
                income += amount;
              } else {
                expenses += amount;
                categoryTotals[category] =
                    (categoryTotals[category] ?? 0) + amount;
              }
            }

            // Previous period
            if (txDate != null &&
                txDate.isAfter(prevPeriodStart) &&
                txDate.isBefore(prevPeriodEnd)) {
              if (type == 'income') {
                prevIncome += amount;
              } else {
                prevExpenses += amount;
              }
            }
          }

          final savings = income - expenses;

          // Update summary
          rawIncome.value = income;
          rawExpenses.value = expenses;
          final rupiahFormat = NumberFormat.currency(
            locale: 'id_ID',
            symbol: 'Rp',
            decimalDigits: 0,
          );
          totalIncome.value = rupiahFormat.format(income);
          totalExpenses.value = rupiahFormat.format(expenses);
          netSavings.value = rupiahFormat.format(savings);

          // Health status
          if (income == 0 && expenses == 0) {
            healthStatus.value = 'No Data';
            healthMessage.value =
                'Add some transactions to see your financial health.';
          } else if (savings > 0 && income > 0) {
            final savingPercentage = savings / income * 100;
            if (savingPercentage > 75) {
              healthStatus.value = 'Excellent';
              healthMessage.value =
                  "You're saving ${savingPercentage.toStringAsFixed(0)}% of your income. Incredible job!";
            } else if (savingPercentage > 30) {
              healthStatus.value = 'Good';
              healthMessage.value =
                  "You're saving ${savingPercentage.toStringAsFixed(0)}% of your income. Keep it up!";
            } else {
              healthStatus.value = 'Meh';
              healthMessage.value =
                  "You're saving ${savingPercentage.toStringAsFixed(0)}% of your income. Try to save a bit more.";
            }
          } else {
            healthStatus.value = 'Needs Attention';
            healthMessage.value =
                'Your expenses exceed your income. Consider cutting back.';
          }

          // Expense breakdown
          int colorIndex = 0;
          final List<Map<String, dynamic>> breakdown = [];
          categoryTotals.forEach((cat, amt) {
            breakdown.add({
              'label': cat,
              'amount': NumberFormat.currency(
                locale: 'id_ID',
                symbol: 'Rp',
                decimalDigits: 0,
              ).format(amt),
              'rawAmount': amt,
              'color': _categoryColors[colorIndex % _categoryColors.length],
            });
            colorIndex++;
          });
          expenseBreakdown.value = breakdown;

          // Period comparison
          comparisonIncome.value = NumberFormat.currency(
            locale: 'id_ID',
            symbol: 'Rp',
            decimalDigits: 0,
          ).format(income);
          comparisonExpenses.value = NumberFormat.currency(
            locale: 'id_ID',
            symbol: 'Rp',
            decimalDigits: 0,
          ).format(expenses);

          if (prevIncome > 0) {
            final pct = ((income - prevIncome) / prevIncome * 100);
            incomeChange.value =
                '${pct >= 0 ? '+' : ''}${pct.toStringAsFixed(0)}%';
            incomeChangePositive.value = pct >= 0;
          } else {
            incomeChange.value = income > 0 ? '+100%' : '0%';
            incomeChangePositive.value = true;
          }

          if (prevExpenses > 0) {
            final pct = ((expenses - prevExpenses) / prevExpenses * 100);
            expenseChange.value =
                '${pct >= 0 ? '+' : ''}${pct.toStringAsFixed(0)}%';
            // If expense change is negative (e.g., -5%), make it RED (false) per user request
            expenseChangePositive.value = pct > 0;
          } else {
            expenseChange.value = expenses > 0 ? '+100%' : '0%';
            expenseChangePositive.value = false;
          }
        });
  }
}
