import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yourbae_project/controller/controller.dart';

class CustomInputBox extends StatelessWidget {
  final String hintText, errorMessage;
  final TextEditingController controllerText;
  final bool isPassword;
  const CustomInputBox(
      {super.key,
      required this.hintText,
      required this.errorMessage,
      required this.controllerText,
      required this.isPassword});

  @override
  Widget build(BuildContext context) {
    var isShowPassword = false.obs;
    var controller = Get.put(Controller());
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20).r,
      child: Obx(
        () => TextFormField(
          obscureText: (!isShowPassword.value && isPassword) ? true : false,
          style: GoogleFonts.poppins(),
          controller: controllerText,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
              errorStyle:
                  GoogleFonts.poppins(fontSize: 12.sp, color: Colors.red),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide:
                      BorderSide(color: Colors.blue.shade900, width: 2)),
              hintText: hintText,
              border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
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
          validator: (value) {
            if (value == null || value.isEmpty) {
              // Future.delayed(const Duration(milliseconds: 50), () {
              //   controller.isEmpty.value = true;
              // });
              return errorMessage;
            } else {
              // Future.delayed(const Duration(milliseconds: 50), () {
              //   controller.isEmpty.value = false;
              // });
            }

            return null;
          },
          autovalidateMode: AutovalidateMode.onUserInteraction,
        ),
      ),
    );
  }
}