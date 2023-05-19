import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/alamat_controller.dart';

class RadioButtonKurir extends StatelessWidget {
  RadioButtonKurir({Key? key, required this.qty}) : super(key: key);
  int qty;
  @override
  Widget build(BuildContext context) {
    var alamatController = Get.put(AlamatController());
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          children: [
            Obx(
              () => Radio(
                value: 'jne',
                groupValue: alamatController.kurir.value,
                onChanged: (value) {
                  alamatController.hiddenKurir.value = true;
                  alamatController.hiddenLoading.value = false;
                  alamatController.kurir.value = value!;
                  alamatController.cost.value = 0;
                  alamatController.ongkosKirim(qty);
                },
              ),
            ),
            const Text('JNE'),
          ],
        ),
        Row(
          children: [
            Obx(
              () => Radio(
                value: 'pos',
                groupValue: alamatController.kurir.value,
                onChanged: (value) {
                  alamatController.hiddenKurir.value = true;
                  alamatController.hiddenLoading.value = false;
                  alamatController.kurir.value = value!;
                  alamatController.cost.value = 0;
                  alamatController.ongkosKirim(qty);
                },
              ),
            ),
            const Text('Pos Indonesia'),
          ],
        ),
      ],
    );
  }
}
