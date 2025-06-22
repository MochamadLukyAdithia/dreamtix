import 'package:dreamtix/features/auth/controller/AuthController.dart';
import 'package:dreamtix/routes/route.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterScreen extends StatelessWidget {
  final emailC = TextEditingController();
  final nameC = TextEditingController();
  final passwordC = TextEditingController();
  final gender = ''.obs;
  final day = '1'.obs;
  final month = 'Januari'.obs;
  final year = '2000'.obs;
  final authController = Get.find<AuthController>();
  final List<String> days = List.generate(31, (i) => (i + 1).toString());
  final List<String> months = [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];
  final List<String> years = List.generate(30, (i) => (1945 + i).toString());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0C2D),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
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
              _buildInput(nameC, "Masukkan Nama Lengkap"),
              // const SizedBox(height: 16),
              // _genderSelection(),
              const SizedBox(height: 16),
              const Text(
                "Tanggal Lahir",
                style: TextStyle(color: Colors.white),
              ),
              // const SizedBox(height: 8),
              // _birthDateDropdowns(),
              const SizedBox(height: 16),
              Obx(() => TextField(
                    controller: passwordC,
                    obscureText: !authController.isPasswordVisible.value,
                    style: const TextStyle(color: Colors.white),
                    decoration: _inputDecoration("Masukkan Password").copyWith(
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
                  onPressed: () {},
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
    );
  }

  Widget _buildInput(TextEditingController c, String hint) {
    return TextField(
      controller: c,
      style: const TextStyle(color: Colors.white),
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

  Widget _genderSelection() {
    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Jenis Kelamin",
              style: TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Radio<String>(
                  value: 'Laki - Laki',
                  groupValue: gender.value,
                  onChanged: (value) => gender.value = value!,
                ),
                const Text("Laki - Laki",
                    style: TextStyle(color: Colors.white)),
                const SizedBox(width: 16),
                Radio<String>(
                  value: 'Perempuan',
                  groupValue: gender.value,
                  onChanged: (value) => gender.value = value!,
                ),
                const Text("Perempuan", style: TextStyle(color: Colors.white)),
              ],
            ),
          ],
        ));
  }

//   Widget _birthDateDropdowns() {
//     return Obx(() => Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Expanded(child: _dropdownField(days, day)),
//             const SizedBox(width: 12),
//             Expanded(child: _dropdownField(months, month)),
//             const SizedBox(width: 12),
//             Expanded(child: _dropdownField(years, year)),
//           ],
//         ));
//   }

//   Widget _dropdownField(List<String> items, RxString selected) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12),
//       decoration: BoxDecoration(
//         color: const Color(0xFF1B1A47),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: DropdownButton<String>(
//         isExpanded: true,
//         value: selected.value,
//         dropdownColor: const Color(0xFF1B1A47),
//         style: const TextStyle(color: Colors.white),
//         underline: const SizedBox(),
//         icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
//         items: items
//             .map((e) => DropdownMenuItem(value: e, child: Text(e)))
//             .toList(),
//         onChanged: (val) => selected.value = val!,
//       ),
//     );
//   }
// }
}
