import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:kipcount/firebase_options.dart';
import 'package:kipcount/app/routes/app_pages.dart';
import 'package:kipcount/app/routes/app_routes.dart';
import 'package:kipcount/app/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Set status bar style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const KipCountApp());
}

class KipCountApp extends StatelessWidget {
  const KipCountApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'KipCount',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.login,
      getPages: AppPages.pages,
      defaultTransition: Transition.fadeIn,
    );
  }
}
