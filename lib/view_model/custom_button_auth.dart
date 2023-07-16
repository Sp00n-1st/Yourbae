import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomButtonAuth extends StatelessWidget {
  const CustomButtonAuth({Key? key, required this.nameButton, this.fun})
      : super(key: key);
  final String nameButton;
  final void Function()? fun;

  @override
  Widget build(BuildContext context) {
    var width = 0.0.obs, height = 0.0.obs;
    Future.delayed(
      const Duration(milliseconds: 100),
      () {
        width.value = 277.w;
        height.value = 60.h;
      },
    );
    return Obx(
      () => AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: width.value,
        height: height.value,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff156897),
                shape: RoundedRectangleBorder(
                    side: const BorderSide(width: 2, color: Color(0xffbcd1d8)),
                    borderRadius: BorderRadius.circular(15).r)),
            onPressed: fun,
            child: Text(
              nameButton,
              style: GoogleFonts.poppins(
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
            )),
      ),
    );
  }
}
