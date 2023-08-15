import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oktoast/oktoast.dart';
import 'package:yourbae_project/model/cart_model.dart';
import 'package:intl/intl.dart';
import 'package:yourbae_project/view/home.dart';
import 'package:yourbae_project/view_model/kurir.dart';
import '../controller/address_controller.dart';
import '../model/product_model.dart';
import '../view_model/city.dart';
import '../view_model/province.dart';
import '../view_model/radio_button_kurir.dart';
import '../view_model/single_cart.dart';

class Checkout extends StatelessWidget {
  const Checkout(
      {super.key,
      required this.cartModel,
      required this.totalAll,
      required this.id});
  final CartModel cartModel;
  final num totalAll;
  final String id;

  @override
  Widget build(BuildContext context) {
    TextEditingController alamatTextController = TextEditingController();
    List<Widget> listProduct = <Widget>[];
    List<bool?> available = <bool?>[];
    List<bool> isRating = <bool>[];
    int totalQty = 0;
    String alamat = '';
    FirebaseFirestore firebase = FirebaseFirestore.instance;
    AddressController addressController = Get.put(AddressController());
    CollectionReference<Map<String, dynamic>> order =
        firebase.collection('order');
    DocumentReference<Map<String, dynamic>> cart =
        firebase.collection('cart').doc(id);
    RxBool isLoading = false.obs;

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
                () => addressController.hiddenKotaTujuan.isTrue
                    ? const SizedBox()
                    : Column(
                        children: [
                          Kota(
                            provId: addressController.provTujuanId.value,
                          ),
                          Obx(() => addressController.hiddenRadio.isTrue
                              ? const SizedBox()
                              : RadioButtonKurir(
                                  qty: totalQty,
                                ))
                        ],
                      ),
              ),
              Obx(
                () => addressController.hiddenLoading.isFalse
                    ? Container(
                        margin: const EdgeInsets.fromLTRB(0, 20, 0, 0).r,
                        width: 50.w,
                        height: 50.h,
                        child: const CircularProgressIndicator(),
                      )
                    : addressController.hiddenKurir.isTrue ||
                            addressController.kotaTujuanId.value == 0 ||
                            addressController.kurir.value.isEmpty
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
                height: 121.h,
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
                                  ': ${NumberFormat.currency(locale: 'id', symbol: 'Rp. ').format(addressController.cost.value)}',
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
                                ': ${NumberFormat.currency(locale: 'id', symbol: 'Rp. ').format(totalAll + addressController.cost.value)}',
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
                            for (int i = 0;
                                i < cartModel.idProduct.length;
                                i++) {
                              isRating.add(false);
                            }
                            if (alamatTextController.text.isEmpty ||
                                addressController.kotaTujuanId.value == 0 ||
                                addressController.kurir.value.isEmpty ||
                                addressController.cost.value == 0) {
                              showToast(
                                  'Harap Isi Semua Kolom Data Yang Di Perlukan!',
                                  position: const ToastPosition(
                                      align: Alignment.bottomCenter));
                            } else {
                              isLoading.value = true;
                              alamat =
                                  '${alamatTextController.text} ${addressController.namaKotaKab.value} ${addressController.namaProvinsi.value}';

                              await order
                                  .add(({
                                'uid_user': cartModel.uidUser,
                                'id_product': cartModel.idProduct,
                                'size': cartModel.size,
                                'qty': cartModel.qty,
                                'sub_total': cartModel.subTotal,
                                'shipping_cost': addressController.cost.value,
                                'total':
                                    totalAll + addressController.cost.value,
                                'time': cartModel.time,
                                'is_pay': cartModel.isPay,
                                'is_confirm': false,
                                'is_rating': isRating,
                                'address': alamat,
                                'shipping_number': '',
                                'service':
                                    '${addressController.kurir.toUpperCase()} - ${addressController.service}',
                                'proof_of_payment': '',
                                'time_stamp': DateTime.now()
                              }))
                                  .then((value) async {
                                minusStock(cartModel.idProduct, cartModel.qty,
                                    cartModel.size);
                                await cart.delete();
                                isLoading.value = false;
                                Get.offAll(const Home());
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
                                          'Segera Lakukan Pembayaran Sebelum Pesanan Dibatalkan Oleh Admin',
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
            ],
          ),
        ),
      ),
    );
  }
}

minusStock(List<String> listProduct, List<int> qty, List<int> size) async {
  final firebase = FirebaseFirestore.instance;
  final product = firebase.collection('product');
  for (int i = 0; i < listProduct.length; i++) {
    var querySnapshot = await product.doc(listProduct[i]).get();
    Map<String, dynamic>? data = querySnapshot.data();
    var currentStock = data!['size${size[i]}'];
    var stockNew = currentStock - qty[i];
    qty[i] = stockNew;
    product.doc(listProduct[i]).update(({'size${size[i]}': stockNew}));
  }
}
