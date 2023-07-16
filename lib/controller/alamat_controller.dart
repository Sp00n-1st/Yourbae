import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:oktoast/oktoast.dart';
import '../model/raja_ongkir_model.dart';
import '../model/province_model.dart';

class AlamatController extends GetxController {
  var hiddenKotaAsal = true.obs;
  var provAsalId = 22.obs;
  var kotaAsalId = 22.obs;
  var hiddenKotaTujuan = true.obs;
  var provTujuanId = 0.obs;
  var kotaTujuanId = 0.obs;
  var hiddenButton = true.obs;
  var hiddenRadio = true.obs;
  var hiddenKurir = true.obs;
  var hiddenLoading = true.obs;
  var kurir = ''.obs;
  var cost = 0.obs;
  var namaProvinsi = ''.obs;
  var namaKotaKab = ''.obs;
  var service = ''.obs;
  late TextEditingController beratC;
  RajaOngkirModel? rajaOngkirModel;

  Future<List<Province>> getDataAddress(String filter) async {
    Uri url = Uri.parse("https://api.rajaongkir.com/starter/province");
    try {
      final response = await http.get(
        url,
        headers: {
          "key": "401c597e3c8742eacce68bf648458b1b",
        },
      );
      var data = json.decode(response.body) as Map<String, dynamic>;
      var statusCode = data["rajaongkir"]["status"]["code"];
      if (statusCode != 200) {
        throw data["rajaongkir"]["status"]["description"];
      }
      var listAllProvince = data["rajaongkir"]["results"] as List<dynamic>;
      var models = Province.fromJsonList(listAllProvince);
      return models;
    } catch (err) {
      return List<Province>.empty();
    }
  }

  void ongkosKirim(int qty) async {
    int berat = 150 * qty;
    Uri url = Uri.parse("https://api.rajaongkir.com/starter/cost");
    try {
      final response = await http.post(
        url,
        body: {
          "origin": "$kotaAsalId",
          "destination": "$kotaTujuanId",
          "weight": "$berat",
          "courier": "$kurir",
        },
        headers: {
          "key": "401c597e3c8742eacce68bf648458b1b",
          "content-type": "application/x-www-form-urlencoded",
        },
      );
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        rajaOngkirModel = RajaOngkirModel.fromJson(data);
      } else {
        showToast(response.body,
            position: const ToastPosition(align: Alignment.bottomCenter));
      }
      hiddenKurir.value = false;
      hiddenLoading.value = true;
    } catch (err) {
      Get.defaultDialog(
        title: "Terjadi Kesalahan",
        middleText: err.toString(),
      );
    }
  }

  void showButton() {
    if (kotaTujuanId.value != 0) {
      hiddenButton.value = false;
      hiddenRadio.value = false;
    } else {
      hiddenButton.value = true;
      hiddenRadio.value = true;
    }
  }
}
