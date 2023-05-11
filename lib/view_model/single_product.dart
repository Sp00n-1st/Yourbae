import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yourbae_project/model/product_model.dart';
import 'package:intl/intl.dart';
import '../view/product_detail.dart';

class SingleProduct extends StatelessWidget {
  SingleProduct({Key? key, required this.product}) : super(key: key);

  Product product;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(ProductDetail(product: product),
            transition: Transition.leftToRightWithFade);
      },
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(10).r,
                width: double.infinity,
                height: 150.h,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50).r),
                child: Image.network(product.imageUrl),
              ),
              Align(
                alignment: Alignment.topRight,
                child: SizedBox(
                  height: 30.h,
                  width: 30.w,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xffEFEFEF),
                          padding: EdgeInsets.zero,
                          alignment: Alignment.center,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15).r)),
                      onPressed: () {},
                      child: const Icon(
                        Icons.bookmark_border,
                        color: Colors.black,
                      )),
                ),
              )
            ],
          ),
          SizedBox(
            height: 10.h,
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(10, 0, 0, 0).r,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.nameProduct,
                  maxLines: 1,
                  softWrap: true,
                  overflow: TextOverflow.fade,
                  style: GoogleFonts.poppins(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.black),
                ),
                Text(
                  NumberFormat.currency(locale: 'id', symbol: 'Rp. ')
                      .format(product.price),
                  style:
                      GoogleFonts.poppins(fontSize: 14.sp, color: Colors.grey),
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.star,
                      color: Color(0xffF2921D),
                    ),
                    SizedBox(
                      width: 5.w,
                    ),
                    Text(
                      '5.0',
                      style: GoogleFonts.poppins(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
