import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Controller extends GetxController {
  var isShowPassword = false.obs;
  var isEmpty = false.obs;
  RxnString category = RxnString();
  var selectedPages = 0.obs;
  var selectedSize = 0.obs;
  var textEditingController = TextEditingController().obs;
  var showStream = false.obs;

  void showNotification(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.orange.shade900,
        content: Text(message.toString())));
  }
}
