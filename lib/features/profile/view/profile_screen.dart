import 'package:dreamtix/features/profile/controller/ProfileController.dart';
import 'package:dreamtix/features/auth/controller/AuthController.dart'; // Import AuthController
import 'package:dreamtix/features/profile/view/ubah_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileView extends StatelessWidget {
  final ProfileController profileController = Get.put(ProfileController());
  final AuthController authController =
      Get.put(AuthController()); // Inisialisasi AuthController

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0E21),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.orange,
                      child: Text("ML", style: TextStyle(color: Colors.white)),
                    ),
                    const SizedBox(width: 12),
                    Obx(() => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(profileController.userName.value,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                            Text(profileController.email.value,
                                style: const TextStyle(color: Colors.white70)),
                          ],
                        )),
                  ],
                ),
                const SizedBox(height: 30),
                buildSection("Akun", [
                  // buildItem("Ubah Profil", () => Get.toNamed("ubah-profile")),
                  buildItem(
                      "Ubah Kata Sandi", () => Get.toNamed("ubah-password")),
                ]),
                buildSection("Dukungan", [
                  buildItem("Customer Service", () => Get.toNamed("help")),
                ]),
                buildSection("Tentang Kami", [
                  buildItem("Tentang DreamTix", () => Get.toNamed("about")),
                  buildItem("Syarat Dan Ketentuan", () => Get.toNamed("terms")),
                ]),
                buildSection("Lainya", [
                  buildItem("Cara Membeli Tiket", () => Get.toNamed("membeli")),
                ]),
                // Logout button terpisah
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: ElevatedButton.icon(
                    onPressed: () => authController.logout(),
                    icon: const Icon(Icons.logout, color: Colors.white),
                    label: const Text(
                      "Logout",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Text(title, style: const TextStyle(color: Colors.white60)),
        const SizedBox(height: 10),
        ...items,
      ],
    );
  }

  Widget buildItem(String text, VoidCallback onTap, {bool isLogout = false}) {
    return ListTile(
      leading: isLogout
          ? Icon(Icons.logout,
              color: Colors.red, size: 20) // Tambahkan icon logout
          : null,
      title: Text(text,
          style: TextStyle(
            color: isLogout
                ? Colors.red
                : Colors.white, // Warna merah untuk logout
            fontWeight: isLogout ? FontWeight.w500 : FontWeight.normal,
          )),
      trailing:
          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white),
      onTap: onTap,
    );
  }
}
