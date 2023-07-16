import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controller/auth_controller.dart';
import '../controller/controller.dart';
import '../view_model/input_box.dart';
import '../view_model/custom_button_auth.dart';
import 'register.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController password = TextEditingController();
    TextEditingController emailResetPass = TextEditingController();
    AuthController authController = Get.put(AuthController());
    Controller controller = Get.put(Controller());
    FlutterNativeSplash.remove();
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 53.h, 0, 0),
                      width: 241.w,
                      child: Column(
                        children: [
                          SizedBox(
                            width: 150.w,
                            height: 150.h,
                            child: Image.asset('assets/logo.png'),
                          ),
                          Text(
                            'Selamat Datang Kembali!',
                            softWrap: true,
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                                fontSize: 24.sp,
                                fontWeight: FontWeight.w400,
                                color: Colors.white),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    InputBox(
                        isPassword: false,
                        hintText: 'Masukkan Email',
                        textController: emailController),
                    SizedBox(
                      height: 20.h,
                    ),
                    InputBox(
                        isPassword: true,
                        textController: password,
                        hintText: 'Masukkan Password'),
                    SizedBox(
                      height: 10.h,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(0, 0, 42, 0).r,
                        child: TextButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return CupertinoAlertDialog(
                                    title: Text(
                                      'Reset Password ?',
                                      style: GoogleFonts.poppins(),
                                    ),
                                    content: Column(
                                      children: [
                                        SizedBox(
                                          height: 10.h,
                                        ),
                                        Text(
                                          'Masukkan Email Yang Terdaftar',
                                          style: GoogleFonts.poppins(),
                                        ),
                                        SizedBox(
                                          height: 10.h,
                                        ),
                                        Material(
                                          borderRadius:
                                              BorderRadius.circular(15.r),
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                    10, 0, 10, 0)
                                                .r,
                                            child: TextField(
                                              controller: emailResetPass,
                                              keyboardType:
                                                  TextInputType.emailAddress,
                                              decoration: const InputDecoration(
                                                  border: InputBorder.none),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            authController.resetPassword(
                                                context, emailResetPass.text);
                                          },
                                          child: Text(
                                            'OK',
                                            style: GoogleFonts.poppins(
                                                color: Colors.black),
                                          )),
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            'Batal',
                                            style: GoogleFonts.poppins(
                                                color: Colors.black),
                                          ))
                                    ],
                                  );
                                },
                              );
                              !authController.isLogin.value;
                            },
                            child: Text(
                              'Reset Password',
                              style: GoogleFonts.poppins(
                                  decoration: TextDecoration.underline,
                                  fontSize: 15,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300),
                            )),
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    authController.isLogin.value == true
                        ? SizedBox(
                            width: 50.w,
                            height: 50.h,
                            child: const CircularProgressIndicator(
                              color: Colors.white,
                              backgroundColor: Colors.black,
                            ),
                          )
                        : CustomButtonAuth(
                            nameButton: 'Login',
                            fun: () async {
                              try {
                                authController.isLogin.value =
                                    !authController.isLogin.value;
                                await authController.loginAuth(context,
                                    emailController.text, password.text);
                              } on FirebaseAuthException catch (e) {
                                authController.isLogin.value =
                                    !authController.isLogin.value;
                                controller.showNotification(
                                    context, e.message.toString());
                              }
                            },
                          ),
                    SizedBox(
                      height: 69.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Belum Register?',
                          style: GoogleFonts.poppins(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        ),
                        TextButton(
                            onPressed: () {
                              Get.to(const Register());
                            },
                            child: Text(
                              'Register Sekarang',
                              style: GoogleFonts.poppins(
                                  decoration: TextDecoration.underline,
                                  fontSize: 14,
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
          )
        ],
      ),
    );
  }

  Widget inputBox(
      TextEditingController textController, bool isPassword, String hintText) {
    var isShowPassword = false.obs;
    return Container(
      width: 277.w,
      height: 60.h,
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 15),
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
      decoration: BoxDecoration(
          border: Border.all(width: 2, color: const Color(0xffBCD1D8)),
          color: const Color(0xffD9D9D9),
          borderRadius: BorderRadius.circular(15).r),
      child: Center(
        child: Obx(
          () => TextField(
            obscureText: (isShowPassword.value && isPassword) ? true : false,
            style: GoogleFonts.poppins(fontSize: 18),
            controller: textController,
            cursorColor: Colors.orange,
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hintText,
                suffixIcon: isPassword
                    ? isShowPassword.value
                        ? IconButton(
                            onPressed: () {
                              isShowPassword.value = !isShowPassword.value;
                            },
                            icon: const Icon(
                              CupertinoIcons.eye_fill,
                              size: 22,
                            ))
                        : IconButton(
                            onPressed: () {
                              isShowPassword.value = !isShowPassword.value;
                            },
                            icon: const Icon(
                              CupertinoIcons.eye_slash_fill,
                              size: 22,
                            ))
                    : null),
          ),
        ),
      ),
    );
  }
}
