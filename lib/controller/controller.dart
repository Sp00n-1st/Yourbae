import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oktoast/oktoast.dart';
import 'package:yourbae_project/view/home.dart';
import 'package:yourbae_project/view/login.dart';

import 'auth_controller.dart';

class Controller extends GetxController {
  var isShowPassword = false.obs;
  RxnString category = RxnString();
  var selectedPages = 0.obs;
  var selectedSize = 0.obs;

  void showNotification(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.orange.shade900,
        content: Text(message.toString())));
  }
}
