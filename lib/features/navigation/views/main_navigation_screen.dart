import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kipcount/core/widgets/bottom_nav_bar.dart';
import 'package:kipcount/features/navigation/controllers/navigation_controller.dart';
import 'package:kipcount/features/dashboard/views/dashboard_screen.dart';
import 'package:kipcount/features/report/views/report_screen.dart';
import 'package:kipcount/features/wallet/views/wallet_screen.dart';
import 'package:kipcount/features/profile/views/profile_screen.dart';

class MainNavigationScreen extends GetView<NavigationController> {
  const MainNavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: controller.pageController,
        onPageChanged: controller.onPageChanged,
        physics: const BouncingScrollPhysics(),
        children: const [
          DashboardScreen(),
          ReportScreen(),
          WalletScreen(),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: Obx(
        () => BottomNavBar(
          currentIndex: controller.currentIndex.value,
          onTap: controller.changePage,
          onFabTap: () => Get.toNamed('/add-transaction'),
        ),
      ),
    );
  }
}
