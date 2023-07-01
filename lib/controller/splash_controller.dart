import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:oktoast/oktoast.dart';
import '../view/home.dart';
import '../view/login.dart';
import 'auth_controller.dart';

class SplashController extends GetxController {
  var authController = Get.put(AuthController());
  User? user = FirebaseAuth.instance.currentUser;
  @override
  void onReady() {
    try {
      if (user != null) {
        Future.delayed(
            const Duration(milliseconds: 3000), () => Get.offAll(Home()));
      } else {
        Future.delayed(const Duration(milliseconds: 3000),
            () => Get.offAll(const Login()));
      }
    } on FirebaseAuthException catch (e) {
      showToast(e.message!);
      authController.logoutAuth(false);
    }
    super.onReady();
  }
}
