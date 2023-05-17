import 'package:get/get.dart';
import 'package:yourbae_project/controller/controller.dart';

import '../controller/alamat_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AlamatController>(
      () => AlamatController(),
    );
  }
}
