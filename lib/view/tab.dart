import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class MyTabbedPage extends StatefulWidget {
  @override
  _MyTabbedPageState createState() => _MyTabbedPageState();
}

class _MyTabbedPageState extends State<MyTabbedPage>
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
              SizedBox(width: 250.w, child: Image.asset('assets/contoh.png')),
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
                      'Nike Black',
                      style: GoogleFonts.poppins(
                          fontSize: 42, fontWeight: FontWeight.w500),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '1 Pair',
                          style: GoogleFonts.poppins(
                              fontSize: 28,
                              fontWeight: FontWeight.w500,
                              color: Color(0xff575757)),
                        ),
                        SizedBox(
                          height: 45.h,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      side: const BorderSide(
                                          width: 2, color: Color(0xffbcd1d8)),
                                      borderRadius:
                                          BorderRadius.circular(15).r),
                                  backgroundColor: Color(0xff156897)),
                              onPressed: () {},
                              child: Text('Add To Cart')),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Row(
                      children: [
                        Container(
                          // padding: EdgeInsets.fromLTRB(5.r, 0, 5.r, 0),
                          width: 107.w,
                          height: 27.h,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.r),
                              color: Colors.grey),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                    onPressed: () {
                                      print('+');
                                    },
                                    icon: Icon(
                                      CupertinoIcons.minus,
                                      color: Colors.white,
                                      size: 15,
                                    )),
                                Text(
                                  '1',
                                  style: GoogleFonts.exo(
                                      color: Colors.white,
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.w800),
                                ),
                                IconButton(
                                    onPressed: () {
                                      print('+');
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
                        SizedBox(
                          width: 20.w,
                        ),
                        Text(
                          '\$ 100',
                          style: GoogleFonts.exo(
                              fontSize: 22.sp, fontWeight: FontWeight.w500),
                        )
                      ],
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
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Amet faucibus commodo tellus lectus lobortis. Ultricies lacus, facilisis arcu ac mauris, laoreet sit.',
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
