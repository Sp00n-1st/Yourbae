import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:yourbae_project/view/payment_confirmation.dart';
import '../model/order_model.dart';
import '../view_model/list_order.dart';

class OrderPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double sizeWidth = MediaQuery.of(context).size.width;
    double sizeHeight = MediaQuery.of(context).size.height;
    final firabase = FirebaseFirestore.instance;
    final auth = FirebaseAuth.instance.currentUser!.uid;
    final orderRef = firabase.collection('order');
    final order = firabase
        .collection('order')
        .where('uidUser', isEqualTo: auth)
        .withConverter<OrderModel>(
            fromFirestore: (snapshot, _) =>
                OrderModel.fromJson(snapshot.data()),
            toFirestore: (orderModel, _) => orderModel.toJson());
    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text('Pesanan',
                style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 30))),
        body: SizedBox(
          height: sizeHeight,
          child: StreamBuilder<QuerySnapshot<OrderModel>>(
              stream: order.snapshots(),
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
                } else if (!snapshot.hasData) {
                  return Center(
                    child: Image.asset('gifLoading.gif'),
                  );
                } else if (snapshot.data!.size == 0) {
                  return Center(
                      child: SizedBox(
                          width: 600,
                          height: 400,
                          child: ElevatedButton(
                              onPressed: () {
                                print(snapshot.data!.size);
                              },
                              child: const Text('data'))));
                }

                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.size,
                  itemBuilder: (context, index) {
                    num totalAll = 0;
                    // for (int i = 0;
                    //     i <
                    //         snapshot.data!.docs
                    //             .elementAt(index)
                    //             .data()
                    //             .total
                    //             .length;
                    //     i++) {
                    //   totalAll +=
                    //       snapshot.data!.docs.elementAt(index).data().total[i];
                    // }

                    var dateTime = DateFormat('dd/MM/yyyy').format(snapshot
                        .data!.docs
                        .elementAt(index)
                        .data()
                        .timeStamp
                        .toDate());

                    return Container(
                      margin:
                          const EdgeInsets.only(right: 5, left: 5, bottom: 20),
                      decoration: BoxDecoration(
                          color: Colors.grey[300],
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            const BoxShadow(
                                blurRadius: 1.1,
                                color: Colors.black,
                                offset: Offset(0.5, 0.5))
                          ]),
                      child: Column(
                        children: [
                          Container(
                              height: sizeHeight * 0.05,
                              padding:
                                  const EdgeInsets.only(left: 20, right: 20),
                              width: sizeWidth * 0.97,
                              decoration: const BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(color: Colors.black))),
                              child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        dateTime,
                                        style: GoogleFonts.poppins(),
                                      ),
                                      snapshot.data!.docs
                                                  .elementAt(index)
                                                  .data()
                                                  .isPay ==
                                              true
                                          ? Text(
                                              'Menunggu Konfirmasi Admin',
                                              style: GoogleFonts.poppins(
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.green),
                                            )
                                          : Text(
                                              'Menunggu Pembayaran',
                                              style: GoogleFonts.poppins(
                                                  fontWeight: FontWeight.w500,
                                                  color:
                                                      Colors.orange.shade900),
                                            )
                                    ],
                                  ))),
                          SizedBox(
                            height: (snapshot.data!.docs
                                        .elementAt(index)
                                        .data()
                                        .idProduct
                                        .length *
                                    30) +
                                (sizeHeight * 0.03),
                            child: OrderList(
                              orderModel:
                                  snapshot.data?.docs.elementAt(index).data(),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.fromLTRB(0, 0, 0, 10).r,
                            padding: const EdgeInsets.only(left: 50, right: 50),
                            width: sizeWidth * 0.97,
                            decoration: const BoxDecoration(
                                border: Border(
                                    top: BorderSide(color: Colors.black))),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 10.h,
                                ),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 150.w,
                                        child: Text(
                                          'Total Ongkos Kirim',
                                          style: GoogleFonts.poppins(),
                                        ),
                                      ),
                                      Text(
                                          NumberFormat.currency(
                                                  locale: 'id', symbol: 'Rp. ')
                                              .format(snapshot.data!.docs
                                                  .elementAt(index)
                                                  .data()
                                                  .ongkosKirim),
                                          style: GoogleFonts.poppins())
                                    ]),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 150.w,
                                        child: Text(
                                          'Total Tagihan',
                                          style: GoogleFonts.poppins(),
                                        ),
                                      ),
                                      Text(
                                          NumberFormat.currency(
                                                  locale: 'id', symbol: 'Rp. ')
                                              .format(snapshot.data!.docs
                                                  .elementAt(index)
                                                  .data()
                                                  .totalTagihan),
                                          style: GoogleFonts.poppins())
                                    ]),
                              ],
                            ),
                          ),
                          snapshot.data?.docs.elementAt(index).data().isPay ==
                                  false
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    FloatingActionButton.small(
                                      backgroundColor: Colors.transparent,
                                      elevation: 0,
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return CupertinoAlertDialog(
                                              title: const Text(
                                                  'Are You Sure To Cancel Order ?'),
                                              actions: [
                                                MaterialButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                      final data = snapshot
                                                          .data!.docs
                                                          .elementAt(index);
                                                      var id = data.id;
                                                      final listStock =
                                                          data.data().qty;
                                                      final listProduct =
                                                          data.data().idProduct;
                                                      plusStock(listProduct,
                                                          listStock);
                                                      orderRef.doc(id).delete();
                                                      showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return CupertinoAlertDialog(
                                                            title: Text(
                                                              'Order Has Been Cancel',
                                                              style: GoogleFonts
                                                                  .poppins(),
                                                            ),
                                                            content: const Icon(
                                                              CupertinoIcons
                                                                  .xmark_circle,
                                                              size: 70,
                                                            ),
                                                            actions: [
                                                              MaterialButton(
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child:
                                                                    const Text(
                                                                        'OK'),
                                                              )
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    },
                                                    child: const Text('Yes')),
                                                MaterialButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text('No'),
                                                )
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      child: const Icon(
                                        Icons.cancel_outlined,
                                        size: 40,
                                        color: Colors.red,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20.w,
                                    ),
                                    snapshot.data!.docs
                                                .elementAt(index)
                                                .data()
                                                .isPay ==
                                            true
                                        ? SizedBox()
                                        : ActionChip(
                                            padding: const EdgeInsets.fromLTRB(
                                                    10, 10, 10, 10)
                                                .r,
                                            backgroundColor: Colors.blue,
                                            onPressed: () {
                                              Get.to(
                                                  PaymentConfirmation(
                                                      id: snapshot.data!.docs
                                                          .elementAt(index)
                                                          .id,
                                                      totalTagihan: snapshot
                                                          .data!.docs
                                                          .elementAt(index)
                                                          .data()
                                                          .totalTagihan),
                                                  transition: Transition
                                                      .leftToRightWithFade);
                                            },
                                            label: Text(
                                              'Konfirmasi Pembayaran',
                                              style: GoogleFonts.poppins(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500),
                                            )),
                                    SizedBox(
                                      height: 20.h,
                                    )
                                  ],
                                )
                              : const SizedBox(),
                          SizedBox(
                            height: 10.h,
                          ),
                        ],
                      ),
                    );
                  },
                );
              }),
        ));
  }
}

plusStock(List<String> listProduct, List<int> listStock) async {
  final firebase = FirebaseFirestore.instance;
  final product = firebase.collection('product');
  for (int i = 0; i < listProduct.length; i++) {
    var querySnapshot = await product.doc(listProduct[i]).get();
    Map<String, dynamic>? data = querySnapshot.data();
    var currentStock = data!['stock'];
    var stockNew = currentStock + listStock[i];
    listStock[i] = stockNew;
    product.doc(listProduct[i]).update(({'stock': stockNew}));
  }
}
