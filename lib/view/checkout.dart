import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oktoast/oktoast.dart';
import 'package:yourbae_project/controller/controller.dart';
import 'package:yourbae_project/model/cart_model.dart';
import 'package:intl/intl.dart';
import 'package:yourbae_project/view/home.dart';
import 'package:yourbae_project/view/main_view.dart';
import 'package:yourbae_project/view_model/kurir.dart';
import '../controller/alamat_controller.dart';
import '../model/product_model.dart';
import '../view_model/city.dart';
import '../view_model/province.dart';
import '../view_model/radio_button_kurir.dart';
import '../view_model/single_cart.dart';

class Checkout extends StatelessWidget {
  Checkout({super.key, required this.cartModel, required this.totalAll});
  CartModel cartModel;
  num totalAll;

  @override
  Widget build(BuildContext context) {
    TextEditingController alamatTextController = TextEditingController();
    List<Widget> listProduct = <Widget>[];
    List<bool?> available = <bool?>[];
    int totalQty = 0;
    String alamat = '';
    final firebase = FirebaseFirestore.instance;
    var alamatController = Get.put(AlamatController());
    var controller = Get.put(Controller());
    var order = firebase.collection('order');
    var isLoading = false.obs;

    for (int i = 0; i < cartModel.idProduct.length; i++) {
      final product = firebase
          .collection('product')
          .doc(cartModel.idProduct[i])
          .withConverter<Product>(
              fromFirestore: (snapshot, _) => Product.fromJson(snapshot.data()),
              toFirestore: (product, _) => product.toJson());
      listProduct.add(StreamBuilder(
          stream: product.snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasData) {
              return SingleCart(
                product: snapshot.data!.data()!,
                cartModel: cartModel,
                index: i,
                isShowDelete: false,
              );
            }
            return const CircularProgressIndicator();
          }));
    }

    for (int i = 0; i < cartModel.idProduct.length; i++) {
      available.add(null);
    }
    for (int i = 0; i < cartModel.idProduct.length; i++) {
      totalQty += cartModel.qty[i];
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(CupertinoIcons.back),
          color: Colors.black,
        ),
        title: const Text(
          'Checkout',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0).r,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 5.h,
              ),
              TextField(
                controller: alamatTextController,
                decoration: const InputDecoration(
                    label: Text('Alamat'), border: OutlineInputBorder()),
              ),
              const SizedBox(
                height: 20,
              ),
              const Provinsi(),
              Obx(
                () => alamatController.hiddenKotaTujuan.isTrue
                    ? const SizedBox()
                    : Column(
                        children: [
                          Kota(
                            provId: alamatController.provTujuanId.value,
                          ),
                          Obx(() => alamatController.hiddenRadio.isTrue
                              ? const SizedBox()
                              : RadioButtonKurir(
                                  qty: totalQty,
                                ))
                        ],
                      ),
              ),
              Obx(
                () => alamatController.hiddenLoading.isFalse
                    ? Container(
                        margin: const EdgeInsets.fromLTRB(0, 20, 0, 0).r,
                        width: 50.w,
                        height: 50.h,
                        child: const CircularProgressIndicator(),
                      )
                    : alamatController.hiddenKurir.isTrue ||
                            alamatController.kotaTujuanId.value == 0 ||
                            alamatController.kurir.value.isEmpty
                        ? const SizedBox()
                        : const Kurir(),
              ),
              SizedBox(
                height: 20.h,
              ),
              Column(
                children: listProduct,
              ),
              Container(
                padding: const EdgeInsets.all(20).r,
                width: double.infinity,
                height: 115.h,
                color: Colors.grey.shade200,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                                width: 150.w,
                                child: Text('Total Diskon',
                                    style: GoogleFonts.poppins())),
                            Text(': 3', style: GoogleFonts.poppins()),
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(
                                width: 150.w,
                                child: Text(
                                    'Total Harga (${cartModel.idProduct.length} Item)',
                                    style: GoogleFonts.poppins())),
                            Text(
                                ': ${NumberFormat.currency(locale: 'id', symbol: 'Rp. ').format(totalAll)}',
                                style: GoogleFonts.poppins()),
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(
                                width: 150.w,
                                child: Text(
                                  'Ongkos Kirim',
                                  style: GoogleFonts.poppins(),
                                )),
                            Obx(
                              () => Text(
                                  ': ${NumberFormat.currency(locale: 'id', symbol: 'Rp. ').format(alamatController.cost.value)}',
                                  style: GoogleFonts.poppins()),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(
                                width: 150.w,
                                child: Text(
                                  'Total Tagihan',
                                  style: GoogleFonts.poppins(),
                                )),
                            Obx(() => Text(
                                ': ${NumberFormat.currency(locale: 'id', symbol: 'Rp. ').format(totalAll + alamatController.cost.value)}',
                                style: GoogleFonts.poppins())),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Obx(
                () => isLoading.isTrue
                    ? Container(
                        margin: const EdgeInsets.fromLTRB(0, 20, 0, 20).r,
                        width: 50.w,
                        height: 50.h,
                        child: const CircularProgressIndicator(),
                      )
                    : Container(
                        margin: const EdgeInsets.fromLTRB(0, 20, 0, 0).r,
                        width: double.infinity,
                        height: 50.h,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (alamatTextController.text.isEmpty ||
                                alamatController.kotaTujuanId.value == 0 ||
                                alamatController.kurir.value.isEmpty ||
                                alamatController.cost.value == 0) {
                              showToast(
                                  'Harap Isi Semua Kolom Data Yang Di Perlukan!',
                                  position: const ToastPosition(
                                      align: Alignment.bottomCenter));
                            } else {
                              isLoading.value = true;
                              alamat =
                                  '${alamatTextController.text} ${alamatController.namaKotaKab.value} ${alamatController.namaProvinsi.value}';

                              await order
                                  .add(({
                                'uidUser': cartModel.uidUser,
                                'idProduct': cartModel.idProduct,
                                'size': cartModel.size,
                                'qty': cartModel.qty,
                                'subTotal': cartModel.subTotal,
                                'ongkosKirim': alamatController.cost.value,
                                'totalTagihan':
                                    totalAll + alamatController.cost.value,
                                'time': cartModel.time,
                                'isPay': cartModel.isPay,
                                'alamat': alamat,
                                'buktiBayar': '',
                                'timeStamp': DateTime.now()
                              }))
                                  .then((value) {
                                isLoading.value = false;
                                Get.offAll(Home());
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return CupertinoAlertDialog(
                                      title: Text(
                                        'Pesanan Berhasil Dibuat',
                                        style: GoogleFonts.poppins(
                                            color: Colors.black),
                                      ),
                                      content: Column(children: [
                                        Image.asset('assets/success7.gif'),
                                        Text(
                                          'Segera Lakukan Pembayaran Sebelum 24 Jam Sebelum Pesanan Otomatis Batal',
                                          style: GoogleFonts.poppins(
                                              color: Colors.black),
                                          textAlign: TextAlign.justify,
                                        )
                                      ]),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                              'OK',
                                              style: GoogleFonts.poppins(
                                                  color: Colors.black),
                                            ))
                                      ],
                                    );
                                  },
                                );
                                // Future.delayed(
                                //   Duration(seconds: 2),
                                //   () {
                                //     Get.offAll(Home());
                                //   },
                                // );
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15).r)),
                          child: Text('Buat Pesanan',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w500)),
                        ),
                      ),
              ),
              SizedBox(
                height: 10.h,
              )

              // Obx(
              //   () => SizedBox(
              //     width: double.infinity,
              //     child: ElevatedButton(
              //       onPressed: alamatController.hiddenButton.isTrue
              //           ? null
              //           : () {
              //               alamatController.ongkosKirim();
              //               // print(alamatController.kotaTujuanId);
              //               // print(alamatController.provTujuanId);
              //             },
              //       child: Text("SAVE"),
              //       style: ElevatedButton.styleFrom(
              //         padding: EdgeInsets.symmetric(vertical: 20),
              //         backgroundColor: Colors.blue[900],
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
