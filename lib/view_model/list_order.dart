import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../model/order_model.dart';
import 'model_list_order.dart';
import 'single_order.dart';

// ignore: must_be_immutable
class OrderList extends StatelessWidget {
  OrderModel? orderModel;
  OrderList({super.key, required this.orderModel});
  List<Widget> listProduct = <Widget>[];
  List<Widget> listOrder = <Widget>[];

  @override
  Widget build(BuildContext context) {
    double sizeWidth = MediaQuery.of(context).size.width;
    double sizeHeight = MediaQuery.of(context).size.height;
    final firebase = FirebaseFirestore.instance;
    num totalAll = 0;
    final product = firebase.collection('product');
    // for (int i = 0; i < orderModel!.idProduct.length; i++) {
    //   listProduct.add(StreamBuilder(
    //       stream: product.doc(orderModel!.idProduct[i]).snapshots(),
    //       builder: (context, snapshot) {
    //         if (snapshot.connectionState == ConnectionState.waiting) {
    //           return CircularProgressIndicator();
    //         } else if (snapshot.hasData) {
    //           return ModelListOrder(
    //             nameProduct: snapshot.data!['nameProduct'],
    //             imageUrl: snapshot.data!['imageUrl'],
    //             qty: orderModel!.qty[i],
    //             subTotal: orderModel!.subTotal[i],
    //             // price: cartModel!.price[i],
    //             // total: cartModel!.total[i],
    //             // discount: cartModel!.discount[i],
    //             orderModel: orderModel,
    //             index: i,
    //           );
    //         }
    //         return CircularProgressIndicator();
    //       }));
    // }

    // for (int i = 0; i < cartModel!.total.length; i++) {
    //   totalAll += cartModel!.total[i];
    // }

    for (int i = 0; i < orderModel!.idProduct.length; i++) {
      listOrder.add(StreamBuilder(
          stream: product.doc(orderModel?.idProduct[i]).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text('Error'),
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return Center();
            }
            return SingleOrder(
                box1: snapshot.data?['nameProduct'],
                box2: orderModel!.size[i].toString(),
                box3: orderModel!.qty[i].toString(),
                box4: orderModel!.subTotal[i].toString(),
                // box5: cartModel!.discount[i].toString(),
                // box6: cartModel!.total[i].toString(),
                totalAll: totalAll);
          }));
    }

    return Scaffold(
        body: Center(
      child: Container(
        width: sizeWidth * 0.97,
        child: Column(
          children: [
            Container(
              height: sizeHeight * 0.03,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    width: sizeWidth * 0.25,
                    child: Center(
                      child: Text(
                        'Nama Produk',
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w700, fontSize: 12),
                      ),
                    ),
                  ),
                  // Container(
                  //   width: sizeWidth * 0.15,
                  //   child: Center(
                  //     child: Text(
                  //       'Harga',
                  //       style: GoogleFonts.poppins(
                  //           fontWeight: FontWeight.w700, fontSize: 12),
                  //     ),
                  //   ),
                  // ),
                  Container(
                    width: sizeWidth * 0.1,
                    child: Center(
                      child: Text(
                        'Size',
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w700, fontSize: 12),
                      ),
                    ),
                  ),
                  Container(
                    width: sizeWidth * 0.1,
                    child: Center(
                      child: Text(
                        'Qty',
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w700, fontSize: 12),
                      ),
                    ),
                  ),
                  Container(
                    width: sizeWidth * 0.30,
                    child: Center(
                      child: Text(
                        'SubTotal',
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w700, fontSize: 12),
                      ),
                    ),
                  ),
                  // Container(
                  //   width: sizeWidth * 0.15,
                  //   child: Center(
                  //     child: Text(
                  //       'Discount',
                  //       style: GoogleFonts.poppins(
                  //           fontWeight: FontWeight.w700, fontSize: 12),
                  //     ),
                  //   ),
                  // ),
                  // Container(
                  //   width: sizeWidth * 0.15,
                  //   child: Center(
                  //     child: Text(
                  //       'Sub Total',
                  //       style: GoogleFonts.poppins(
                  //           fontWeight: FontWeight.w700, fontSize: 12),
                  //     ),
                  //   ),
                  // )
                ],
              ),
            ),
            Column(
              children: listOrder,
            ),
          ],
        ),
      ),
    ));
  }
}
