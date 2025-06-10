import 'package:dreamtix/features/home/view/home_tab.dart';
import 'package:dreamtix/features/profile/view/profile_screen.dart';
import 'package:dreamtix/features/transaksi/view/transaksi_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dreamtix/features/home/controller/HomeController.dart';

class MainScreen extends StatelessWidget {
  final HomeController controller = Get.put(HomeController());

  final List<Widget> pages = [
    HomeTab(),
    TransactionView(),
    ProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0D0C2D),
      body: Obx(() => IndexedStack(
            index: controller.tabIndex.value,
            children: pages,
          )),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
            currentIndex: controller.tabIndex.value,
            onTap: controller.changeTabIndex,
            backgroundColor: Color(0xFF1B1A47),
            selectedItemColor: Colors.redAccent,
            unselectedItemColor: Colors.grey,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.receipt_long), label: 'Transaksi'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person), label: 'Profil'),
            ],
          )),
    );
  }
}
