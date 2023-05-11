import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: must_be_immutable
class CustomButton extends StatelessWidget {
  CustomButton({Key? key, required this.image}) : super(key: key);
  String image;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 53.w,
      height: 53.h,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xffD9D9D9),
              shape: RoundedRectangleBorder(
                  side: const BorderSide(color: Color(0xffBCD1D8)),
                  borderRadius: BorderRadius.circular(15).r)),
          onPressed: () {},
          child: Image.asset(
            'assets/$image.png',
            fit: BoxFit.contain,
          )),
    );
  }
}
