import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controller/auth_controller.dart';
import '../controller/firebase_controller.dart';
import '../view/cart.dart';
import '../view/main_view.dart';
import '../view/order_page.dart';
import '../view/profil.dart';
import '../view/search_page.dart';
import '../controller/controller.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    Controller controller = Get.put(Controller());
    AuthController authController = Get.put(AuthController());
    FirebaseController firebaseController = Get.put(FirebaseController());
    PageController? pageController;

    pageController = PageController();
    final iconList = <IconData>[
      CupertinoIcons.house_fill,
      CupertinoIcons.cart_fill,
      CupertinoIcons.search,
      CupertinoIcons.square_list_fill,
    ];

    final bool showFab = MediaQuery.of(context).viewInsets.bottom == 0.0;
    FlutterNativeSplash.remove();
    return StreamBuilder(
        stream: firebaseController.queryUser().snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            authController.logoutAuth(false);
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.data!['is_disable'] == true) {
            authController.logoutAuth(false);
          }
          return Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: Colors.grey.shade200,
            body: PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: pageController,
              children: <Widget>[
                MainView(userModel: snapshot.data?.data()!),
                const Cart(),
                const SearchPage(),
                const OrderPage()
              ],
            ),
            floatingActionButton: showFab
                ? Hero(
                    tag: 'ass',
                    transitionOnUserGestures: true,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 0),
                      width: 70.w,
                      height: 70.h,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50.r)),
                      child: GestureDetector(
                        onTap: () async {
                          Get.to(StreamBuilder(
                              stream:
                                  firebaseController.queryUser().snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  authController.logoutAuth(false);
                                } else if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                return Profil(
                                    userModel: snapshot.data!.data()!);
                              }));
                        },
                        child: Image.asset(
                          'assets/logo.png',
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  )
                : null,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
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
                  if (index == 2) {
                    controller.textEditingController.value.clear();
                    controller.showStream.value = false;
                  }
                  controller.selectedPages.value = index;
                  pageController!.animateToPage(controller.selectedPages.value,
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeOutQuad);
                },
              ),
            ),
          );
        });
  }
}
