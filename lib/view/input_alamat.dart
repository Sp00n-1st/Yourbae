import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/home_controller.dart';
import '../view_model/alamat.dart';
import '../view_model/city.dart';
import '../view_model/province.dart';

class InputAlamat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var controller = Get.put(HomeController());
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
          'Input Address',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(20),
          children: [
            Alamat(),
            SizedBox(
              height: 20,
            ),
            Provinsi(),
            Obx(
              () => controller.hiddenKotaTujuan.isTrue
                  ? SizedBox()
                  : Kota(
                      provId: controller.provTujuanId.value,
                    ),
            ),
            Obx(
              () => ElevatedButton(
                onPressed: controller.hiddenButton.isTrue
                    ? null
                    : () => controller.ongkosKirim(),
                child: Text("SAVE"),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  backgroundColor: Colors.blue[900],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
