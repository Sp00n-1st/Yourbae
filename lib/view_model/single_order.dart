import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class SingleOrder extends StatelessWidget {
  const SingleOrder(
      {super.key,
      required this.box1,
      required this.box2,
      required this.box3,
      required this.box4,
      required this.totalAll});
  final String box1, box2, box3, box4;
  final num totalAll;

  @override
  Widget build(BuildContext context) {
    double sizeWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      height: 90.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            padding: const EdgeInsets.only(left: 5),
            width: sizeWidth * 0.25,
            child: Text(
              box1,
              style: GoogleFonts.poppins(fontSize: 12.sp),
              softWrap: true,
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 5),
            width: sizeWidth * 0.1,
            child: Center(
              child: Text(
                box2,
                style: GoogleFonts.poppins(fontSize: 12.sp),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 5),
            width: sizeWidth * 0.1,
            child: Center(
              child: Text(
                box3,
                style: GoogleFonts.poppins(fontSize: 12.sp),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 5),
            width: sizeWidth * 0.30,
            child: Text(
              NumberFormat.currency(locale: 'id', symbol: 'Rp. ')
                  .format(double.tryParse(box4)),
              style: GoogleFonts.poppins(fontSize: 12.sp),
              overflow: TextOverflow.clip,
              softWrap: false,
            ),
          ),
        ],
      ),
    );
  }
}
