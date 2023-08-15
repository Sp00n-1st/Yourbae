import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yourbae_project/controller/address_controller.dart';
import '../model/province_model.dart';

class Provinsi extends GetView<AddressController> {
  const Provinsi({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AddressController addressController = Get.put(AddressController());
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: DropdownSearch<Province>(
        label: "Provinsi",
        showClearButton: true,
        onFind: controller.getDataAddress,
        onChanged: (prov) {
          if (prov != null) {
            addressController.hiddenKotaTujuan.value = true;
            addressController.kurir.value = '';
            addressController.cost.value = 0;
            addressController.namaProvinsi.value = prov.province!;
            Future.delayed(
              const Duration(milliseconds: 10),
              () {
                addressController.hiddenKotaTujuan.value = false;
                addressController.hiddenRadio.value = true;
              },
            );
            controller.provTujuanId.value = int.parse(prov.provinceId!);
          } else {
            controller.hiddenKotaTujuan.value = true;
            controller.provTujuanId.value = 0;
            addressController.hiddenKotaTujuan.value = true;
            addressController.hiddenRadio.value = true;
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
          hintText: "Search Provinsi...",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
          ),
        ),
        popupItemBuilder: (context, item, isSelected) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              "${item.province}",
              style: const TextStyle(
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
