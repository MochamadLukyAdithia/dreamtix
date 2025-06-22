import 'package:dreamtix/features/auth/controller/AuthController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final currentPasswordC = TextEditingController();
  final newPasswordC = TextEditingController();
  final confirmPasswordC = TextEditingController();

  String? currentPasswordError;
  String? newPasswordError;
  String? confirmPasswordError;

  final authController = Get.find<AuthController>();

  @override
  void dispose() {
    currentPasswordC.dispose();
    newPasswordC.dispose();
    confirmPasswordC.dispose();
    super.dispose();
  }

  void validateInputs() {
    setState(() {
      // Validate current password
      currentPasswordError = currentPasswordC.text.isEmpty
          ? 'Password saat ini tidak boleh kosong'
          : null;

      // Validate new password
      if (newPasswordC.text.isEmpty) {
        newPasswordError = 'Password baru tidak boleh kosong';
      } else if (newPasswordC.text.length < 6) {
        newPasswordError = 'Password minimal 6 karakter';
      } else {
        newPasswordError = null;
      }

      // Validate confirm password
      if (confirmPasswordC.text.isEmpty) {
        confirmPasswordError = 'Konfirmasi password tidak boleh kosong';
      } else if (confirmPasswordC.text != newPasswordC.text) {
        confirmPasswordError = 'Password tidak cocok';
      } else {
        confirmPasswordError = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0D0C2D),
      appBar: AppBar(
        backgroundColor: Color(0xFF0D0C2D),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text(
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Header Icon
                  Container(
                    margin: EdgeInsets.only(bottom: 40),
                    child: Column(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Color(0xFF1B1A47),
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: Icon(
                            Icons.lock_reset,
                            size: 40,
                            color: Colors.red,
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Ubah Password Anda',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Masukkan password lama dan password baru',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[400],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  // Current Password Field
                  Obx(() => TextField(
                        controller: currentPasswordC,
                        obscureText:
                            !authController.isCurrentPasswordVisible.value,
                        style: TextStyle(color: Colors.white),
                        decoration: _inputDecoration(
                          "Password Saat Ini",
                          Icons.lock_outline,
                          errorText: currentPasswordError,
                        ).copyWith(
                          suffixIcon: IconButton(
                            icon: Icon(
                              authController.isCurrentPasswordVisible.value
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.grey[400],
                            ),
                            onPressed: authController.toggleCurrentPassword,
                          ),
                        ),
                      )),
                  SizedBox(height: 20),

                  // New Password Field
                  Obx(() => TextField(
                        controller: newPasswordC,
                        obscureText: !authController.isNewPasswordVisible.value,
                        style: TextStyle(color: Colors.white),
                        decoration: _inputDecoration(
                          "Password Baru",
                          Icons.lock_clock_outlined,
                          errorText: newPasswordError,
                        ).copyWith(
                          suffixIcon: IconButton(
                            icon: Icon(
                              authController.isNewPasswordVisible.value
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.grey[400],
                            ),
                            onPressed: authController.tooglenewPassword,
                          ),
                        ),
                      )),
                  SizedBox(height: 20),

                  // Confirm Password Field
                  Obx(() => TextField(
                        controller: confirmPasswordC,
                        obscureText:
                            !authController.isConfirmPasswordVisible.value,
                        style: TextStyle(color: Colors.white),
                        decoration: _inputDecoration(
                          "Konfirmasi Password Baru",
                          Icons.lock_person_outlined,
                          errorText: confirmPasswordError,
                        ).copyWith(
                          suffixIcon: IconButton(
                            icon: Icon(
                              authController.isConfirmPasswordVisible.value
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.grey[400],
                            ),
                            onPressed: authController.toggleConfirmPassword,
                          ),
                        ),
                      )),

                  SizedBox(height: 40),

                  // Change Password Button
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        validateInputs();
                        if (currentPasswordError == null &&
                            newPasswordError == null &&
                            confirmPasswordError == null) {
                          // Show loading
                          Get.dialog(
                            Center(
                              child: Container(
                                padding: EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Color(0xFF1B1A47),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.red),
                                    ),
                                    SizedBox(height: 16),
                                    Text(
                                      'Mengubah password...',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            barrierDismissible: false,
                          );

                          // Call API to change password
                          bool success =
                              await AuthController.changePasswordWithValidation(
                            currentPassword: currentPasswordC.text,
                            newPassword: newPasswordC.text,
                          );

                          Get.back(); // Close loading dialog

                          if (success) {
                            // Clear fields on success
                            currentPasswordC.clear();
                            newPasswordC.clear();
                            confirmPasswordC.clear();

                            // Go back after delay
                            Future.delayed(Duration(seconds: 1), () {
                              Get.back();
                            });
                          }
                          // Error handling is already done in the AuthController
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 16),
                        elevation: 3,
                      ),
                      child: Text(
                        "Ubah Password",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 20),

                  // Cancel Button
                  Container(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () => Get.back(),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(
                        "Batal",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[400],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint, IconData icon,
      {String? errorText}) {
    return InputDecoration(
      filled: true,
      fillColor: Color(0xFF1B1A47),
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey[400]),
      prefixIcon: Icon(icon, color: Colors.grey[400]),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.red, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.red, width: 2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.red, width: 2),
      ),
      errorText: errorText,
      errorStyle: TextStyle(color: Colors.red),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }
}
