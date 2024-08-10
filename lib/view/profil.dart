import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oktoast/oktoast.dart';
import '../controller/auth_controller.dart';
import '../controller/customer_service_controller.dart';
import '../controller/firebase_controller.dart';
import '../model/user_model.dart';
import '../model/wishlist_model.dart';
import '../view/change_password.dart';
import '../view/edit_profile_page.dart';
import '../view/wishlist.dart';
import '../view_model/menu_profile.dart';

class Profil extends StatelessWidget {
  const Profil({super.key, required this.userModel});
  final UserModel userModel;

  @override
  Widget build(BuildContext context) {
    AuthController authController = Get.put(AuthController());
    CustomerServiceController customerController =
        Get.put(CustomerServiceController());
    FirebaseController firebaseController = Get.put(FirebaseController());

    return Hero(
      tag: 'ass',
      child: Scaffold(
        backgroundColor: Colors.grey,
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(CupertinoIcons.back)),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Stack(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(47.sp, 50.sp, 47.sp, 0),
              width: double.infinity,
              height: double.infinity,
              margin: EdgeInsets.only(top: 160.sp),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15.r),
                      topRight: Radius.circular(15.r))),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: SizedBox(
                        width: 198.w,
                        child: Text(
                          userModel.name,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500, fontSize: 24.sp),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 22.h,
                    ),
                    MenuProfile(
                      duration: 150,
                      image: 'assets/edit.png',
                      namaMenu: 'Edit Profile',
                      fun: () {
                        Get.to(
                            EditProfilePage(
                              userModel: userModel,
                            ),
                            transition: Transition.leftToRightWithFade);
                      },
                    ),
                    SizedBox(
                      height: 16.h,
                    ),
                    MenuProfile(
                      duration: 250,
                      image: 'assets/wishlist.png',
                      namaMenu: 'Wish List',
                      fun: () {
                        Get.to(
                            StreamBuilder<QuerySnapshot<WishlistModel>>(
                                stream: firebaseController
                                    .queryWishlist()
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasError) {
                                    showToast(snapshot.hasError.toString(),
                                        position: const ToastPosition(
                                            align: Alignment.bottomCenter));
                                  } else if (snapshot.connectionState ==
                                      ConnectionState.waiting) {}
                                  return WishList(
                                      listWishList: snapshot.data!.docs);
                                }),
                            transition: Transition.leftToRightWithFade);
                      },
                    ),
                    SizedBox(
                      height: 16.h,
                    ),
                    MenuProfile(
                      duration: 350,
                      image: 'assets/changePass.png',
                      namaMenu: 'Ganti Password',
                      fun: () {
                        Get.to(ChangePassword(userModel: userModel),
                            transition: Transition.leftToRightWithFade);
                      },
                    ),
                    SizedBox(
                      height: 16.h,
                    ),
                    MenuProfile(
                      duration: 450,
                      image: 'assets/cs.png',
                      namaMenu: 'Customer Service',
                      fun: () {
                        try {
                          firebaseController.queryStore().get().then((value) =>
                              {
                                customerController.openWhatsApp(
                                    value.data()!.noCustomerService)
                              });
                        } on FirebaseException catch (e) {
                          showToast(e.message!,
                              position: const ToastPosition(
                                  align: Alignment.bottomCenter));
                        }
                      },
                    ),
                    SizedBox(
                      height: 27.h,
                    ),
                    Text(
                      'My Account',
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500, fontSize: 20),
                    ),
                    TextButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return CupertinoAlertDialog(
                                title: const Text('Anda Yakin Ingin Logout ?'),
                                content: Container(
                                  margin: EdgeInsets.fromLTRB(0, 10.r, 0, 0),
                                  width: 100.w,
                                  height: 100.h,
                                  child: Image.asset('assets/logout.png'),
                                ),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        authController.logoutAuth(false);
                                      },
                                      child: Text(
                                        'Ya',
                                        style: GoogleFonts.poppins(
                                            color: Colors.black),
                                      )),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        'Tidak',
                                        style: GoogleFonts.poppins(
                                            color: Colors.black),
                                      ))
                                ],
                              );
                            },
                          );
                        },
                        child: Text(
                          'Sign Out',
                          style: GoogleFonts.poppins(
                              color: const Color(0xffFF434A),
                              fontSize: 19,
                              fontWeight: FontWeight.w300),
                        ))
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: userModel.imageProfile == null
                  ? CircleAvatar(
                      radius: 100.r,
                      backgroundImage: const NetworkImage(
                          'https://www.its.ac.id/aktuaria/wp-content/uploads/sites/100/2018/03/user-320x320.png'),
                    )
                  : CircleAvatar(
                      radius: 100.r,
                      backgroundImage: NetworkImage(userModel.imageProfile!),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
