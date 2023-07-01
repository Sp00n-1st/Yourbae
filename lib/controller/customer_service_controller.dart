import 'package:flutter/cupertino.dart';
import 'package:flutter_launch/flutter_launch.dart';
import 'package:get/get.dart';
import 'package:oktoast/oktoast.dart';

class CustomerServiceController extends GetxController {
  void openWhatsApp(String noCustomerService) async {
    bool whatsApp = await FlutterLaunch.hasApp(name: 'whatsapp');
    if (whatsApp) {
      await FlutterLaunch.launchWhatsapp(
          phone: '+$noCustomerService', message: 'Hallo Admin');
      print("object");
    } else {
      showToast('Anda Belum Menginstal WhatsApp +$noCustomerService',
          position: const ToastPosition(align: Alignment.bottomCenter));
    }
  }
}
