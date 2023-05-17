import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yourbae_project/view_model/kurir.dart';

import '../controller/alamat_controller.dart';
import '../view_model/alamat.dart';
import '../view_model/city.dart';
import '../view_model/province.dart';

class InputAlamat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var alamatController = Get.put(AlamatController());

    List<String> options = ['JNE', 'Pos Indonesia'];

    var category = 'jne'.obs;

    var selectedOption = Rxn<String>();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(CupertinoIcons.back),
          color: Colors.black,
        ),
        title: Text(
          'Input Alamat',
          style: TextStyle(color: Colors.black),
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
                  label: Text('Alamat'), border: OutlineInputBorder()),
            ),
            SizedBox(
              height: 20,
            ),
            Provinsi(),
            Obx(
              () => alamatController.hiddenKotaTujuan.isTrue
                  ? SizedBox()
                  : Column(
                      children: [
                        Kota(
                          provId: alamatController.provTujuanId.value,
                        ),
                        Obx(() => alamatController.hiddenRadio.isTrue
                            ? SizedBox()
                            : Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Row(
                                    children: [
                                      Radio(
                                        value: 'jne',
                                        groupValue:
                                            alamatController.kurir.value,
                                        onChanged: (value) {
                                          alamatController.hiddenKurir.value =
                                              true;
                                          alamatController.hiddenLoading.value =
                                              false;
                                          alamatController.kurir.value = value!;
                                          alamatController.ongkosKirim();
                                        },
                                      ),
                                      Text('JNE'),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Radio(
                                        value: 'pos',
                                        groupValue:
                                            alamatController.kurir.value,
                                        onChanged: (value) {
                                          alamatController.hiddenKurir.value =
                                              true;
                                          alamatController.hiddenLoading.value =
                                              false;
                                          alamatController.kurir.value = value!;
                                          alamatController.ongkosKirim();
                                        },
                                      ),
                                      Text('Pos Indonesia'),
                                    ],
                                  ),
                                ],
                              ))
                      ],
                    ),
            ),
            Obx(
              () => alamatController.hiddenLoading.isFalse
                  ? SizedBox(
                      width: 50.w,
                      height: 50.h,
                      child: CircularProgressIndicator(),
                    )
                  : alamatController.hiddenKurir.isTrue
                      ? SizedBox()
                      : Kurir(),
            ),

            // Obx(
            //   () => SizedBox(
            //     width: double.infinity,
            //     child: ElevatedButton(
            //       onPressed: alamatController.hiddenButton.isTrue
            //           ? null
            //           : () {
            //               alamatController.ongkosKirim();
            //               // print(alamatController.kotaTujuanId);
            //               // print(alamatController.provTujuanId);
            //             },
            //       child: Text("SAVE"),
            //       style: ElevatedButton.styleFrom(
            //         padding: EdgeInsets.symmetric(vertical: 20),
            //         backgroundColor: Colors.blue[900],
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
