import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class WalletController extends GetxController {
  final totalBalance = 'Rp0'.obs;

  final accounts = <Map<String, dynamic>>[
    {
      'name': 'Checking Account',
      'number': '**** 1234',
      'balance': 'Rp0',
      'icon': 'account_balance',
      'color': 0xFF5B8DEF,
    },
    {
      'name': 'Savings Account',
      'number': '**** 5678',
      'balance': 'Rp0',
      'icon': 'savings',
      'color': 0xFF2DCE89,
    },
    {
      'name': 'Credit Card',
      'number': '**** 9012',
      'balance': 'Rp0',
      'icon': 'credit_card',
      'color': 0xFFFF6B6B,
    },
  ].obs;

  final recentTransactions = <Map<String, dynamic>>[].obs;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    _loadTransactions();
  }

  void _loadTransactions() {
    final user = _auth.currentUser;
    if (user == null) return;

    _firestore
        .collection('users')
        .doc(user.uid)
        .collection('transactions')
        .orderBy('createdAt', descending: true)
        .limit(5)
        .snapshots()
        .listen((snapshot) {
          final List<Map<String, dynamic>> txList = [];

          for (var doc in snapshot.docs) {
            final data = doc.data();
            final amount = (data['amount'] as num?)?.toDouble() ?? 0;
            final type = data['type'] ?? 'expense';
            final category = data['category'] ?? 'Other';

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

          recentTransactions.value = txList;

          // Update total balance from all transactions (need a separate query for totals)
          _loadTotalBalance();
        });
  }

  void _loadTotalBalance() {
    final user = _auth.currentUser;
    if (user == null) return;

    _firestore
        .collection('users')
        .doc(user.uid)
        .collection('transactions')
        .get()
        .then((snapshot) {
          double totalIncome = 0;
          double totalExpense = 0;

          for (var doc in snapshot.docs) {
            final data = doc.data();
            final amount = (data['amount'] as num?)?.toDouble() ?? 0;
            final type = data['type'] ?? 'expense';

            if (type == 'income') {
              totalIncome += amount;
            } else {
              totalExpense += amount;
            }
          }

          final rupiahFormat = NumberFormat.currency(
            locale: 'id_ID',
            symbol: 'Rp',
            decimalDigits: 0,
          );
          final net = totalIncome - totalExpense;
          totalBalance.value = rupiahFormat.format(net);
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
}
