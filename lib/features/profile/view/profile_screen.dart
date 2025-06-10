import 'package:dreamtix/features/profile/controller/ProfileController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileView extends StatelessWidget {
  final ProfileController controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0E21),
      appBar: AppBar(
        title: const Text("Profil", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF0B0E21),
      ),
      body: Padding(
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
                        Text(controller.userName.value,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                        Text(controller.email.value,
                            style: const TextStyle(color: Colors.white70)),
                      ],
                    )),
              ],
            ),
            const SizedBox(height: 30),
            buildSection("Akun", [
              buildItem("Ubah Profil"),
              buildItem("Ubah Kata Sandi"),
            ]),
            buildSection("Dukungan", [
              buildItem("Customer Srrvice"), // Typo disamakan
            ]),
            buildSection("Tentang Kami", [
              buildItem("Tentang DreamTix"),
              buildItem("Syarat Dan Ketentuan"),
            ]),
            buildSection("Lainya", [
              buildItem("Cara Membeli Tiket"),
            ]),
          ],
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

  Widget buildItem(String text) {
    return ListTile(
      title: Text(text, style: const TextStyle(color: Colors.white)),
      trailing:
          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white),
      onTap: () {
        
      },
    );
  }
}
