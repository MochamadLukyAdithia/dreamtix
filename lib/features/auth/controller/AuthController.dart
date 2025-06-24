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

  // Logout method with confirmation
  Future<void> logout() async {
    // Tampilkan dialog konfirmasi terlebih dahulu
    Get.dialog(
      AlertDialog(
        title: Row(
          children: [
            Icon(Icons.logout, color: Colors.orange),
            SizedBox(width: 8),
            Text("Konfirmasi Logout"),
          ],
        ),
        content: Text("Apakah Anda yakin ingin keluar dari aplikasi?"),
        actions: [
          TextButton(
            onPressed: () {
              Get.back(); // Tutup dialog konfirmasi
            },
            child: Text("Batal", style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () async {
              Get.back(); // Tutup dialog konfirmasi
              await _performLogout(); // Lakukan logout
            },
            child: Text("Logout", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // Private method untuk melakukan logout
  Future<void> _performLogout() async {
    final url = Uri.parse('http://10.0.2.2:3000/api/users/logout');
    final token = box.read("token");

    if (token == null) {
      print("Token tidak ditemukan");
      _navigateToLogin();
      return;
    }

    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("Logout berhasil: ${data['message'] ?? 'Berhasil'}");

        // Hapus token dari storage
        await box.remove("token");

        // Tampilkan dialog sukses
        Get.dialog(
          AlertDialog(
            title: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green),
                SizedBox(width: 8),
                Text("Logout Berhasil"),
              ],
            ),
            content: Text("Anda telah berhasil keluar dari aplikasi."),
            actions: [
              TextButton(
                onPressed: () {
                  Get.back(); // Tutup dialog
                  _navigateToLogin(); // Navigasi ke login
                },
                child: Text("OK"),
              ),
            ],
          ),
          barrierDismissible: false,
        );
      } else {
        final error = jsonDecode(response.body);
        print("Logout gagal: ${error['message'] ?? 'Terjadi kesalahan'}");

        // Meskipun API gagal, tetap hapus token lokal dan navigasi ke login
        await box.remove("token");

        Get.snackbar(
          "Peringatan",
          "Logout dari server gagal, tapi Anda akan diarahkan ke halaman login",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange.withOpacity(0.8),
          colorText: Colors.white,
          icon: Icon(Icons.warning, color: Colors.white),
        );

        _navigateToLogin();
      }
    } catch (e) {
      print("Error logout: $e");

      // Jika terjadi error, tetap hapus token lokal
      await box.remove("token");
      Get.dialog(
        AlertDialog(
          title: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.red),
              SizedBox(width: 8),
              Text("Logout Gagal"),
            ],
          ),
          content: Text("Anda gagal logout keluar dari aplikasi."),
        ),
        barrierDismissible: false,
      );

      Get.back();
    }
  }

  // Helper method untuk navigasi ke login
  void _navigateToLogin() {
    Get.offAllNamed("/login"); // Hapus semua route dan navigasi ke login
  }

  // New register method
  Future<bool> register({
    required String username,
    required String password,
    required String email,
    required double latitude,
    required double longitude,
  }) async {
    final url = Uri.parse('http://10.0.2.2:3000/api/users/register');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password,
          'email': email,
          'latitude': latitude,
          'longitude': longitude,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        print("Registration successful: ${data['message'] ?? 'Berhasil'}");

        Get.dialog(
          AlertDialog(
            title: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green),
                SizedBox(width: 8),
                Text("Registrasi Berhasil"),
              ],
            ),
            content:
                Text("Akun berhasil dibuat! Silakan login dengan akun Anda."),
            actions: [
              TextButton(
                onPressed: () {
                  Get.back(); // Tutup dialog
                  Get.back(); // Kembali ke halaman login
                },
                child: Text("OK"),
              ),
            ],
          ),
          barrierDismissible: false,
        );
        return true;
      } else {
        final error = jsonDecode(response.body);
        print(
            "Registration failed: ${error['message'] ?? 'Terjadi kesalahan'}");

        Get.dialog(
          AlertDialog(
            title: Row(
              children: [
                Icon(Icons.error, color: Colors.red),
                SizedBox(width: 8),
                Text("Registrasi Gagal"),
              ],
            ),
            content: Text(
                error['message'] ?? "Gagal membuat akun. Silakan coba lagi."),
            actions: [
              TextButton(
                onPressed: () {
                  Get.back(); // Tutup dialog
                },
                child: Text("OK"),
              ),
            ],
          ),
        );
        return false;
      }
    } catch (e) {
      print("Registration error: $e");

      Get.dialog(
        AlertDialog(
          title: Row(
            children: [
              Icon(Icons.error, color: Colors.red),
              SizedBox(width: 8),
              Text("Error"),
            ],
          ),
          content: Text('Terjadi kesalahan: $e'),
          actions: [
            TextButton(
              onPressed: () {
                Get.back(); // Tutup dialog
              },
              child: Text("OK"),
            ),
          ],
        ),
      );
      return false;
    }
  }

  // Existing rubahPassword method - improved with better error handling
  Future<bool> rubahPassword(String newPassword) async {
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
        print(
            "Gagal ubah password: ${error['message'] ?? 'Terjadi kesalahan'}");

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
    final box = GetStorage(); //

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
