import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controller/alamat_controller.dart';

class RadioButtonKurir extends StatelessWidget {
  const RadioButtonKurir({Key? key, required this.qty}) : super(key: key);
  final int qty;

  @override
  Widget build(BuildContext context) {
    AlamatController alamatController = Get.put(AlamatController());

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
            Text(
              'JNE',
              style: GoogleFonts.poppins(color: Colors.black),
            ),
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
            Text('Pos Indonesia',
                style: GoogleFonts.poppins(color: Colors.black)),
          ],
        ),
      ],
    );
  }
}
