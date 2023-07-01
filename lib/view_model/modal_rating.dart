import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yourbae_project/model/order_model.dart';
import 'package:yourbae_project/view/rating_page.dart';

class ModalRating {
  showModal(BuildContext context, OrderModel orderModel, String idOrder) {
    final firebase = FirebaseFirestore.instance;
    final product = firebase.collection('product');
    return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0).r,
          width: double.infinity,
          height: (orderModel.idProduct.length * 50.h) + 130.h,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.r),
                  topRight: Radius.circular(20.r))),
          child: Column(
            children: [
              Text(
                'Pilih Item Mana Yang Akan Di Beri Rating',
                style: GoogleFonts.poppins(
                    fontSize: 14.sp, fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 20.h,
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: orderModel.idProduct.length,
                itemBuilder: (context, index) {
                  return orderModel.isRating.elementAt(index) == true
                      ? const SizedBox()
                      : StreamBuilder(
                          stream: product
                              .doc(orderModel.idProduct[index])
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return const Center(
                                child: Text('Error'),
                              );
                            } else if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center();
                            }
                            return MaterialButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  Get.to(RatingPage(
                                    orderModel: orderModel,
                                    idOrder: idOrder,
                                    idProduct: snapshot.data!.id,
                                    imageUrl: snapshot.data?['imageUrl'],
                                    namaProduk: snapshot.data?['nameProduct'],
                                    size: orderModel.size[index],
                                    index: index,
                                  ));
                                },
                                child: Container(
                                    height: 20.h,
                                    width: double.infinity,
                                    decoration: const BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Colors.black))),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 220.w,
                                          child: Text(
                                            snapshot.data?['nameProduct'],
                                            maxLines: 1,
                                            softWrap: true,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.poppins(
                                                fontSize: 14.sp,
                                                color: Colors.black),
                                          ),
                                        ),
                                        Text(
                                          ' - Size ${orderModel.size[index]}',
                                          style: GoogleFonts.poppins(
                                              fontSize: 14.sp,
                                              color: Colors.black),
                                        )
                                      ],
                                    )));
                          },
                        );
                },
              )
            ],
          ),
        );
      },
    );
  }
}
