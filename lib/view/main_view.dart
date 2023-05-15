import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yourbae_project/controller/controller.dart';
import 'package:yourbae_project/view_model/list_view_product.dart';
import 'package:yourbae_project/view_model/tab_button.dart';

import '../model/product_model.dart';
import '../view_model/single_product.dart';

class MainView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    final auth = FirebaseAuth.instance.currentUser!.uid;
    var controller = Get.put(Controller());
    Query<Product> products = firestore
        .collection('product')
        .withConverter<Product>(
            fromFirestore: (snapshot, _) => Product.fromJson(snapshot.data()),
            toFirestore: (product, _) => product.toJson());
    return Scaffold(
      appBar: AppBar(
          toolbarHeight: 10.h,
          elevation: 0,
          backgroundColor: Colors.transparent),
      backgroundColor: Colors.grey.shade200,
      body: Container(
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 0).r,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Delivery Addres',
                      style: GoogleFonts.poppins(
                          fontSize: 14.sp, color: Colors.grey),
                    ),
                    Text(
                      'Jl.Pagarsih',
                      style: GoogleFonts.poppins(
                          fontSize: 14.sp, color: Colors.black),
                    )
                  ],
                ),
                // SizedBox(
                //     height: 50.h,
                //     width: 50.w,
                //     child: ElevatedButton(
                //       style: ElevatedButton.styleFrom(
                //           elevation: 0,
                //           backgroundColor: Colors.white,
                //           shape: RoundedRectangleBorder(
                //               side:
                //                   BorderSide(color: Colors.grey, width: 1.5.r),
                //               borderRadius: BorderRadius.circular(15).r)),
                //       onPressed: () {},
                //       child: Icon(
                //         CupertinoIcons.search,
                //         color: Colors.black,
                //       ),
                //     ))
              ],
            ),
            SizedBox(
              height: 20.h,
            ),
            Text(
              'Brands',
              style: GoogleFonts.poppins(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.black),
            ),
            SizedBox(
              height: 10.h,
            ),
            const TabButton(),
            SizedBox(
              height: 20.h,
            ),
            Obx(
              () => StreamBuilder(
                  stream: products
                      .orderBy('nameProduct', descending: false)
                      .where('category', isEqualTo: controller.category.value)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(snapshot.error.toString()),
                      );
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: Container(
                            width: 100,
                            height: 100,
                            margin: const EdgeInsets.only(top: 130),
                            child: const CircularProgressIndicator()),
                      );
                    }
                    if (!snapshot.hasData) {
                      return const Image(
                        image: AssetImage('assets/nodata3.gif'),
                        fit: BoxFit.fill,
                      );
                    }

                    final data = snapshot.requireData;
                    return data.size != 0
                        ? Container(
                            padding: const EdgeInsets.only(bottom: 0).r,
                            width: 370.w,
                            height: 350.h,
                            child: MediaQuery.removePadding(
                              context: context,
                              removeTop: true,
                              child: GridView.builder(
                                  itemCount: data.size,
                                  gridDelegate:
                                      SliverGridDelegateWithMaxCrossAxisExtent(
                                          maxCrossAxisExtent: 200,
                                          childAspectRatio: 3 / 4.5.r,
                                          crossAxisSpacing: 20.r,
                                          mainAxisSpacing: 5.r),
                                  itemBuilder: (context, index) =>
                                      SingleProduct(
                                        product: data.docs[index].data(),
                                        id: data.docs[index].id,
                                      )),
                            ))
                        : const Image(
                            image: AssetImage('assets/nodata3.gif'),
                            fit: BoxFit.fill,
                          );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
