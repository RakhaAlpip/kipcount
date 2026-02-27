import 'package:get/get.dart';
import 'package:kipcount/features/navigation/controllers/navigation_controller.dart';
import 'package:kipcount/features/dashboard/controllers/dashboard_controller.dart';
import 'package:kipcount/features/report/controllers/report_controller.dart';
import 'package:kipcount/features/wallet/controllers/wallet_controller.dart';
import 'package:kipcount/features/profile/controllers/profile_controller.dart';

class NavigationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NavigationController>(() => NavigationController());
    Get.lazyPut<DashboardController>(() => DashboardController());
    Get.lazyPut<ReportController>(() => ReportController());
    Get.lazyPut<WalletController>(() => WalletController());
    Get.lazyPut<ProfileController>(() => ProfileController());
  }
}
