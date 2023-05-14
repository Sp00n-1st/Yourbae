import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yourbae_project/controller/auth_controller.dart';
import 'package:yourbae_project/view/cart.dart';
import 'package:yourbae_project/view/main_view.dart';
import 'package:yourbae_project/view/profil.dart';
import 'package:yourbae_project/view/flash_sale_page.dart';
import 'package:yourbae_project/view/search_page.dart';

import '../controller/controller.dart';
import '../model/user.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var controller = Get.put(Controller());
    var authController = Get.put(AuthController());
    final auth = FirebaseAuth.instance.currentUser!.uid;
    PageController? pageController;
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentReference<UserAccount> users = firestore
        .collection('user')
        .doc(auth)
        .withConverter<UserAccount>(
            fromFirestore: (snapshot, _) =>
                UserAccount.fromJson(snapshot.data()),
            toFirestore: (users, _) => users.toJson());

    pageController = PageController();
    final iconList = <IconData>[
      CupertinoIcons.house_fill,
      CupertinoIcons.cart_fill,
      CupertinoIcons.search,
      CupertinoIcons.bolt_fill
    ];

    final bool showFab = MediaQuery.of(context).viewInsets.bottom == 0.0;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        children: <Widget>[MainView(), Cart(), SearchPage(), FlashSalePage()],
      ),
      floatingActionButton: showFab
          ? Container(
              margin: const EdgeInsets.only(bottom: 0),
              width: 70.w,
              height: 70.h,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(50.r)),
              child: GestureDetector(
                  onTap: () {
                    Get.to(StreamBuilder(
                        stream: users.snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            authController.logoutAuth(false);
                          } else if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return Profil(userAccount: snapshot.data!.data()!);
                        }));
                  },
                  child: Hero(
                      tag: 'ass',
                      child: Image.asset(
                        'assets/logo.png',
                        fit: BoxFit.fill,
                      ))
                  //params
                  ),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Obx(
        () => AnimatedBottomNavigationBar(
          backgroundColor: const Color(0xff205295),
          activeColor: const Color(0xffF7C04A),
          inactiveColor: Colors.white,
          icons: iconList,
          activeIndex: controller.selectedPages.value,
          gapLocation: GapLocation.center,
          notchSmoothness: NotchSmoothness.verySmoothEdge,
          onTap: (index) {
            controller.selectedPages.value = index;
            pageController!.animateToPage(controller.selectedPages.value,
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOutQuad);
            print(controller.selectedPages.value);
          },
          //other params
        ),
      ),
    );
  }
}
