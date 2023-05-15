import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oktoast/oktoast.dart';
import 'package:yourbae_project/controller/controller.dart';
import 'package:yourbae_project/model/product_model.dart';
import 'package:intl/intl.dart';
import 'package:yourbae_project/view/home.dart';

import '../model/cart.dart';

class ProductDetail extends StatefulWidget {
  @override
  _ProductDetailState createState() => _ProductDetailState();
  ProductDetail({super.key, required this.product, required this.id});
  Product product;
  String id;
}

class _ProductDetailState extends State<ProductDetail>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance.currentUser!.uid;
    var controller = Get.put(Controller());
    var qty = 1.obs;
    var stok = 0.obs;
    var subTotal = (qty.value * widget.product.price).obs;
    controller.selectedSize.value = 0;
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        backgroundColor: Colors.grey,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            CupertinoIcons.back,
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 20.h,
          ),
          Center(
              child: Column(
            children: [
              SizedBox(
                  width: 100.w,
                  height: 100.h,
                  child: Image.network(
                    widget.product.imageUrl,
                    fit: BoxFit.fill,
                  )),
              SizedBox(
                height: 80.h,
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(30.r))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.product.nameProduct,
                      maxLines: 2,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                          fontSize: 24, fontWeight: FontWeight.w500),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Obx(
                              () => Text(
                                '$qty Pair',
                                style: GoogleFonts.poppins(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xff575757)),
                              ),
                            ),
                            Row(
                              children: [
                                Container(
                                  // padding: EdgeInsets.fromLTRB(5.r, 0, 5.r, 0),

                                  height: 27.h,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15.r),
                                      color: Colors.grey),
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        IconButton(
                                            onPressed: () {
                                              if (qty.value == 1) {
                                              } else {
                                                qty.value--;
                                                subTotal.value = qty.value *
                                                    widget.product.price;
                                              }
                                            },
                                            icon: const Icon(
                                              CupertinoIcons.minus,
                                              color: Colors.white,
                                              size: 15,
                                            )),
                                        Obx(
                                          () => Text(
                                            qty.value.toString(),
                                            style: GoogleFonts.exo(
                                                color: Colors.white,
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.w800),
                                          ),
                                        ),
                                        IconButton(
                                            onPressed: () {
                                              if (stok.value == qty.value) {
                                              } else {
                                                qty.value++;
                                                subTotal.value = qty.value *
                                                    widget.product.price;
                                              }
                                            },
                                            icon: const Icon(
                                              CupertinoIcons.plus,
                                              color: Colors.white,
                                              size: 15,
                                            )),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            Obx(
                              () => Text(
                                NumberFormat.currency(
                                        locale: 'id', symbol: 'Rp. ')
                                    .format(qty.value * widget.product.price),
                                style: GoogleFonts.exo(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            SizedBox(
                              height: 45.h,
                              width: 110.w,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          side: const BorderSide(
                                              width: 2,
                                              color: Color(0xffbcd1d8)),
                                          borderRadius:
                                              BorderRadius.circular(15).r),
                                      backgroundColor: const Color(0xff156897)),
                                  onPressed: () async {
                                    if (controller.selectedSize.value == 0) {
                                      showToast(
                                          'Pilih Size Sebelum Menambahkan Item Ke Keranjang',
                                          textStyle: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w500),
                                          position: const ToastPosition(
                                              align: Alignment.bottomCenter));
                                    } else {
                                      await FirebaseFirestore.instance
                                          .collection('cart')
                                          .doc(auth)
                                          .withConverter<CartModel>(
                                              fromFirestore: (snapshot, _) =>
                                                  CartModel.fromJson(
                                                      snapshot.data()),
                                              toFirestore: (cartModel, _) =>
                                                  cartModel.toJson())
                                          .get()
                                          .then((DocumentSnapshot<CartModel>
                                              documentSnapshot) {
                                        if (documentSnapshot.exists) {
                                          return add(
                                              documentSnapshot.data(),
                                              subTotal.value,
                                              qty.value,
                                              controller.selectedSize.value,
                                              widget.id,
                                              auth,
                                              context);
                                        } else {
                                          return addFirst(
                                              subTotal.value,
                                              qty.value,
                                              widget.id,
                                              controller.selectedSize.value,
                                              auth,
                                              context);
                                        }
                                      });
                                    }
                                  },
                                  child: Text(
                                    '+ Keranjang',
                                    style: GoogleFonts.poppins(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w600),
                                  )),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            SizedBox(
                              height: 45.h,
                              width: 110.w,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          side: const BorderSide(
                                              width: 2,
                                              color: Color(0xffbcd1d8)),
                                          borderRadius:
                                              BorderRadius.circular(15).r),
                                      backgroundColor: const Color(0xff156897)),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return CupertinoAlertDialog(
                                          title: Text(
                                            'Pilih Size',
                                            style: GoogleFonts.poppins(),
                                          ),
                                          content: Column(
                                            children: [
                                              Obx(
                                                () => Text(
                                                  'Stok : $stok',
                                                  style: GoogleFonts.poppins(),
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  TabSize(
                                                    onPressed: () {
                                                      controller.selectedSize
                                                          .value = 37;
                                                      stok.value = widget
                                                          .product.size37
                                                          .toInt();
                                                    },
                                                    size: 37,
                                                    stok: widget.product.size37
                                                        .toInt(),
                                                  ),
                                                  TabSize(
                                                    onPressed: () {
                                                      controller.selectedSize
                                                          .value = 38;
                                                      stok.value = widget
                                                          .product.size38
                                                          .toInt();
                                                    },
                                                    size: 38,
                                                    stok: widget.product.size38
                                                        .toInt(),
                                                  ),
                                                  TabSize(
                                                    onPressed: () {
                                                      controller.selectedSize
                                                          .value = 39;
                                                      stok.value = widget
                                                          .product.size39
                                                          .toInt();
                                                    },
                                                    size: 39,
                                                    stok: widget.product.size39
                                                        .toInt(),
                                                  )
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  TabSize(
                                                    onPressed: () {
                                                      controller.selectedSize
                                                          .value = 40;
                                                      stok.value = widget
                                                          .product.size40
                                                          .toInt();
                                                    },
                                                    size: 40,
                                                    stok: widget.product.size40
                                                        .toInt(),
                                                  ),
                                                  TabSize(
                                                    onPressed: () {
                                                      controller.selectedSize
                                                          .value = 41;
                                                      stok.value = widget
                                                          .product.size41
                                                          .toInt();
                                                    },
                                                    size: 41,
                                                    stok: widget.product.size41
                                                        .toInt(),
                                                  ),
                                                  TabSize(
                                                    onPressed: () {
                                                      controller.selectedSize
                                                          .value = 42;
                                                      stok.value = widget
                                                          .product.size42
                                                          .toInt();
                                                    },
                                                    size: 42,
                                                    stok: widget.product.size42
                                                        .toInt(),
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                          actions: [
                                            TextButton(
                                                onPressed: () {
                                                  qty.value = 1;
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
                                  },
                                  child: Obx(
                                    () => Text(
                                        controller.selectedSize.value == 0
                                            ? 'Pilih Size'
                                            : controller.selectedSize.value
                                                .toString(),
                                        style: GoogleFonts.poppins(
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w600)),
                                  )),
                            )
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Container(
                      color: Colors.white,
                      child: TabBar(
                        controller: _tabController,
                        tabs: [
                          Tab(
                            child: Text(
                              'Product Description',
                              style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black),
                            ),
                          ),
                          Tab(
                            child: Text(
                              'Rating',
                              style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          )),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(20.r, 0, 20.r, 0),
                  width: double.infinity,
                  color: Colors.white,
                  child: Text(
                    widget.product.descItem,
                    style: GoogleFonts.poppins(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.black),
                  ),
                ),
                SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(20.r, 0, 20.r, 0),
                    width: double.infinity,
                    color: Colors.white,
                    child: Text(
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Amet faucibus commodo tellus lectus lobortis. Ultricies lacus, facilisis arcu ac mauris, laoreet sit.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Amet faucibus commodo tellus lectus lobortis. Ultricies lacus, facilisis arcu ac mauris, laoreet sit.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Amet faucibus commodo tellus lectus lobortis. Ultricies lacus, facilisis arcu ac mauris, laoreet sit.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Amet faucibus commodo tellus lectus lobortis. Ultricies lacus, facilisis arcu ac mauris, laoreet sit.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Amet faucibus commodo tellus lectus lobortis. Ultricies lacus, facilisis arcu ac mauris, laoreet sit.',
                      style: GoogleFonts.poppins(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TabSize extends StatelessWidget {
  TabSize(
      {Key? key,
      required this.onPressed,
      required this.size,
      required this.stok})
      : super(key: key);

  int stok, size;
  VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    var controller = Get.put(Controller());
    return Material(
        color: Colors.transparent,
        child: Obx(
          () => ActionChip(
              backgroundColor: controller.selectedSize.value == size
                  ? Colors.blue
                  : Colors.green,
              onPressed: stok == 0 ? null : onPressed,
              label: Text(
                size.toString(),
                style: GoogleFonts.poppins(color: Colors.white),
              )),
        ));
  }
}

add(CartModel? cartModel, num subTotal, int qty, int size, String idProduct,
    String auth, BuildContext context) async {
  String uidUser = cartModel!.uidUser;
  String timeStorage = cartModel.time;
  List<String> idProductStorage = cartModel.idProduct;
  List<int> qtyStorage = cartModel.qty;
  List<int> sizeStorage = cartModel.size;
  List<num> subTotalStorage = cartModel.subTotal;
  bool isCheckout = cartModel.isCheckout;
  bool isPay = cartModel.isPay;
  if (sizeStorage.contains(size)) {
    showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text('Item Sudah Ada Dikeranjang!'),
          content: Column(
            children: [
              const Icon(
                CupertinoIcons.xmark_circle,
                size: 70,
                color: Colors.red,
              ),
              const Text(
                  'Item Tidak Bisa Ditambahkan Ke Keranjang Karena Sudah Ada Di Keranjang'),
            ],
          ),
          actions: [
            MaterialButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            )
          ],
        );
      },
    );
  } else {
    idProductStorage.add(idProduct);
    qtyStorage.add(qty);
    subTotalStorage.add(subTotal);
    sizeStorage.add(size);

    await addToStorage(uidUser, timeStorage, idProductStorage, qtyStorage,
        sizeStorage, subTotalStorage, isCheckout, isPay, auth);
    showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text('Item Sudah Ditambahkan Ke Keranjang'),
          content: const Icon(
            CupertinoIcons.cart_badge_plus,
            size: 70,
          ),
          actions: [
            MaterialButton(
              onPressed: () {
                Get.offAll(Home());
              },
              child: const Text('OK'),
            )
          ],
        );
      },
    );
  }
}

addFirst(num subTotal, num qty, String idProduct, int size, String auth,
    BuildContext context) async {
  List<String> idProductStorage = <String>[idProduct];
  List<num> qtyStorage = <num>[qty];
  List<num> subTotalStorage = <num>[subTotal];
  List<int> sizeStorage = <int>[size];
  final now = DateTime.now();
  final date = DateFormat('yyyyMMddHHmmss').format(now);

  await FirebaseFirestore.instance.collection('cart').doc(auth).set(({
        'uidUser': auth,
        'time': date,
        'idProduct': idProductStorage,
        'qty': qtyStorage,
        'size': sizeStorage,
        'subTotal': subTotalStorage,
        'isCheckout': false,
        'isPay': false
      }));
  showDialog(
    context: context,
    builder: (context) {
      return CupertinoAlertDialog(
        title: const Text('Item Sudah Ditambahkan Ke Keranjang'),
        content: const Icon(
          CupertinoIcons.cart_badge_plus,
          size: 70,
        ),
        actions: [
          MaterialButton(
            onPressed: () {
              Get.offAll(Home());
            },
            child: const Text('OK'),
          )
        ],
      );
    },
  );
}

addToStorage(
    String uidUser,
    String timeStorage,
    List<String> idProductStorage,
    List<int> qtyStorage,
    List<int> sizeStorage,
    List<num> subTotalStorage,
    bool isCheckout,
    bool isPay,
    String auth) async {
  await FirebaseFirestore.instance.collection('cart').doc(auth).set(({
        'uidUser': uidUser,
        'time': timeStorage,
        'idProduct': idProductStorage,
        'qty': qtyStorage,
        'size': sizeStorage,
        'subTotal': subTotalStorage,
        'isCheckout': isCheckout,
        'isPay': isPay,
      }));
}
