import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class MenuProfile extends StatelessWidget {
  String image, namaMenu;
  void Function()? fun;
  MenuProfile({Key? key, this.fun, required this.image, required this.namaMenu})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: fun,
      child: Container(
        padding: EdgeInsets.fromLTRB(24.sp, 0, 24.sp, 0),
        width: 282.w,
        height: 51.h,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.sp),
            color: Color(0xffCDD0CB)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(width: 22.5.w, height: 22.5.h, child: Image.asset(image)),
            Text(
              namaMenu,
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500, fontSize: 20),
            ),
            IconButton(onPressed: fun, icon: Icon(CupertinoIcons.chevron_right))
          ],
        ),
      ),
    );
  }
}
