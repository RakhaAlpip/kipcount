import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class DashboardController extends GetxController {
  final userName = ''.obs;
  final totalBalance = 'Rp0'.obs;
  final income = 'Rp0'.obs;
  final expenses = 'Rp0'.obs;
  final savings = 'Rp0'.obs;

  final recentTransactions = <Map<String, dynamic>>[].obs;
  final upcomingBills = <Map<String, dynamic>>[].obs;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    _loadUserData();
    _loadTransactions();
  }

  void _loadUserData() {
    final user = _auth.currentUser;
    if (user != null) {
      userName.value =
          user.displayName ?? user.email?.split('@').first ?? 'User';
    }
  }

  void _loadTransactions() {
    final user = _auth.currentUser;
    if (user == null) return;

    // Listen to transactions in real-time
    _firestore
        .collection('users')
        .doc(user.uid)
        .collection('transactions')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((snapshot) {
          double totalIncome = 0;
          double totalExpense = 0;
          final List<Map<String, dynamic>> txList = [];

          for (var doc in snapshot.docs) {
            final data = doc.data();
            final amount = (data['amount'] as num?)?.toDouble() ?? 0;
            final type = data['type'] ?? 'expense';
            final category = data['category'] ?? 'Other';

            if (type == 'income') {
              totalIncome += amount;
            } else {
              totalExpense += amount;
            }

            // Format date
            String dateStr = 'Unknown date';
            if (data['createdAt'] != null) {
              final ts = data['createdAt'] as Timestamp;
              dateStr = DateFormat('MMM dd, yyyy').format(ts.toDate());
            }

            final rupiahFormat = NumberFormat.currency(
              locale: 'id_ID',
              symbol: 'Rp',
              decimalDigits: 0,
            );

            txList.add({
              'title': data['title'] ?? category,
              'subtitle': dateStr,
              'amount': type == 'income'
                  ? '+${rupiahFormat.format(amount)}'
                  : '-${rupiahFormat.format(amount)}',
              'isPositive': type == 'income',
              'icon': _getCategoryIcon(category),
              'bgColor': _getCategoryBgKey(category),
            });
          }

          recentTransactions.value = txList.take(5).toList();

          final netSavings = totalIncome - totalExpense;
          final rupiahFormat = NumberFormat.currency(
            locale: 'id_ID',
            symbol: 'Rp',
            decimalDigits: 0,
          );
          totalBalance.value = rupiahFormat.format(netSavings);
          income.value = rupiahFormat.format(totalIncome);
          expenses.value = rupiahFormat.format(totalExpense);
          savings.value = rupiahFormat.format(netSavings > 0 ? netSavings : 0);
        });
  }

  String _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'groceries':
        return 'shopping_cart';
      case 'salary':
        return 'account_balance';
      case 'entertainment':
        return 'play_circle';
      case 'utilities':
        return 'bolt';
      case 'rent':
        return 'home';
      case 'transport':
        return 'directions_car';
      case 'healthcare':
        return 'medical_services';
      default:
        return 'receipt';
    }
  }

  String _getCategoryBgKey(String category) {
    switch (category.toLowerCase()) {
      case 'groceries':
        return 'grocery';
      case 'salary':
        return 'salary';
      case 'entertainment':
        return 'entertainment';
      case 'utilities':
        return 'utility';
      case 'rent':
        return 'rent';
      default:
        return 'default';
    }
  }

  void refreshUserName() {
    _loadUserData();
  }
}
