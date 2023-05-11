import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class InputBox extends StatelessWidget {
  InputBox({
    Key? key,
    required this.isPassword,
    required this.hintText,
    required this.textController,
  }) : super(key: key);
  bool isPassword;
  String hintText;
  TextEditingController textController;
  @override
  Widget build(BuildContext context) {
    var isShowPassword = false.obs;
    return Container(
      width: 277.w,
      height: 60.h,
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 15),
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
      decoration: BoxDecoration(
          border: Border.all(width: 2, color: const Color(0xffBCD1D8)),
          color: const Color(0xffD9D9D9),
          borderRadius: BorderRadius.circular(15).r),
      child: Center(
        child: Obx(
          () => TextField(
            keyboardType: isPassword ? null : TextInputType.emailAddress,
            obscureText: (!isShowPassword.value && isPassword) ? true : false,
            style: GoogleFonts.poppins(fontSize: 18),
            controller: textController,
            cursorColor: Colors.blueGrey,
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hintText,
                suffixIcon: isPassword
                    ? isShowPassword.value
                        ? IconButton(
                            onPressed: () {
                              isShowPassword.value = !isShowPassword.value;
                            },
                            icon: const Icon(
                              CupertinoIcons.eye_fill,
                              size: 22,
                            ))
                        : IconButton(
                            onPressed: () {
                              isShowPassword.value = !isShowPassword.value;
                            },
                            icon: const Icon(
                              CupertinoIcons.eye_slash_fill,
                              size: 22,
                            ))
                    : null),
          ),
        ),
      ),
    );
  }
}
