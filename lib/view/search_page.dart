import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controller/controller.dart';
import '../controller/firebase_controller.dart';
import '../view_model/single_product.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    Controller controller = Get.put(Controller());
    FirebaseController firebaseController = Get.put(FirebaseController());

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text('Cari Sepatu',
            style: GoogleFonts.poppins(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 30)),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 20.h,
          ),
          Center(
            child: SizedBox(
              width: 300.w,
              height: 50.h,
              child: TextField(
                cursorHeight: 20,
                controller: controller.textEditingController.value,
                textCapitalization: TextCapitalization.sentences,
                onChanged: (value) {
                  controller.showStream.value = false;
                },
                decoration: InputDecoration(
                    suffixIcon: IconButton(
                        onPressed: () {
                          if (controller.textEditingController.value.text ==
                              '') {
                          } else {
                            controller.showStream.value =
                                !controller.showStream.value;
                          }
                        },
                        icon: const Icon(CupertinoIcons.search)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.r))),
              ),
            ),
          ),
          Obx(() => controller.showStream.isTrue
              ? StreamBuilder(
                  stream: firebaseController
                      .queryProduct()
                      .where('search',
                          isGreaterThanOrEqualTo: controller
                              .textEditingController.value.text
                              .toLowerCase())
                      .where('search',
                          isLessThan:
                              '${controller.textEditingController.value.text.toLowerCase()}z')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(snapshot.hasError.toString()),
                      );
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Center(
                        child: SizedBox(
                          width: 50.w,
                          height: 50.h,
                          child: const CircularProgressIndicator(),
                        ),
                      );
                    } else if (snapshot.data!.docs.isEmpty) {
                      return Column(
                        children: [Image.asset('assets/nodata3.gif')],
                      );
                    }
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(20).r,
                        child: GridView.builder(
                            itemCount: snapshot.data!.size,
                            gridDelegate:
                                SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: 200,
                                    childAspectRatio: 3 / 4.5.r,
                                    crossAxisSpacing: 20.r,
                                    mainAxisSpacing: 5.r),
                            itemBuilder: (context, index) => SingleProduct(
                                  product: snapshot.data!.docs[index].data(),
                                  id: snapshot.data!.docs[index].id,
                                )),
                      ),
                    );
                  },
                )
              : const SizedBox())
        ],
      ),
    );
  }
}
