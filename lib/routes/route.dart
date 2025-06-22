import 'package:dreamtix/features/auth/view/login_screen.dart';
import 'package:dreamtix/features/auth/view/register_screen.dart';
import 'package:dreamtix/features/home/model/tiket_model.dart';
import 'package:dreamtix/features/home/view/beli_tiket_view.dart';
import 'package:dreamtix/features/home/view/detail_view_screen.dart';
import 'package:dreamtix/features/home/view/google_maps_screen.dart';
import 'package:dreamtix/features/home/view/home_screen.dart';
import 'package:dreamtix/features/profile/view/cara_membeli_tiket.dart';
import 'package:dreamtix/features/profile/view/customer_service_screen.dart';
import 'package:dreamtix/features/profile/view/syarat_ketentuan_screen.dart';
import 'package:dreamtix/features/profile/view/tentang_dreamtix_screen.dart';
import 'package:dreamtix/features/profile/view/ubah_password_screen.dart';
import 'package:dreamtix/features/profile/view/ubah_profile_screen.dart';
import 'package:dreamtix/features/splash/view/splash_screen.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/instance_manager.dart';

class AppRoute {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String detailEvent = "/detail-event";
  static const String transaksidetail = '/transaksi-detail';
  static const String beliTiket = '/beli-tiket';
  static const String profile = '/profile';
  static const String ubahProfile = '/ubah-profile';
  static const String about = '/about';
  static const String help = '/help';
  static const String terms = '/terms';
  static const String membeli = '/membeli';
  static const String gmaps = '/gmaps';
  static const String ubahpassword = '/ubah-password';
}

class AppPages {
  static final ticket = Get.arguments as Tiket;
  static final INITIAL = AppRoute.splash;
  static final routes = [
    GetPage(
      name: AppRoute.gmaps,
      page: () => GoogleMapsScreen(),
    ),
    GetPage(
      name: AppRoute.splash,
      page: () => SplashScreen(),
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    ),
    GetPage(
      name: AppRoute.beliTiket,
      page: () => BeliTiketScreen(ticket : ticket),
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    ),
    GetPage(
      name: AppRoute.detailEvent,
      page: () => DetailEventScreen(),
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    ),
    GetPage(
      name: AppRoute.login,
      page: () => LoginScreen(),
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: 200),
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
    GetPage(
      name: AppRoute.ubahProfile,
      page: () => UbahProfileScreen(),
      transition: Transition.cupertino,
      transitionDuration: Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    ),
    GetPage(
      name: AppRoute.ubahpassword,
      page: () => UbahPasswordScreen(),
      transition: Transition.cupertino,
      transitionDuration: Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    ),
    GetPage(
      name: AppRoute.help,
      page: () => CustomerServiceScreen(),
      transition: Transition.cupertino,
      transitionDuration: Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    ),
    GetPage(
      name: AppRoute.terms,
      page: () => SyaratKetentuanScreen(),
      transition: Transition.cupertino,
      transitionDuration: Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    ),
    GetPage(
      name: AppRoute.about,
      page: () => TentangDreamTixScreen(),
      transition: Transition.cupertino,
      transitionDuration: Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    ),
    GetPage(
      name: AppRoute.membeli,
      page: () => CaraMembeliTiketScreen(),
      transition: Transition.cupertino,
      transitionDuration: Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    ),
  ];
}
