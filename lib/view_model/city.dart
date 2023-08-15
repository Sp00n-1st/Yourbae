import 'dart:convert';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../controller/address_controller.dart';
import '../model/city_model.dart';

class Kota extends GetView<AddressController> {
  const Kota({
    Key? key,
    required this.provId,
  }) : super(key: key);
  final int provId;

  @override
  Widget build(BuildContext context) {
    AddressController addressController = Get.put(AddressController());

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: DropdownSearch<City>(
        label: "Kota / Kabupaten",
        showClearButton: true,
        onFind: (String filter) async {
          Uri url = Uri.parse(
            "https://api.rajaongkir.com/starter/city?province=$provId",
          );
          try {
            final response = await http.get(
              url,
              headers: {
                "key": "0ae702200724a396a933fa0ca4171a7e",
              },
            );
            var data = json.decode(response.body) as Map<String, dynamic>;
            var statusCode = data["rajaongkir"]["status"]["code"];
            if (statusCode != 200) {
              throw data["rajaongkir"]["status"]["description"];
            }
            var listAllCity = data["rajaongkir"]["results"] as List<dynamic>;
            var models = City.fromJsonList(listAllCity);
            return models;
          } catch (err) {
            return List<City>.empty();
          }
        },
        onChanged: (cityValue) {
          if (cityValue != null) {
            controller.kotaTujuanId.value = int.parse(cityValue.cityId!);
            addressController.namaKotaKab.value = cityValue.cityName!;
          } else {
            addressController.kurir.value = '';
            addressController.cost.value = 0;
            controller.kotaTujuanId.value = 0;
          }
          controller.showButton();
        },
        showSearchBox: true,
        searchBoxDecoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 25,
          ),
          hintText: "Search kota / kabupaten...",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
          ),
        ),
        popupItemBuilder: (context, item, isSelected) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              "${item.type} ${item.cityName}",
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
          );
        },
        itemAsString: (item) => "${item.type} ${item.cityName}",
      ),
    );
  }
}
