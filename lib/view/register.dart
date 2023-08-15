import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:oktoast/oktoast.dart';
import '../controller/controller.dart';
import '../controller/create_user_controller.dart';
import '../view/login.dart';
import '../view_model/input_box.dart';
import '../view_model/custom_button_auth.dart';

class Register extends StatelessWidget {
  const Register({super.key});

  @override
  Widget build(BuildContext context) {
    CreateUserController createUserController = Get.put(CreateUserController());
    Controller controller = Get.put(Controller());
    String mobileNumberPhone = '';
    String countryCode = '';
    String countryNumberCode = '';
    TextEditingController nameController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

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
                    SizedBox(
                      height: 50.h,
                    ),
                    SizedBox(
                      width: 241.w,
                      child: Column(
                        children: [
                          SizedBox(
                            width: 150.w,
                            height: 150.h,
                            child: Image.asset('assets/logo.png'),
                          ),
                          Text(
                            'Register Yourbae',
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
                      height: 20.h,
                    ),
                    InputBox(
                      textController: nameController,
                      hintText: 'Masukkan Nama',
                      isPassword: false,
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    InputBox(
                      textController: emailController,
                      hintText: 'Masukkan Email',
                      isPassword: false,
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Container(
                      width: 277.w,
                      height: 60.h,
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0).r,
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 2, color: const Color(0xffBCD1D8)),
                          color: const Color(0xffD9D9D9),
                          borderRadius: BorderRadius.circular(15).r),
                      child: Center(
                        child: IntlPhoneField(
                          autovalidateMode: AutovalidateMode.disabled,
                          disableLengthCheck: true,
                          cursorHeight: 20.h,
                          cursorColor: Colors.blueGrey,
                          decoration: InputDecoration(
                            hintText: 'Masukkan Nomor HP',
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent),
                            ),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(15).r,
                            ),
                          ),
                          onChanged: (phone) {
                            mobileNumberPhone = phone.number;
                            countryNumberCode = phone.countryCode;
                            countryCode = phone.countryISOCode;
                          },
                          onCountryChanged: (country) {},
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    InputBox(
                      textController: passwordController,
                      hintText: 'Masukkan Password',
                      isPassword: true,
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    createUserController.isLoading.value == false
                        ? CustomButtonAuth(
                            nameButton: 'Register',
                            fun: () async {
                              if (nameController.text.isNotEmpty &&
                                  emailController.text.isNotEmpty &&
                                  passwordController.text.isNotEmpty) {
                                try {
                                  createUserController.isLoading.value = true;
                                  await createUserController
                                      .createUserWithEmail(
                                          emailController.text,
                                          passwordController.text,
                                          nameController.text,
                                          countryCode,
                                          countryNumberCode,
                                          mobileNumberPhone,
                                          null,
                                          null,
                                          context);
                                  nameController.clear();
                                  emailController.clear();
                                  passwordController.clear();
                                } on FirebaseAuthException catch (e) {
                                  createUserController.isLoading.value = false;
                                  controller.showNotification(
                                      context, e.message.toString());
                                }
                              } else {
                                showToast('Harap Masukkan Semua Data !',
                                    position: const ToastPosition(
                                        align: Alignment.bottomCenter),
                                    backgroundColor: Colors.red);
                                createUserController.isLoading.value = false;
                              }
                            },
                          )
                        : SizedBox(
                            width: 50.w,
                            height: 50.h,
                            child: const CircularProgressIndicator(
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
                        Text(
                          'Sudah Register ?',
                          style: GoogleFonts.poppins(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        ),
                        TextButton(
                            onPressed: () {
                              Get.offAll(const Login());
                            },
                            child: Text(
                              'Login Sekarang',
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
            margin: const EdgeInsets.fromLTRB(10, 42, 0, 0).r,
            child: IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: const Icon(
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
