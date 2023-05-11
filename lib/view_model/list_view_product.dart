import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yourbae_project/view/product_detail.dart';

import 'single_product.dart';

class ListViewProduct extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Get.to(ProductDetail(), transition: Transition.leftToRightWithFade);
      },
      child: Container(
          padding: const EdgeInsets.only(bottom: 0).r,
          width: 370.w,
          height: 350.h,
          child: MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: GridView.builder(
                itemCount: 6,
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    childAspectRatio: 3 / 4.18.r,
                    crossAxisSpacing: 20.r,
                    mainAxisSpacing: 5.r),
                itemBuilder: (context, index) => Center()),
          )),
    );
  }
}
