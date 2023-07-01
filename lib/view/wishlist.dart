import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yourbae_project/controller/firebase_controller.dart';
import 'package:yourbae_project/model/user_model.dart';
import 'package:yourbae_project/model/wishlist_model.dart';
import 'package:yourbae_project/view_model/custom_appbar.dart';

import '../view_model/single_product.dart';

class WishList extends StatelessWidget {
  const WishList({super.key, required this.listWishList});
  final List<QueryDocumentSnapshot<WishlistModel>> listWishList;

  @override
  Widget build(BuildContext context) {
    var firebaseController = Get.put(FirebaseController());
    return Scaffold(
        backgroundColor: Colors.grey.shade200,
        appBar: CustomAppBar(
          title: 'Wishlist',
          fun: () {
            Get.back();
          },
        ),
        body: Padding(
          padding: EdgeInsets.all(20.r),
          child: listWishList.isEmpty
              ? const Image(
                  image: AssetImage('assets/nodata3.gif'),
                  fit: BoxFit.fill,
                )
              : GridView.builder(
                  itemCount: listWishList.length,
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      childAspectRatio: 3 / 4.5.r,
                      crossAxisSpacing: 20.r,
                      mainAxisSpacing: 5.r),
                  itemBuilder: (context, index) {
                    WishlistModel wishList =
                        listWishList.elementAt(index).data();
                    return StreamBuilder(
                        stream: firebaseController
                            .querySingleProduct(wishList.idProduct)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return const Center(
                              child: Text('Error'),
                            );
                          } else if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (snapshot.hasData) {
                            print('build');
                            return SingleProduct(
                                product: snapshot.data!.data()!,
                                id: snapshot.data!.id);
                          }
                          return const Image(
                            image: AssetImage('assets/nodata3.gif'),
                            fit: BoxFit.fill,
                          );
                        });
                  }),
        ));
  }
}
