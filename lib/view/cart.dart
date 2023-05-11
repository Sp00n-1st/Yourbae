import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class Cart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'My Cart',
          style: GoogleFonts.poppins(
              color: Colors.black, fontWeight: FontWeight.w600, fontSize: 30),
        ),
      ),
      body: Container(
        margin: EdgeInsets.fromLTRB(28.sp, 0, 28.sp, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 30.h,
            ),
            Container(
              width: 315.w,
              height: 90.h,
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  color: Color(0xffd9d9d9)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                      height: 70,
                      width: 120,
                      child: Image.asset('assets/contoh.png')),
                  SizedBox(
                    width: 20.w,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Adidas',
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500, fontSize: 16.sp),
                      ),
                      Text(
                        'Rp. 1000',
                        style: GoogleFonts.exo(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: Color(0xff575757)),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 20.w,
                  ),
                  Text(
                    '1',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500, fontSize: 24),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
