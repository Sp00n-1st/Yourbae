import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../model/product_model.dart';
import '../view/checkout.dart';
import '../view_model/single_cart.dart';
import '../model/cart_model.dart';

class CartList extends StatelessWidget {
  const CartList({super.key, required this.cartModel, required this.id});
  final CartModel? cartModel;
  final String id;

  @override
  Widget build(BuildContext context) {
    List<Widget> listProduct = <Widget>[];
    List<bool?> available = <bool?>[];
    double sizeWidth = MediaQuery.of(context).size.width;
    double sizeHeight = MediaQuery.of(context).size.height;
    final firebase = FirebaseFirestore.instance;
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
                index: i,
                isShowDelete: true,
              );
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
              margin: const EdgeInsets.fromLTRB(0, 20, 0, 0).r,
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
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 30).r,
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
                        Get.to(Checkout(
                          cartModel: cartModel!,
                          totalAll: totalAll,
                          id: id,
                        ));
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
