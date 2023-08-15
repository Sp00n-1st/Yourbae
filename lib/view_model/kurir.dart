import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../controller/address_controller.dart';

class Kurir extends GetView<AddressController> {
  const Kurir({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var addressController = Get.put(AddressController());
    var data = addressController.rajaOngkirModel!.rajaongkir!.results![0];
    return Column(
      children: [
        SizedBox(
          height: 10.h,
        ),
        Text(
          'Silahkan Pilih Service Yang Di Inginkan : ',
          style: GoogleFonts.poppins(),
        ),
        SizedBox(
          height: 10.h,
        ),
        Column(
          children: data.costs!
              .map(
                (e) => GestureDetector(
                  onTap: () {
                    addressController.cost.value = e.cost![0].value!;
                    addressController.service.value = e.service!;
                  },
                  child: Obx(
                    () => ListTile(
                      tileColor:
                          addressController.cost.value == e.cost![0].value!
                              ? Colors.green.shade200
                              : null,
                      title: Text(
                        e.service!,
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(
                          NumberFormat.currency(locale: 'id', symbol: 'Rp. ')
                              .format(e.cost![0].value),
                          style: GoogleFonts.poppins()),
                      trailing: Text(
                          data.code == "pos"
                              ? e.cost![0].etd!
                              : "${e.cost![0].etd} HARI",
                          style:
                              GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
