import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:oktoast/oktoast.dart';
import '../view/payment_confirmation.dart';
import '../view_model/modal_rating.dart';
import '../model/order_model.dart';
import '../view_model/list_order.dart';

class OrderPage extends StatelessWidget {
  const OrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    double sizeWidth = MediaQuery.of(context).size.width;
    double sizeHeight = MediaQuery.of(context).size.height;
    final firebase = FirebaseFirestore.instance;
    final auth = FirebaseAuth.instance.currentUser!.uid;
    final orderRef = firebase.collection('order');
    final order = firebase
        .collection('order')
        .where('uid_user', isEqualTo: auth)
        .withConverter<OrderModel>(
            fromFirestore: (snapshot, _) =>
                OrderModel.fromJson(snapshot.data()),
            toFirestore: (orderModel, _) => orderModel.toJson());
    return Scaffold(
        backgroundColor: Colors.grey.shade200,
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
                          child: Image.asset('assets/nodata3.gif')));
                }
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.size,
                  itemBuilder: (context, index) {
                    OrderModel orderModel = snapshot.data!.docs[index].data();
                    String dateTime = DateFormat('dd/MM/yyyy')
                        .format(orderModel.timeStamp.toDate());
                    return Container(
                      margin:
                          const EdgeInsets.only(right: 5, left: 5, bottom: 35)
                              .r,
                      decoration: BoxDecoration(
                          color: Colors.grey[300],
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: const [
                            BoxShadow(
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
                                      orderModel.isPay == true
                                          ? Text(
                                              orderModel.isConfirm != true
                                                  ? 'Menunggu Konfirmasi Admin'
                                                  : 'Sedang Di Kirim',
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
                            height: (orderModel.idProduct.length * 90.h) +
                                (sizeHeight * 0.03),
                            child: OrderList(
                              orderModel: orderModel,
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
                                      SizedBox(
                                        width: 150.w,
                                        child: Text(
                                          'Total Ongkos Kirim',
                                          style: GoogleFonts.poppins(),
                                        ),
                                      ),
                                      Text(
                                          NumberFormat.currency(
                                                  locale: 'id', symbol: 'Rp. ')
                                              .format(orderModel.ongkosKirim),
                                          style: GoogleFonts.poppins())
                                    ]),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 150.w,
                                        child: Text(
                                          'Total Tagihan',
                                          style: GoogleFonts.poppins(),
                                        ),
                                      ),
                                      Text(
                                          NumberFormat.currency(
                                                  locale: 'id', symbol: 'Rp. ')
                                              .format(orderModel.totalTagihan),
                                          style: GoogleFonts.poppins())
                                    ]),
                              ],
                            ),
                          ),
                          orderModel.isPay == false
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
                                              title: Text(
                                                'Batalkan Pesanan ?',
                                                maxLines: 1,
                                                style: GoogleFonts.poppins(),
                                              ),
                                              content: Icon(
                                                CupertinoIcons.xmark_circle,
                                                color: Colors.red,
                                                size: 50.r,
                                              ),
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
                                                      final listSize =
                                                          data.data().size;
                                                      plusStock(listProduct,
                                                          listStock, listSize);
                                                      orderRef.doc(id).delete();
                                                      showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return CupertinoAlertDialog(
                                                            title: Text(
                                                              'Pesanan Telah Dibatalkan',
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
                                                                child: Text(
                                                                    'OK',
                                                                    style: GoogleFonts
                                                                        .poppins(
                                                                            color:
                                                                                Colors.black)),
                                                              )
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    },
                                                    child: Text(
                                                      'Ya',
                                                      style:
                                                          GoogleFonts.poppins(
                                                              color:
                                                                  Colors.black),
                                                    )),
                                                MaterialButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text('Tidak',
                                                      style:
                                                          GoogleFonts.poppins(
                                                              color: Colors
                                                                  .black)),
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
                                    orderModel.isPay == true
                                        ? const SizedBox()
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
                                                      totalTagihan: orderModel
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
                          orderModel.isConfirm == false
                              ? const SizedBox()
                              : Row(
                                  mainAxisAlignment:
                                      !orderModel.isRating.contains(false)
                                          ? MainAxisAlignment.center
                                          : MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ActionChip(
                                        backgroundColor: Colors.green,
                                        onPressed: () async {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return CupertinoAlertDialog(
                                                title: Text(
                                                  'Nomor Resi',
                                                  style: GoogleFonts.poppins(),
                                                ),
                                                content: Container(
                                                  width: double.infinity,
                                                  height: 45.h,
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                              10, 5, 10, 5)
                                                          .r,
                                                  decoration: BoxDecoration(
                                                      color: const Color(
                                                          0xffC9EEFF),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5)),
                                                  child: Center(
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                            orderModel
                                                                .nomorResi,
                                                            style: GoogleFonts.poppins(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 14.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600)),
                                                        Material(
                                                          color: Colors
                                                              .transparent,
                                                          child: IconButton(
                                                              onPressed: () {
                                                                showToast(
                                                                    'Berhasil Di Salin',
                                                                    textStyle:
                                                                        GoogleFonts
                                                                            .poppins(),
                                                                    position: const ToastPosition(
                                                                        align: Alignment
                                                                            .bottomCenter));

                                                                Clipboard.setData(ClipboardData(
                                                                    text: orderModel
                                                                        .nomorResi
                                                                        .toString()));
                                                              },
                                                              icon: const Icon(
                                                                  Icons.copy)),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        },
                                        label: Text(
                                          'Cek Resi',
                                          style: GoogleFonts.poppins(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500),
                                        )),
                                    orderModel.isRating.contains(false)
                                        ? ActionChip(
                                            backgroundColor: Colors.blue,
                                            onPressed: () {
                                              ModalRating().showModal(
                                                  context,
                                                  orderModel,
                                                  snapshot.data!.docs
                                                      .elementAt(index)
                                                      .id);
                                            },
                                            label: Text(
                                              'Beri Rating',
                                              style: GoogleFonts.poppins(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500),
                                            ))
                                        : const SizedBox()
                                  ],
                                ),
                          SizedBox(
                            height: 20.h,
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

plusStock(List<String> listProduct, List<int> listStock, List<int> size) async {
  final firebase = FirebaseFirestore.instance;
  final product = firebase.collection('product');
  for (int i = 0; i < listProduct.length; i++) {
    var querySnapshot = await product.doc(listProduct[i]).get();
    Map<String, dynamic>? data = querySnapshot.data();
    var currentStock = data!['size${size[i]}'];
    var stockNew = currentStock + listStock[i];
    listStock[i] = stockNew;
    product.doc(listProduct[i]).update(({'size${size[i]}': stockNew}));
  }
}
