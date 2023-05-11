import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yourbae_project/controller/controller.dart';
import 'package:yourbae_project/model/product_model.dart';
import 'package:intl/intl.dart';

class ProductDetail extends StatefulWidget {
  @override
  _ProductDetailState createState() => _ProductDetailState();
  ProductDetail({super.key, required this.product});
  Product product;
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
    var controller = Get.put(Controller());
    controller.selectedSize.value = 0;
    var qty = 0.obs;
    var stok = 0.obs;
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        backgroundColor: Colors.grey,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
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
                padding: EdgeInsets.fromLTRB(20, 30, 20, 0),
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
                      style: GoogleFonts.poppins(
                          fontSize: 42, fontWeight: FontWeight.w500),
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
                                    fontSize: 28,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xff575757)),
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
                                              if (qty.value == 0) {
                                              } else {
                                                qty.value--;
                                              }
                                            },
                                            icon: Icon(
                                              CupertinoIcons.minus,
                                              color: Colors.white,
                                              size: 15,
                                            )),
                                        Obx(
                                          () => Text(
                                            qty.value.toString(),
                                            style: GoogleFonts.exo(
                                                color: Colors.white,
                                                fontSize: 20.sp,
                                                fontWeight: FontWeight.w800),
                                          ),
                                        ),
                                        IconButton(
                                            onPressed: () {
                                              if (stok.value == qty.value) {
                                              } else {
                                                qty.value++;
                                              }
                                            },
                                            icon: Icon(
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
                            Text(
                              NumberFormat.currency(
                                      locale: 'id', symbol: 'Rp. ')
                                  .format(widget.product.price),
                              style: GoogleFonts.exo(
                                  fontSize: 22.sp, fontWeight: FontWeight.w500),
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
                                      backgroundColor: Color(0xff156897)),
                                  onPressed: () {},
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
                                      backgroundColor: Color(0xff156897)),
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
