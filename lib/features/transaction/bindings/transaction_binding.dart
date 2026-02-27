import 'package:get/get.dart';
import 'package:kipcount/features/transaction/controllers/transaction_controller.dart';

class TransactionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TransactionController>(() => TransactionController());
  }
}
