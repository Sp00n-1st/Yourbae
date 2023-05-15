import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:yourbae_project/model/product_model.dart';
import 'package:yourbae_project/view_model/single_cart.dart';
import 'package:yourbae_project/view_model/single_product.dart';
import '../model/cart.dart';

// ignore: must_be_immutable
class CartList extends StatelessWidget {
  CartModel? cartModel;
  CartList({required this.cartModel});
  List<Widget> listProduct = <Widget>[];
  List<bool?> available = <bool?>[];
  @override
  Widget build(BuildContext context) {
    double sizeWidth = MediaQuery.of(context).size.width;
    double sizeHeight = MediaQuery.of(context).size.height;
    final firebase = FirebaseFirestore.instance;
    final order = firebase.collection('order');
    final cart = firebase.collection('cart');
    num totalAll = 0;

    for (int i = 0; i < cartModel!.idProduct.length; i++) {
      final product = firebase
          .collection('product')
          .doc(cartModel!.idProduct[i])
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
                  cartModel: cartModel!,
                  index: i);
            }
            return const CircularProgressIndicator();
          }));
    }

    for (int i = 0; i < cartModel!.idProduct.length; i++) {
      available.add(null);
    }
    for (int i = 0; i < cartModel!.idProduct.length; i++) {
      totalAll += cartModel!.subTotal[i];
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: Center(
        child: Stack(
          children: [
            Container(
              color: Colors.grey.shade200,
              margin: EdgeInsets.fromLTRB(0, 20, 0, 0).r,
              width: sizeWidth,
              height: 430.h,
              child: SingleChildScrollView(
                child: Column(
                  children: listProduct,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: EdgeInsets.fromLTRB(0, 0, 0, 30).r,
                width: sizeWidth,
                height: sizeHeight * 0.099,
                color: Colors.grey.shade200,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total : ${NumberFormat.currency(locale: 'id', symbol: 'Rp. ').format(totalAll)}',
                      style: GoogleFonts.poppins(),
                    ),
                    FloatingActionButton.large(
                      backgroundColor: Colors.green,
                      onPressed: () async {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return CupertinoAlertDialog(
                              title: const Text('Are You Sure To Checkout ?'),
                              actions: [
                                MaterialButton(
                                  onPressed: () async {
                                    print(available);
                                    final now = DateTime.now();
                                    final date = DateFormat('yyyyMMddHHmmss')
                                        .format(now);
                                    await order.add(({
                                      'uid_user': cartModel!.uidUser,
                                      'time': int.tryParse(date),
                                      'id_product': cartModel!.idProduct,
                                      'qty': cartModel!.qty,
                                      'subTotal': cartModel!.subTotal,
                                      'isTake': false,
                                      'isReady': false,
                                      'date': DateTime.now(),
                                      'available': available
                                    }));
                                    minusStock(
                                        cartModel!.idProduct, cartModel!.qty);
                                    cart.doc(cartModel!.uidUser).delete();
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Yes'),
                                ),
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
                        Icons.shopping_basket_outlined,
                        size: 35,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

minusStock(List<String> listProduct, List<int> listStock) async {
  final firebase = FirebaseFirestore.instance;
  final product = firebase.collection('product');
  for (int i = 0; i < listProduct.length; i++) {
    var querySnapshot = await product.doc(listProduct[i]).get();
    Map<String, dynamic>? data = querySnapshot.data();
    var currentStock = data!['stock'];
    var stockNew = currentStock - listStock[i];
    listStock[i] = stockNew;
    product.doc(listProduct[i]).update(({'stock': stockNew}));
  }
}
