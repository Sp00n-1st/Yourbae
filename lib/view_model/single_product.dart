import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../controller/firebase_controller.dart';
import '../model/product_model.dart';
import '../model/rating_model.dart';
import '../model/wishlist_model.dart';
import '../view/product_detail.dart';

class SingleProduct extends StatelessWidget {
  const SingleProduct({Key? key, required this.product, required this.id})
      : super(key: key);
  final Product product;
  final String id;

  @override
  Widget build(BuildContext context) {
    var firebaseController = Get.put(FirebaseController());
    dynamic data;
    double star = 0;
    return GestureDetector(
      onTap: () {
        Get.to(
            ProductDetail(
              product: product,
              id: id,
            ),
            transition: Transition.leftToRightWithFade);
      },
      child: StreamBuilder<QuerySnapshot<RatingModel>>(
          stream: firebaseController
              .queryRating()
              .where('idProduct', isEqualTo: id)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text('Error'),
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: SizedBox(
                    width: 50.w,
                    height: 50.h,
                    child: const CircularProgressIndicator()),
              );
            } else if (snapshot.hasData) {
              if (snapshot.data!.docs.isEmpty) {
                star = 0;
              } else {
                for (int i = 0; i < snapshot.data!.docs.length; i++) {
                  data = snapshot.data!.docs;
                  star += data.elementAt(i).data().star;
                }
                star /= data.length;
              }

              return Column(
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
                        child: Image.network(product.imageUrl.elementAt(0)),
                      ),
                      StreamBuilder<QuerySnapshot<WishlistModel>>(
                          stream:
                              firebaseController.queryWishlist().snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                            } else if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                            } else if (snapshot.hasData) {
                              bool isIdFound = snapshot.data!.docs
                                  .any((doc) => doc['idProduct'] == id);
                              return Align(
                                alignment: Alignment.topRight,
                                child: SizedBox(
                                  height: 30.h,
                                  width: 30.w,
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              const Color(0xffEFEFEF),
                                          padding: EdgeInsets.zero,
                                          alignment: Alignment.center,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15).r)),
                                      onPressed: () async {
                                        await firebaseController.addWishList(
                                            snapshot.data!.docs, id);
                                      },
                                      child: Icon(
                                        isIdFound
                                            ? Icons.bookmark
                                            : Icons.bookmark_border,
                                        color: Colors.black,
                                      )),
                                ),
                              );
                            }
                            return const SizedBox();
                          })
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
                          style: GoogleFonts.poppins(
                              fontSize: 14.sp, color: Colors.grey),
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
                              star == 0
                                  ? 'Belum Cukup Rating'
                                  : star.toStringAsFixed(1),
                              style: GoogleFonts.poppins(
                                  fontSize: star == 0 ? 10.sp : 18.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black),
                            )
                          ],
                        )
                      ],
                    ),
                  )
                ],
              );
            }
            return const SizedBox();
          }),
    );
  }
}
