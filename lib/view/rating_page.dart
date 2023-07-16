import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controller/firebase_controller.dart';
import '../model/order_model.dart';

class RatingPage extends StatelessWidget {
  const RatingPage(
      {super.key,
      required this.imageUrl,
      required this.idProduct,
      required this.idOrder,
      required this.namaProduk,
      required this.size,
      required this.index,
      required this.orderModel});
  final String namaProduk, idProduct, idOrder;
  final List<dynamic> imageUrl;
  final int size, index;
  final OrderModel orderModel;

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firebase = FirebaseFirestore.instance;
    CollectionReference<Map<String, dynamic>> order =
        firebase.collection('order');
    RxDouble star = 0.0.obs;
    TextEditingController commentController = TextEditingController();
    RxBool empty = true.obs;
    FirebaseController firebaseController = Get.put(FirebaseController());
    List<Widget> listImage = <Widget>[];

    for (String image in imageUrl) {
      listImage.add(
        Image.network(
          image,
          fit: BoxFit.contain,
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              CupertinoIcons.chevron_back,
              color: Colors.black,
            ),
            onPressed: () {
              Get.back();
            },
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text('Rating Produk',
              style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 30))),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.r),
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  width: 200.w,
                  height: 200.h,
                  child: ImageSlideshow(
                    indicatorBackgroundColor: Colors.white,
                    children: listImage,
                  ),
                ),
                Text(
                  '$namaProduk - Size $size',
                  style: GoogleFonts.poppins(
                      fontSize: 18.sp, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 20.h,
                ),
                RatingBar.builder(
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: false,
                  itemCount: 5,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    star.value = rating;
                  },
                ),
                SizedBox(
                  height: 20.h,
                ),
                TextField(
                  onChanged: (value) {
                    if (value == '') {
                      empty.value = true;
                    } else {
                      empty.value = false;
                    }
                  },
                  controller: commentController,
                  maxLines: 5,
                  decoration:
                      const InputDecoration(border: OutlineInputBorder()),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Obx(
                  () => firebaseController.isLoading.isTrue
                      ? SizedBox(
                          width: 50.w,
                          height: 50.h,
                          child: const CircularProgressIndicator(),
                        )
                      : ActionChip(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.fromLTRB(80, 15, 80, 15).r,
                          label: Text(
                            'Kirim',
                            style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500),
                          ),
                          onPressed: (star.value == 0 || empty.isTrue)
                              ? null
                              : () {
                                  orderModel.isRating[index] = true;
                                  firebaseController.isLoading.value = true;
                                  order.doc(idOrder).update(
                                      ({'isRating': orderModel.isRating}));
                                  firebaseController.addRating(
                                      idProduct,
                                      star.value,
                                      commentController.value.text,
                                      size);
                                  Get.back();
                                  CoolAlert.show(
                                      context: context,
                                      type: CoolAlertType.success,
                                      loopAnimation: true,
                                      widget: Text(
                                        'Rating Telah Ditambahkan',
                                        style: GoogleFonts.poppins(),
                                      ));
                                },
                        ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
