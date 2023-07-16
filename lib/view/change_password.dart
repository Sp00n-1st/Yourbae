import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controller/controller.dart';
import '../model/user_model.dart';
import '../view_model/custom_appbar.dart';
import '../view_model/custom_box_input.dart';
import '../controller/edit_controller.dart';

class ChangePassword extends StatelessWidget {
  const ChangePassword({super.key, required this.userModel});
  final UserModel userModel;

  @override
  Widget build(BuildContext context) {
    TextEditingController passwordOld = TextEditingController();
    TextEditingController passwordNew = TextEditingController();
    TextEditingController confirmationPassword = TextEditingController();
    var controller = Get.put(Controller());
    var editController = Get.put(EditController());
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Ganti Password',
        fun: () {
          Get.back();
        },
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20.h,
              ),
              Text(
                'Password Lama',
                style:
                    GoogleFonts.poppins(color: Colors.black, fontSize: 18.sp),
              ),
              SizedBox(
                height: 15.h,
              ),
              CustomInputBox(
                  hintText: 'Masukkan Password Lama',
                  errorMessage: 'Password Lama Tidak Boleh Kosong!',
                  controllerText: passwordOld,
                  isPassword: true),
              SizedBox(
                height: 20.h,
              ),
              Text(
                'Password Baru',
                style:
                    GoogleFonts.poppins(color: Colors.black, fontSize: 18.sp),
              ),
              SizedBox(
                height: 15.h,
              ),
              CustomInputBox(
                  hintText: 'Masukkan Password Baru',
                  errorMessage: 'Password Baru Tidak Boleh Kosong!',
                  controllerText: passwordNew,
                  isPassword: true),
              SizedBox(
                height: 20.h,
              ),
              Text(
                'Konfirmasi Password',
                style:
                    GoogleFonts.poppins(color: Colors.black, fontSize: 18.sp),
              ),
              SizedBox(
                height: 15.h,
              ),
              CustomInputBox(
                  hintText: 'Masukkan Konfirmasi Password Baru',
                  errorMessage: 'Konfirmasi Password Tidak Boleh Kosong!',
                  controllerText: confirmationPassword,
                  isPassword: true),
              SizedBox(
                height: 50.h,
              ),
              Center(
                  child: Obx(
                () => ActionChip(
                  padding: EdgeInsets.fromLTRB(130.r, 15.r, 120.r, 15.r),
                  label: editController.isLoading.isTrue
                      ? SizedBox(
                          width: 25.w,
                          height: 25.h,
                          child: const CircularProgressIndicator(
                            backgroundColor: Colors.white,
                            color: Colors.black,
                          ),
                        )
                      : SizedBox(
                          width: 60.w,
                          child: Text(
                            'Save',
                            style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                  backgroundColor: Colors.green.shade400,
                  onPressed: editController.isLoading.isTrue
                      ? null
                      : () async {
                          editController.isLoading.value = true;
                          if (passwordNew.value.text.isNotEmpty &&
                              passwordOld.value.text.isNotEmpty &&
                              confirmationPassword.value.text.isNotEmpty) {
                            if (passwordNew.text == confirmationPassword.text) {
                              await editController.changePassword(
                                  context,
                                  userModel,
                                  passwordOld.text,
                                  passwordNew.text);
                            } else {
                              editController.isLoading.value = false;
                              controller.showNotification(
                                  context, 'Password Tidak Sama!');
                            }
                          } else {
                            editController.isLoading.value = false;
                            controller.showNotification(context,
                                'Harap Isi Semua Data Yang Diperlukan!');
                          }
                        },
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
