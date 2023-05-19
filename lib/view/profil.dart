import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yourbae_project/controller/auth_controller.dart';
import 'package:yourbae_project/model/user_model.dart';
import 'package:yourbae_project/view/login.dart';
import 'package:yourbae_project/view/edit_profile_page.dart';
import 'package:yourbae_project/view/input_alamat.dart';

import '../view_model/menu_profile.dart';

class Profil extends StatelessWidget {
  Profil({super.key, required this.userModel});
  UserModel userModel;
  @override
  Widget build(BuildContext context) {
    var authController = Get.put(AuthController());
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
              margin: EdgeInsets.only(top: 150.sp),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15.r),
                      topRight: Radius.circular(15.r))),
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
                    image: 'assets/wishlist.png',
                    namaMenu: 'Wish List',
                    fun: () {},
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  MenuProfile(
                    image: 'assets/maps.png',
                    namaMenu: 'Address',
                    fun: () {
                      Get.to(InputAlamat(),
                          transition: Transition.leftToRightWithFade);
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
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin: EdgeInsets.only(top: 40.sp),
                width: 154.w,
                height: 154.h,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border:
                        Border.all(width: 5, color: const Color(0xff587179)),
                    borderRadius: BorderRadius.circular(17.sp)),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.sp),
                    child: userModel.imageProfile == null
                        ? Image.network(
                            'https://www.its.ac.id/aktuaria/wp-content/uploads/sites/100/2018/03/user-320x320.png',
                            fit: BoxFit.fill,
                          )
                        : Image.network(
                            userModel.imageProfile!,
                            fit: BoxFit.fill,
                          )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
