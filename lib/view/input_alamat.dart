import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yourbae_project/view_model/kurir.dart';
import '../controller/address_controller.dart';
import '../view_model/city.dart';
import '../view_model/province.dart';

class InputAlamat extends StatelessWidget {
  const InputAlamat({super.key});

  @override
  Widget build(BuildContext context) {
    AddressController addressController = Get.put(AddressController());

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(CupertinoIcons.back),
          color: Colors.black,
        ),
        title: Text(
          'Input Alamat',
          style: GoogleFonts.poppins(color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0).r,
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                  label: Text('Alamat', style: GoogleFonts.poppins()),
                  border: const OutlineInputBorder()),
            ),
            const SizedBox(
              height: 20,
            ),
            const Provinsi(),
            Obx(
              () => addressController.hiddenKotaTujuan.isTrue
                  ? const SizedBox()
                  : Column(
                      children: [
                        Kota(
                          provId: addressController.provTujuanId.value,
                        ),
                        Obx(() => addressController.hiddenRadio.isTrue
                            ? const SizedBox()
                            : Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Row(
                                    children: [
                                      Radio(
                                        value: 'jne',
                                        groupValue:
                                            addressController.kurir.value,
                                        onChanged: (value) {
                                          addressController.hiddenKurir.value =
                                              true;
                                          addressController
                                              .hiddenLoading.value = false;
                                          addressController.kurir.value =
                                              value!;
                                        },
                                      ),
                                      Text(
                                        'JNE',
                                        style: GoogleFonts.poppins(
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Radio(
                                        value: 'pos',
                                        groupValue:
                                            addressController.kurir.value,
                                        onChanged: (value) {
                                          addressController.hiddenKurir.value =
                                              true;
                                          addressController
                                              .hiddenLoading.value = false;
                                          addressController.kurir.value =
                                              value!;
                                        },
                                      ),
                                      Text('Pos Indonesia',
                                          style: GoogleFonts.poppins(
                                              color: Colors.black)),
                                    ],
                                  ),
                                ],
                              ))
                      ],
                    ),
            ),
            Obx(
              () => addressController.hiddenLoading.isFalse
                  ? SizedBox(
                      width: 50.w,
                      height: 50.h,
                      child: const CircularProgressIndicator(),
                    )
                  : addressController.hiddenKurir.isTrue
                      ? const SizedBox()
                      : const Kurir(),
            ),
          ],
        ),
      ),
    );
  }
}
