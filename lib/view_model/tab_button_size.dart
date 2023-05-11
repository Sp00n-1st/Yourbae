import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controller/controller.dart';

class TabButtonSize extends StatelessWidget {
  const TabButtonSize({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(Controller());
    int selectTab;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [tabSize('37', () {}, 100)],
      ),
    );
  }

  Widget tabSize(String size, VoidCallback onPressed, int stock) {
    return SizedBox(
        width: 80.w,
        height: 50.h,
        child: ElevatedButton(
            onPressed: onPressed,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  size,
                  style: GoogleFonts.poppins(),
                ),
                Row(
                  children: [
                    Text(
                      'Stok : ',
                      style: GoogleFonts.poppins(fontSize: 12.sp),
                    ),
                    Text(
                      stock.toString(),
                      style: GoogleFonts.poppins(fontSize: 12.sp),
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                )
              ],
            )));
  }
}
