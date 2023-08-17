import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../model/order_model.dart';
import 'single_order.dart';

class OrderList extends StatelessWidget {
  OrderList({super.key, required this.orderModel});
  final List<Widget> listOrder = <Widget>[];
  final OrderModel? orderModel;

  @override
  Widget build(BuildContext context) {
    double sizeWidth = MediaQuery.of(context).size.width;
    double sizeHeight = MediaQuery.of(context).size.height;
    FirebaseFirestore firebase = FirebaseFirestore.instance;
    num totalAll = 0;
    CollectionReference<Map<String, dynamic>> product =
        firebase.collection('product');

    for (int i = 0; i < orderModel!.idProduct.length; i++) {
      listOrder.add(StreamBuilder(
          stream: product.doc(orderModel?.idProduct[i]).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  snapshot.error.toString(),
                  style: GoogleFonts.poppins(),
                ),
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center();
            } else if (!snapshot.data!.exists) {
              return const SizedBox();
            }
            return SingleOrder(
                box1: snapshot.data?['name_product'],
                box2: orderModel!.size[i].toString(),
                box3: orderModel!.qty[i].toString(),
                box4: orderModel!.subTotal[i].toString(),
                totalAll: totalAll);
          }));
    }

    return Scaffold(
        body: Center(
      child: SizedBox(
        width: sizeWidth * 0.97,
        child: Column(
          children: [
            SizedBox(
              height: sizeHeight * 0.03,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: sizeWidth * 0.25,
                    child: Center(
                      child: Text(
                        'Nama Produk',
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w700, fontSize: 12),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: sizeWidth * 0.1,
                    child: Center(
                      child: Text(
                        'Size',
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w700, fontSize: 12),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: sizeWidth * 0.1,
                    child: Center(
                      child: Text(
                        'Qty',
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w700, fontSize: 12),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: sizeWidth * 0.30,
                    child: Center(
                      child: Text(
                        'SubTotal',
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w700, fontSize: 12),
                      ),
                    ),
                  ),
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
