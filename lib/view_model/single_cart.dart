import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oktoast/oktoast.dart';
import 'package:intl/intl.dart';
import '../model/cart_model.dart';
import '../model/product_model.dart';

class SingleCart extends StatelessWidget {
  const SingleCart(
      {Key? key,
      required this.product,
      required this.cartModel,
      required this.index,
      required this.isShowDelete})
      : super(key: key);
  final Product product;
  final CartModel cartModel;
  final int index;
  final bool isShowDelete;

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firebase = FirebaseFirestore.instance;
    DocumentReference<Map<String, dynamic>> cart =
        firebase.collection('cart').doc(cartModel.uidUser);

    return Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 20).r,
      width: 315.w,
      height: 130.h,
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          color: const Color(0xffd9d9d9)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
              height: 70.h,
              width: 100.w,
              child: Image.network(product.imageUrl.elementAt(0))),
          SizedBox(
            width: 15.w,
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10).r,
            width: 125.w,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.nameProduct,
                  maxLines: 2,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500, fontSize: 16.sp),
                ),
                Text(
                  NumberFormat.currency(locale: 'id', symbol: 'Rp. ')
                      .format(cartModel.subTotal[index]),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.exo(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: const Color(0xff575757)),
                ),
                SizedBox(
                  height: 10.h,
                ),
                isShowDelete == true
                    ? Center(
                        child: SizedBox(
                          width: 60.w,
                          height: 30.h,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  shape: const StadiumBorder()),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return CupertinoAlertDialog(
                                      title: Text(
                                        'Hapus Item ?',
                                        style: GoogleFonts.poppins(),
                                      ),
                                      content: Column(
                                        children: [
                                          const Icon(
                                            CupertinoIcons.delete,
                                            size: 70,
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            'Apa Anda Yakin Ingin Menghapus ${product.nameProduct} Dari Keranjang ?',
                                            style: GoogleFonts.poppins(),
                                          )
                                        ],
                                      ),
                                      actions: [
                                        MaterialButton(
                                          onPressed: () {
                                            cartModel.idProduct.removeAt(index);
                                            cartModel.subTotal.removeAt(index);
                                            cartModel.qty.removeAt(index);
                                            cartModel.size.removeAt(index);
                                            cart.update(({
                                              'id_product': cartModel.idProduct,
                                              'qty': cartModel.qty,
                                              'sub_total': cartModel.subTotal,
                                              'size': cartModel.size
                                            }));
                                            showToast('Item Berhasil Di Hapus',
                                                position: const ToastPosition(
                                                    align: Alignment
                                                        .bottomCenter));
                                            Navigator.pop(context);
                                          },
                                          child: const Text('Ya'),
                                        ),
                                        MaterialButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text('Tidak'),
                                        )
                                      ],
                                    );
                                  },
                                );
                              },
                              child: const Icon(Icons.delete)),
                        ),
                      )
                    : const SizedBox()
              ],
            ),
          ),
          SizedBox(
            width: 5.w,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Qty',
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500, fontSize: 12)),
              Text(
                cartModel.qty[index].toString(),
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500, fontSize: 18),
              ),
              Text('Size',
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500, fontSize: 12)),
              Text(
                cartModel.size[index].toString(),
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500, fontSize: 18),
              ),
            ],
          )
        ],
      ),
    );
  }
}
