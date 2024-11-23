import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:learning/app_colors.dart';
import 'package:learning/screens/login_user.dart';

void main() {
  // Configure EasyLoading before running the app
  configLoading();

  // Run the Flutter app
  runApp(const HomeApp());
}

// EasyLoading Configuration
void configLoading() {
  EasyLoading.instance
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..maskColor = Colors.black.withOpacity(0.5)
    ..progressColor = Colors.white
    ..backgroundColor = AppColors.blue
    ..indicatorColor = AppColors.bgmain
    ..textColor = Colors.white
    ..userInteractions = true // Prevent user interaction while loading
    ..dismissOnTap = false;
}

// Main App Widget
class HomeApp extends StatelessWidget {
  const HomeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login User',
      home: const LoginUser(),
      builder: EasyLoading.init(), // Integrate EasyLoading
      theme: ThemeData.light().copyWith(
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.blue,
          systemOverlayStyle: SystemUiOverlayStyle.light,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}