import 'package:dreamtix/features/auth/model/UserModel.dart';
import 'package:dreamtix/routes/route.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthController extends GetxController {
  var isPasswordVisible = false.obs;
  final supabase = Supabase.instance.client;
  void togglePassword() => isPasswordVisible.toggle();
  Future<void> login(Usermodel user) async {
    print('Logging in user: ${user.username}');
    try {
      final response = await supabase
          .from('customer')
          .select()
          .eq('username', user.username!)
          .eq('password', user.password!)
          .maybeSingle(); // safer than single()

      if (response != null) {
        final token = 'mock_token_${DateTime.now().millisecondsSinceEpoch}';
        // TODO: Store token in secure storage
        Get.snackbar('Login Success', 'Welcome back!');
        Get.toNamed(AppRoute.home);
      } else {
        Get.snackbar('Login Failed', 'Invalid credentials');
      }
    } catch (e) {
      Get.snackbar('Login Error', e.toString());
    }
  }
}

final authController = AuthController();
