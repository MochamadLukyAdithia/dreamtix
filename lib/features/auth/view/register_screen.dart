import 'package:dreamtix/features/auth/controller/AuthController.dart';
import 'package:dreamtix/routes/route.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';

class RegisterScreen extends StatelessWidget {
  final emailC = TextEditingController();
  final nameC = TextEditingController();
  final passwordC = TextEditingController();
  final latitudeC = TextEditingController();
  final longitudeC = TextEditingController();
  final authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0C2D),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Daftar Akun",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Lengkapi data diri kamu untuk melanjutkan.",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 32),
                _buildInput(emailC, "Masukkan Email"),
                const SizedBox(height: 16),
                _buildInput(nameC, "Masukkan Username"),
                const SizedBox(height: 16),
                // Location section
                const Text(
                  "Lokasi",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _buildInput(latitudeC, "Latitude", enabled: false),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child:
                          _buildInput(longitudeC, "Longitude", enabled: false),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton.icon(
                    onPressed: _getCurrentLocation,
                    icon: const Icon(Icons.location_on, color: Colors.red),
                    label: const Text(
                      "Dapatkan Lokasi Saya",
                      style: TextStyle(color: Colors.red),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.red),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Obx(() => TextField(
                      controller: passwordC,
                      obscureText: !authController.isPasswordVisible.value,
                      style: const TextStyle(color: Colors.white),
                      decoration:
                          _inputDecoration("Masukkan Password").copyWith(
                        suffixIcon: IconButton(
                          icon: Icon(
                            authController.isPasswordVisible.value
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.white,
                          ),
                          onPressed: authController.togglePassword,
                        ),
                      ),
                    )),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _handleRegister,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text(
                      "Daftar",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: TextButton(
                    onPressed: () => Get.offNamed(AppRoute.login),
                    child: Text.rich(
                      TextSpan(
                        text: 'Sudah punya akun? ',
                        style: const TextStyle(color: Colors.grey),
                        children: [
                          TextSpan(
                            text: 'Login Sekarang',
                            style: const TextStyle(color: Colors.red),
                          ),
                        ],
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

  Widget _buildInput(TextEditingController c, String hint,
      {bool enabled = true}) {
    return TextField(
      controller: c,
      enabled: enabled,
      style: TextStyle(
        color: enabled ? Colors.white : Colors.grey,
      ),
      decoration: _inputDecoration(hint),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      filled: true,
      fillColor: const Color(0xFF1B1A47),
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.grey),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }

  void _showAlert(String title, String message, {bool isSuccess = false}) {
    Get.dialog(
      AlertDialog(
        title: Text(title),
        content: Text(message),
        backgroundColor: Colors.white,
        titleTextStyle: TextStyle(
          color: isSuccess ? Colors.green : Colors.red,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        contentTextStyle: const TextStyle(
          color: Colors.black87,
          fontSize: 14,
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              "OK",
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }

  void _getCurrentLocation() async {
    try {
      // Show loading
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      // Check location permission
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        Get.back(); // Close loading
        _showAlert(
          "Error",
          "Layanan lokasi tidak aktif. Aktifkan GPS terlebih dahulu",
        );
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Get.back(); // Close loading
          _showAlert(
            "Error",
            "Izin lokasi ditolak",
          );
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        Get.back(); // Close loading
        _showAlert(
          "Error",
          "Izin lokasi ditolak permanen. Aktifkan di pengaturan",
        );
        return;
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Close loading
      Get.back();

      // Set coordinates to text fields
      latitudeC.text = position.latitude.toString();
      longitudeC.text = position.longitude.toString();

      _showAlert(
        "Sukses",
        "Lokasi berhasil didapatkan",
        isSuccess: true,
      );
    } catch (e) {
      Get.back(); // Close loading
      _showAlert(
        "Error",
        "Gagal mendapatkan lokasi: $e",
      );
    }
  }

  void _handleRegister() async {
    // Validasi input
    if (emailC.text.isEmpty || nameC.text.isEmpty || passwordC.text.isEmpty) {
      _showAlert(
        "Error",
        "Email, username, dan password harus diisi",
      );
      return;
    }

    // Validasi lokasi
    if (latitudeC.text.isEmpty || longitudeC.text.isEmpty) {
      _showAlert(
        "Error",
        "Lokasi belum didapatkan. Klik 'Dapatkan Lokasi Saya'",
      );
      return;
    }

    // Validasi email format
    if (!GetUtils.isEmail(emailC.text)) {
      _showAlert(
        "Error",
        "Format email tidak valid",
      );
      return;
    }

    try {
      double latitude = double.parse(latitudeC.text);
      double longitude = double.parse(longitudeC.text);

      // Call register method
      bool success = await authController.register(
        username: nameC.text,
        password: passwordC.text,
        email: emailC.text,
        latitude: latitude,
        longitude: longitude,
      );

      if (success) {
        // Clear form jika berhasil
        emailC.clear();
        nameC.clear();
        passwordC.clear();
        latitudeC.clear();
        longitudeC.clear();
      }
    } catch (e) {
      _showAlert(
        "Error",
        "Format koordinat tidak valid",
      );
    }
  }
}
