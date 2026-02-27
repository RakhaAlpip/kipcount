import 'package:get/get.dart';
import 'package:kipcount/app/routes/app_routes.dart';
import 'package:kipcount/features/auth/bindings/login_binding.dart';
import 'package:kipcount/features/auth/bindings/register_binding.dart';
import 'package:kipcount/features/auth/views/login_screen.dart';
import 'package:kipcount/features/auth/views/register_screen.dart';
import 'package:kipcount/features/navigation/bindings/navigation_binding.dart';
import 'package:kipcount/features/navigation/views/main_navigation_screen.dart';
import 'package:kipcount/features/transaction/bindings/transaction_binding.dart';
import 'package:kipcount/features/transaction/views/add_transaction_screen.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginScreen(),
      binding: LoginBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.register,
      page: () => const RegisterScreen(),
      binding: RegisterBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.main,
      page: () => const MainNavigationScreen(),
      binding: NavigationBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.addTransaction,
      page: () => const AddTransactionScreen(),
      binding: TransactionBinding(),
      transition: Transition.downToUp,
      fullscreenDialog: true,
    ),
  ];
}
