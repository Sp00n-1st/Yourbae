import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controller/address_controller.dart';

class RadioButtonKurir extends StatelessWidget {
  const RadioButtonKurir({Key? key, required this.qty}) : super(key: key);
  final int qty;

  @override
  Widget build(BuildContext context) {
    AddressController addressController = Get.put(AddressController());

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          children: [
            Obx(
              () => Radio(
                value: 'jne',
                groupValue: addressController.kurir.value,
                onChanged: (value) {
                  addressController.hiddenKurir.value = true;
                  addressController.hiddenLoading.value = false;
                  addressController.kurir.value = value!;
                  addressController.cost.value = 0;
                  addressController.ongkosKirim(qty);
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
                groupValue: addressController.kurir.value,
                onChanged: (value) {
                  addressController.hiddenKurir.value = true;
                  addressController.hiddenLoading.value = false;
                  addressController.kurir.value = value!;
                  addressController.cost.value = 0;
                  addressController.ongkosKirim(qty);
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
