import 'package:dreamtix/features/auth/view/login_screen.dart';
import 'package:dreamtix/features/auth/view/register_screen.dart';
import 'package:dreamtix/features/home/view/home_screen.dart';
import 'package:dreamtix/features/splash/view/splash_screen.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get_navigation/get_navigation.dart';

class AppRoute {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String transaksidetail = '/transaksi-detail';
  static const String profile = '/profile';
  static const String settings = '/settings';
  static const String about = '/about';
  static const String contact = '/contact';
  static const String help = '/help';
  static const String terms = '/terms';
  static const String privacy = '/privacy';
}

class AppPages {
  static final INITIAL = AppRoute.splash;
  static final routes = [
    GetPage(
      name: AppRoute.splash,
      page: () => SplashScreen(),
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: 800),
      curve: Curves.easeInOut,
    ),
    GetPage(
      name: AppRoute.login,
      page: () => LoginScreen(),
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    ),
    GetPage(
      name: AppRoute.register,
      page: () => RegisterScreen(),
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: 450),
      curve: Curves.easeOut,
    ),
    GetPage(
      name: AppRoute.home,
      page: () => MainScreen(),
      transition: Transition.cupertino,
      transitionDuration: Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    ),
  ];
}
