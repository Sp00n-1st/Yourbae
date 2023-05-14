import 'dart:convert';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../controller/home_controller.dart';
import '../model/province_model.dart';

class Provinsi extends GetView<HomeController> {
  const Provinsi({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: DropdownSearch<Province>(
        label: "Province",
        showClearButton: true,
        onFind: (String filter) async {
          Uri url = Uri.parse("https://api.rajaongkir.com/starter/province");

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

            var listAllProvince =
                data["rajaongkir"]["results"] as List<dynamic>;

            var models = Province.fromJsonList(listAllProvince);
            return models;
          } catch (err) {
            print(err);
            return List<Province>.empty();
          }
        },
        onChanged: (prov) {
          if (prov != null) {
            controller.hiddenKotaTujuan.value = false;
            controller.provTujuanId.value = int.parse(prov.provinceId!);
          } else {
            controller.hiddenKotaTujuan.value = true;
            controller.provTujuanId.value = 0;
          }
          controller.showButton();
        },
        showSearchBox: true,
        searchBoxDecoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 25,
          ),
          hintText: "Search Province...",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
          ),
        ),
        popupItemBuilder: (context, item, isSelected) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              "${item.province}",
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          );
        },
        itemAsString: (item) => item.province!,
      ),
    );
  }
}