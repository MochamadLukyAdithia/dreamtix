import 'package:dreamtix/features/auth/controller/AuthController.dart';
import 'package:dreamtix/features/auth/model/UserModel.dart';
import 'package:dreamtix/features/auth/view/rubah_password_screen.dart';
import 'package:dreamtix/routes/route.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final usernameC = TextEditingController();
  final passwordC = TextEditingController();
  String? usernameError;
  String? passwordError;

  final authController = Get.find<AuthController>();

  @override
  void dispose() {
    usernameC.dispose();
    passwordC.dispose();
    super.dispose();
  }

  void validateInputs() {
    setState(() {
      usernameError =
          usernameC.text.isEmpty ? 'Username tidak boleh kosong' : null;
      passwordError =
          passwordC.text.isEmpty ? 'Password tidak boleh kosong' : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0D0C2D),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 50),
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/images/logo.png',
                          width: 100,
                          height: 100,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'DreamTix',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Masuk ke akun Anda',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextField(
                    controller: usernameC,
                    style: TextStyle(color: Colors.white),
                    decoration: _inputDecoration(
                      "Masukkan Username",
                      Icons.person_outline,
                      errorText: usernameError,
                    ),
                  ),
                  SizedBox(height: 20),
                  Obx(() => TextField(
                        controller: passwordC,
                        obscureText: !authController.isPasswordVisible.value,
                        style: TextStyle(color: Colors.white),
                        decoration: _inputDecoration(
                          "Masukkan Password",
                          Icons.lock_outline,
                          errorText: passwordError,
                        ).copyWith(
                          suffixIcon: IconButton(
                            icon: Icon(
                              authController.isPasswordVisible.value
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.grey[400],
                            ),
                            onPressed: authController.togglePassword,
                          ),
                        ),
                      )),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(top: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Get.to(() => ChangePasswordScreen());
                          },
                          style: TextButton.styleFrom(
                            alignment: Alignment.centerRight,
                            padding: EdgeInsets.zero,
                          ),
                          child: Text(
                            'Lupa Password?',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30),
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        validateInputs();

                        if (usernameError == null && passwordError == null) {
                          Usermodel user = Usermodel(
                            username: usernameC.text,
                            password: passwordC.text,
                          );
                          print("Username: ${user.username}");
                          print("Password: ${user.password}");

                          await AuthController.login(user);
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
                        "Masuk",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  Center(
                    child: TextButton(
                      onPressed: () => Get.offNamed(AppRoute.register),
                      child: Text.rich(
                        TextSpan(
                          text: 'Belum punya akun? ',
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 14,
                          ),
                          children: [
                            TextSpan(
                              text: 'Daftar Sekarang',
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.w600,
                              ),
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
