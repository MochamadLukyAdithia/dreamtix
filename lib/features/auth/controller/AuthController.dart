import 'dart:convert';
import 'package:dreamtix/features/auth/model/UserModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:dreamtix/core/const/apiUrl.dart' as api;
import 'package:get_storage/get_storage.dart';

class AuthController extends GetxController {
  // Password visibility variables
  var isPasswordVisible = false.obs;
  var isNewPasswordVisible = false.obs;
  
  // Additional variables for Change Password screen
  var isCurrentPasswordVisible = false.obs;
  var isConfirmPasswordVisible = false.obs;
  
  final box = GetStorage(); // inisialisasi penyimpanan lokal

  // Toggle methods
  void togglePassword() => isPasswordVisible.toggle();
  void tooglenewPassword() => isNewPasswordVisible.toggle();
  
  // New toggle methods for Change Password screen
  void toggleCurrentPassword() => isCurrentPasswordVisible.toggle();
  void toggleConfirmPassword() => isConfirmPasswordVisible.toggle();

  // Existing rubahPassword method - improved with better error handling
  static Future<bool> rubahPassword(String newPassword) async {
    final url = Uri.parse('${api.apiUrl}/users');
    final box = GetStorage(); // akses GetStorage

    final token = box.read("token");
    if (token == null) {
      print("Token tidak ditemukan. Silakan login terlebih dahulu.");
      Get.snackbar(
        "Error", 
        "Token tidak ditemukan. Silakan login terlebih dahulu.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
      return false;
    }

    try {
      final response = await http.patch(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'password': newPassword}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("Password berhasil diubah: ${data['message'] ?? 'Berhasil'}");

        Get.snackbar(
          "Sukses", 
          "Password berhasil diubah",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.8),
          colorText: Colors.white,
          icon: Icon(Icons.check_circle, color: Colors.white),
        );
        return true;
      } else {
        final error = jsonDecode(response.body);
        print("Gagal ubah password: ${error['message'] ?? 'Terjadi kesalahan'}");

        Get.snackbar(
          "Gagal", 
          error['message'] ?? "Gagal mengubah password",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
          icon: Icon(Icons.error, color: Colors.white),
        );
        return false;
      }
    } catch (e) {
      print("Terjadi kesalahan: $e");

      Get.snackbar(
        "Error", 
        "Terjadi kesalahan: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
        icon: Icon(Icons.error, color: Colors.white),
      );
      return false;
    }
  }

  // New method for changing password with current password validation
  static Future<bool> changePasswordWithValidation({
    required String currentPassword,
    required String newPassword,
  }) async {
    final url = Uri.parse('${api.apiUrl}/users/change-password');
    final box = GetStorage();

    final token = box.read("token");
    if (token == null) {
      print("Token tidak ditemukan. Silakan login terlebih dahulu.");
      Get.snackbar(
        "Error", 
        "Token tidak ditemukan. Silakan login terlebih dahulu.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
      return false;
    }

    try {
      final response = await http.patch(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'currentPassword': currentPassword,
          'newPassword': newPassword,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("Password berhasil diubah: ${data['message'] ?? 'Berhasil'}");

        Get.snackbar(
          "Berhasil", 
          "Password berhasil diubah",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.8),
          colorText: Colors.white,
          icon: Icon(Icons.check_circle, color: Colors.white),
        );
        return true;
      } else {
        final error = jsonDecode(response.body);
        print("Gagal ubah password: ${error['message'] ?? 'Terjadi kesalahan'}");

        Get.snackbar(
          "Gagal", 
          error['message'] ?? "Gagal mengubah password",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
          icon: Icon(Icons.error, color: Colors.white),
        );
        return false;
      }
    } catch (e) {
      print("Terjadi kesalahan: $e");

      Get.snackbar(
        "Error", 
        "Terjadi kesalahan: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
        icon: Icon(Icons.error, color: Colors.white),
      );
      return false;
    }
  }

  static Future<void> login(Usermodel user) async {
    final url = Uri.parse('${api.apiUrl}/users/login');
    final box = GetStorage(); // akses GetStorage di sini

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body:
            jsonEncode({'username': user.username, 'password': user.password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("Data: ${data["data"]}");

        // Simpan token ke GetStorage
        final token = data["data"]["token"];
        await box.write("token", token);

        // Menampilkan alert dialog sukses
        Get.dialog(
          AlertDialog(
            title: const Text("Login Berhasil"),
            content: const Text("Selamat datang di aplikasi!"),
            actions: [
              TextButton(
                onPressed: () {
                  Get.back(); // Tutup dialog
                  Get.offNamed("/home"); // Navigasi ke home
                },
                child: const Text("OK"),
              ),
            ],
          ),
          barrierDismissible: false,
        );
      } else {
        final error = jsonDecode(response.body);

        // Menampilkan alert dialog gagal
        Get.dialog(
          AlertDialog(
            title: const Text("Login Gagal"),
            content: Text(error['message'] ?? 'Terjadi kesalahan saat login'),
            actions: [
              TextButton(
                onPressed: () {
                  Get.back(); // Tutup dialog
                },
                child: const Text("OK"),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      print("error: $e");

      // Menampilkan alert dialog error
      Get.dialog(
        AlertDialog(
          title: const Text("Error"),
          content: Text('Terjadi kesalahan: $e'),
          actions: [
            TextButton(
              onPressed: () {
                Get.back(); // Tutup dialog
              },
              child: const Text("OK"),
            ),
          ],
        ),
      );
    }
  }
}