import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class TransactionController extends GetxController {
  final selectedType = 1.obs; // 0=Income, 1=Expense
  final category = ''.obs;
  final title = ''.obs;
  final amount = ''.obs;
  final date = ''.obs;
  final notes = ''.obs;
  final tags = ''.obs;
  final isLoading = false.obs;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final categories = <String>[
    'Groceries',
    'Salary',
    'Entertainment',
    'Transport',
    'Utilities',
    'Rent',
    'Healthcare',
    'Other',
  ];

  void changeType(int index) {
    selectedType.value = index;
  }

  void saveTransaction() async {
    if (title.value.isEmpty || amount.value.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill in required fields',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final parsedAmount = double.tryParse(amount.value);
    if (parsedAmount == null || parsedAmount <= 0) {
      Get.snackbar(
        'Error',
        'Please enter a valid amount',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading.value = true;
    try {
      final user = _auth.currentUser;
      if (user == null) {
        Get.snackbar(
          'Error',
          'You must be logged in',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      // Parse date if provided
      DateTime? txDate;
      if (date.value.isNotEmpty) {
        try {
          txDate = DateFormat('MM/dd/yyyy').parse(date.value);
        } catch (_) {
          txDate = DateTime.now();
        }
      }

      // Save to Firestore
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('transactions')
          .add({
            'type': selectedType.value == 0 ? 'income' : 'expense',
            'category': category.value.isEmpty ? 'Other' : category.value,
            'title': title.value.trim(),
            'amount': parsedAmount,
            'date': txDate != null ? Timestamp.fromDate(txDate) : null,
            'notes': notes.value.trim(),
            'tags': tags.value.trim(),
            'createdAt': FieldValue.serverTimestamp(),
          });

      Get.back();
      Get.snackbar(
        'Success',
        'Transaction saved successfully!',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to save: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
