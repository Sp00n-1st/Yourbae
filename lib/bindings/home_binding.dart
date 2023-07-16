import 'package:get/get.dart';
import '../controller/alamat_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AlamatController>(
      () => AlamatController(),
    );
  }
}
