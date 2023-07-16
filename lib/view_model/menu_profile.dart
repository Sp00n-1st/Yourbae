import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class MenuProfile extends StatelessWidget {
  const MenuProfile(
      {Key? key,
      this.fun,
      required this.image,
      required this.namaMenu,
      required this.duration})
      : super(key: key);
  final String image, namaMenu;
  final void Function()? fun;
  final int duration;

  @override
  Widget build(BuildContext context) {
    var width = 0.0.obs;
    var isShow = false.obs;
    Future.delayed(
      Duration(milliseconds: duration),
      () {
        width.value = 500.w;
      },
    ).then((value) {
      Future.delayed(
        const Duration(milliseconds: 500),
        () {
          isShow.value = true;
        },
      );
    });
    return GestureDetector(
      onTap: fun,
      child: Obx(
        () => AnimatedContainer(
          duration: const Duration(milliseconds: 1000),
          padding: EdgeInsets.fromLTRB(15.r, 0, 15.r, 0),
          width: width.value,
          height: 51.h,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.sp),
              color: const Color(0xffCDD0CB)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              isShow.isFalse
                  ? const SizedBox()
                  : Container(
                      margin: EdgeInsets.only(right: 10.r),
                      width: 20.w,
                      height: 20.h,
                      child: Image.asset(image)),
              isShow.isFalse
                  ? const SizedBox()
                  : SizedBox(
                      width: 160.w,
                      child: Text(
                        namaMenu,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500, fontSize: 16.sp),
                      ),
                    ),
              IconButton(
                  onPressed: fun,
                  icon: const Icon(CupertinoIcons.chevron_right))
            ],
          ),
        ),
      ),
    );
  }
}
