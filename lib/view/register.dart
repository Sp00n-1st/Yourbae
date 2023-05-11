import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oktoast/oktoast.dart';
import 'package:yourbae_project/controller/auth_controller.dart';
import 'package:yourbae_project/controller/controller.dart';
import 'package:yourbae_project/controller/createUser_controller.dart';
import 'package:yourbae_project/view/login.dart';
import '../view_model/input_box.dart';
import '../view_model/custom_button.dart';
import '../view_model/custom_button_auth.dart';

class Register extends StatelessWidget {
  const Register({super.key});

  @override
  Widget build(BuildContext context) {
    var createUserController = Get.put(CreateUserController());
    var authController = Get.put(AuthController());
    var controller = Get.put(Controller());
    TextEditingController firstNameController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Image.asset(
              'assets/bgLogin.png',
              fit: BoxFit.fill,
            ),
          ),
          SingleChildScrollView(
            child: Center(
              child: Obx(
                () => Column(
                  children: [
                    SizedBox(
                      height: 110.h,
                    ),
                    SizedBox(
                      width: 241.w,
                      child: Column(
                        children: [
                          Text(
                            'Hello!',
                            style: GoogleFonts.poppins(
                                fontSize: 34.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                          ),
                          SizedBox(
                            height: 13.h,
                          ),
                          Text(
                            'Want Premium Shoes?Create Account',
                            softWrap: true,
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w400,
                                color: Colors.white),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 66.h,
                    ),
                    InputBox(
                      textController: firstNameController,
                      hintText: 'Enter Your Name',
                      isPassword: false,
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    InputBox(
                      textController: emailController,
                      hintText: 'Enter Email',
                      isPassword: false,
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    InputBox(
                      textController: passwordController,
                      hintText: 'Password',
                      isPassword: true,
                    ),
                    SizedBox(
                      height: 39.h,
                    ),
                    createUserController.isLoading.value == false
                        ? CustomButtonAuth(
                            nameButton: 'Register',
                            fun: () async {
                              if (firstNameController.text.isNotEmpty &&
                                  emailController.text.isNotEmpty &&
                                  passwordController.text.isNotEmpty) {
                                try {
                                  createUserController.isLoading.value = true;
                                  await createUserController
                                      .createUserWithEmail(
                                          emailController.text,
                                          passwordController.text,
                                          firstNameController.text,
                                          null,
                                          null,
                                          context);
                                  firstNameController.clear();
                                  emailController.clear();
                                  passwordController.clear();
                                  createUserController.isLoading.value = false;
                                } on FirebaseAuthException catch (e) {
                                  authController.isLogin.value =
                                      !authController.isLogin.value;
                                  controller.showNotification(
                                      context, e.message.toString());
                                }
                              } else {
                                showToast('Please Enter All Data Required !',
                                    position: ToastPosition(
                                        align: Alignment.bottomCenter),
                                    backgroundColor: Colors.red);
                              }
                            },
                          )
                        : SizedBox(
                            width: 50.w,
                            height: 50.h,
                            child: CircularProgressIndicator(
                              backgroundColor: Colors.white,
                              color: Colors.black,
                            ),
                          ),
                    SizedBox(
                      height: 69.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/line1.png',
                          fit: BoxFit.contain,
                        ),
                        SizedBox(
                          width: 6.w,
                        ),
                        SizedBox(
                          height: 18.h,
                          width: 126.w,
                          child: Text(
                            'Or Register With',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w300,
                                color: Colors.white),
                          ),
                        ),
                        SizedBox(
                          width: 6.w,
                        ),
                        Image.asset(
                          'assets/line2.png',
                          fit: BoxFit.contain,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 32.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomButton(
                          image: 'fb',
                        ),
                        SizedBox(
                          width: 16.w,
                        ),
                        CustomButton(
                          image: 'google',
                        ),
                        SizedBox(
                          width: 16.w,
                        ),
                        CustomButton(
                          image: 'twitter',
                        )
                      ],
                    ),
                    SizedBox(
                      height: 28.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already a member?',
                          style: GoogleFonts.poppins(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        ),
                        TextButton(
                            onPressed: () {
                              Get.offAll(Login());
                            },
                            child: Text(
                              'Sign In Now',
                              style: GoogleFonts.poppins(
                                  decoration: TextDecoration.underline,
                                  fontSize: 14.sp,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300),
                            )),
                        SizedBox(
                          height: 48.h,
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(10, 42, 0, 0).r,
            child: IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: Icon(
                  CupertinoIcons.chevron_left,
                  color: Colors.white,
                  size: 30,
                )),
          )
        ],
      ),
    );
  }
}
