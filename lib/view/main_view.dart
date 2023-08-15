import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controller/controller.dart';
import '../controller/firebase_controller.dart';
import '../model/user_model.dart';
import '../view_model/tab_button.dart';
import '../view_model/single_product.dart';

class MainView extends StatelessWidget {
  const MainView({super.key, required this.userModel});
  final UserModel? userModel;

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(Controller());
    var firebaseController = Get.put(FirebaseController());

    return Scaffold(
      appBar: AppBar(
          toolbarHeight: 10.h,
          elevation: 0,
          backgroundColor: Colors.transparent),
      backgroundColor: Colors.grey.shade200,
      body: Container(
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 0).r,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hallo, ${userModel?.name}',
                      style: GoogleFonts.poppins(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                    ),
                    Text(
                      'Apa Kabarmu Hari Ini?',
                      style: GoogleFonts.poppins(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                    )
                  ],
                ),
                CircleAvatar(
                  minRadius: 30.r,
                  backgroundImage: NetworkImage(userModel?.imageProfile ??
                      'https://www.its.ac.id/aktuaria/wp-content/uploads/sites/100/2018/03/user-320x320.png'),
                ),
              ],
            ),
            SizedBox(
              height: 20.h,
            ),
            Text(
              'Brands',
              style: GoogleFonts.poppins(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.black),
            ),
            SizedBox(
              height: 10.h,
            ),
            const TabButton(),
            SizedBox(
              height: 20.h,
            ),
            Obx(
              () => StreamBuilder(
                  stream: firebaseController
                      .queryProduct()
                      .orderBy('name_product', descending: false)
                      .where('category', isEqualTo: controller.category.value)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(snapshot.error.toString()),
                      );
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: Container(
                            width: 100,
                            height: 100,
                            margin: const EdgeInsets.only(top: 130),
                            child: const CircularProgressIndicator()),
                      );
                    }
                    if (!snapshot.hasData) {
                      return const Image(
                        image: AssetImage('assets/nodata3.gif'),
                        fit: BoxFit.fill,
                      );
                    }

                    final data = snapshot.requireData;
                    return data.size != 0
                        ? Container(
                            padding: const EdgeInsets.only(bottom: 0).r,
                            width: 370.w,
                            height: 350.h,
                            child: MediaQuery.removePadding(
                              context: context,
                              removeTop: true,
                              child: GridView.builder(
                                  itemCount: data.size,
                                  gridDelegate:
                                      SliverGridDelegateWithMaxCrossAxisExtent(
                                          maxCrossAxisExtent: 200,
                                          childAspectRatio: 3 / 5.r,
                                          crossAxisSpacing: 20.r,
                                          mainAxisSpacing: 5.r),
                                  itemBuilder: (context, index) =>
                                      SingleProduct(
                                        product: data.docs[index].data(),
                                        id: data.docs[index].id,
                                      )),
                            ))
                        : const Image(
                            image: AssetImage('assets/nodata3.gif'),
                            fit: BoxFit.fill,
                          );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
