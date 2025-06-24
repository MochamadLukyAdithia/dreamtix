import 'package:dreamtix/features/auth/controller/AuthController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final newPasswordC = TextEditingController();
  final confirmPasswordC = TextEditingController();
  final authController = Get.find<AuthController>();

  @override
  void dispose() {
    newPasswordC.dispose();
    confirmPasswordC.dispose();
    super.dispose();
  }

  Future<void> _changePassword() async {
    if (!_formKey.currentState!.validate()) return;

    // Show loading dialog
    Get.dialog(
      const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
        ),
      ),
      barrierDismissible: false,
      barrierColor: Colors.black54,
    );

    try {
      final success = await authController.rubahPassword(newPasswordC.text);

      // Always close loading dialog
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      if (success) {
        newPasswordC.clear();
        confirmPasswordC.clear();

        // Show success alert
        await Get.dialog(
          AlertDialog(
            backgroundColor: const Color(0xFF1B1A47),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            title: const Text(
              'Sukses',
              style: TextStyle(color: Colors.white),
            ),
            content: const Text(
              'Password berhasil diubah',
              style: TextStyle(color: Colors.white),
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: const Text(
                  'OK',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
          barrierDismissible: false,
        );

        // Navigate back to previous screen
        Get.back();
      } else {
        // Show error snackbar
        Get.snackbar(
          'Error',
          'Gagal mengubah password',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      // Close loading dialog on error
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      // Show error snackbar
      Get.snackbar(
        'Error',
        'Terjadi kesalahan: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 3),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0C2D),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D0C2D),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: Get.back,
        ),
        title: const Text(
          'Ubah Password',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Center(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 40),
                    _buildNewPasswordField(),
                    const SizedBox(height: 20),
                    _buildConfirmPasswordField(),
                    const SizedBox(height: 40),
                    _buildChangePasswordButton(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: const BoxDecoration(
            color: Color(0xFF1B1A47),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.lock_reset, size: 40, color: Colors.red),
        ),
        const SizedBox(height: 16),
        const Text(
          'Ubah Password Anda',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Masukkan password baru',
          style: TextStyle(fontSize: 14, color: Colors.grey[400]),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildNewPasswordField() {
    return Obx(
      () => TextFormField(
        controller: newPasswordC,
        obscureText: !authController.isNewPasswordVisible.value,
        style: const TextStyle(color: Colors.white),
        decoration: _inputDecoration(
          'Password Baru',
          Icons.lock_clock_outlined,
          authController.tooglenewPassword, // Fixed typo assumption
          authController.isNewPasswordVisible.value,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Password baru tidak boleh kosong';
          }

          return null;  
        },
      ),
    );
  }

  Widget _buildConfirmPasswordField() {
    return Obx(
      () => TextFormField(
        controller: confirmPasswordC,
        obscureText: !authController.isConfirmPasswordVisible.value,
        style: const TextStyle(color: Colors.white),
        decoration: _inputDecoration(
          'Konfirmasi Password Baru',
          Icons.lock_person_outlined,
          authController.toggleConfirmPassword,
          authController.isConfirmPasswordVisible.value,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Konfirmasi password tidak boleh kosong';
          }
          if (value != newPasswordC.text) {
            return 'Password tidak cocok';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildChangePasswordButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _changePassword,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
          elevation: 3,
        ),
        child: const Text(
          'Ubah Password',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(
    String hint,
    IconData icon,
    VoidCallback toggleVisibility,
    bool isVisible,
  ) {
    return InputDecoration(
      filled: true,
      fillColor: const Color(0xFF1B1A47),
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey[400]),
      prefixIcon: Icon(icon, color: Colors.grey[400]),
      suffixIcon: IconButton(
        icon: Icon(
          isVisible ? Icons.visibility : Icons.visibility_off,
          color: Colors.grey[400],
        ),
        onPressed: toggleVisibility,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
      errorStyle: const TextStyle(color: Colors.red),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }
}
