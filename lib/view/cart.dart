import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yourbae_project/view_model/cart_list.dart';

import '../model/cart_model.dart';
import '../view_model/single_cart.dart';

class Cart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance.currentUser!;
    final firebase = FirebaseFirestore.instance;
    final cart = firebase
        .collection('cart')
        .doc(auth.uid)
        .withConverter<CartModel>(
            fromFirestore: (snapshot, _) => CartModel.fromJson(snapshot.data()),
            toFirestore: (cartModel, _) => cartModel.toJson());
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Keranjang',
          style: GoogleFonts.poppins(
              color: Colors.black, fontWeight: FontWeight.w600, fontSize: 30),
        ),
      ),
      body: Container(
          margin: EdgeInsets.fromLTRB(28.sp, 0, 28.sp, 0),
          child: StreamBuilder<DocumentSnapshot<CartModel>>(
              stream: cart.snapshots(),
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
                    child: Image.asset('nodata3.gif'),
                  );
                } else if (!snapshot.data!.exists) {
                  return const Align(
                      alignment: Alignment.topCenter,
                      child: Image(
                        image: AssetImage('assets/nodata3.gif'),
                        fit: BoxFit.contain,
                      ));
                }
                return CartList(cartModel: snapshot.data!.data());
              })),
    );
  }
}
