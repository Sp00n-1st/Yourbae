import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:oktoast/oktoast.dart';
import '../controller/edit_controller.dart';
import '../controller/photo_controller.dart';
import '../model/user_model.dart';
import '../view_model/custom_appbar.dart';
import '../view_model/custom_box_input.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key, required this.userModel});
  final UserModel userModel;

  @override
  Widget build(BuildContext context) {
    var name = TextEditingController(text: userModel.name).obs;
    TextEditingController mobileNumberPhone =
        TextEditingController(text: userModel.mobileNumberPhone);
    String countryCode = userModel.countryCode;
    String countryNumberCode = userModel.countryNumberCode;
    var isEmpty = false.obs;
    var validNumber = true.obs;
    var control = false.obs;
    var photoController = Get.put(PhotoController());
    var editController = Get.put(EditController());

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(
        title: 'Edit Profil',
        fun: () {
          Get.back();
        },
      ),
      body: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 50.h,
            ),
            Center(
              child: GestureDetector(
                // onTap: photoController.pickPhotoFromGallery,
                onTap: () {
                  showModalBottomSheet(
                    backgroundColor: Colors.transparent,
                    context: context,
                    builder: (context) {
                      return Container(
                        width: double.infinity,
                        height: 100.h,
                        padding: const EdgeInsets.fromLTRB(20, 10, 0, 0).r,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20.r),
                              topRight: Radius.circular(20.r),
                            )),
                        child: Column(
                          children: [
                            SizedBox(
                              width: double.infinity,
                              height: 40.h,
                              child: MaterialButton(
                                onPressed: () async {
                                  Navigator.pop(context);
                                  await photoController
                                      .pickPhotoFromGallery(ImageSource.camera);
                                },
                                child: Row(
                                  children: [
                                    Icon(
                                      CupertinoIcons.camera,
                                      size: 30.r,
                                    ),
                                    SizedBox(
                                      width: 10.w,
                                    ),
                                    Text(
                                      'Ambil dari Kamera',
                                      style: GoogleFonts.poppins(),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: double.infinity,
                              height: 40.h,
                              child: MaterialButton(
                                onPressed: () async {
                                  Navigator.pop(context);
                                  await photoController.pickPhotoFromGallery(
                                      ImageSource.gallery);
                                },
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.image,
                                      size: 30.r,
                                    ),
                                    SizedBox(
                                      width: 10.w,
                                    ),
                                    Text(
                                      'Ambil dari Gallery',
                                      style: GoogleFonts.poppins(),
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  );
                },
                child: (photoController.pathImage.value != '')
                    ? CircleAvatar(
                        radius: 100,
                        backgroundImage: FileImage(
                            File(photoController.pathImage.toString())))
                    : CircleAvatar(
                        radius: 100,
                        backgroundImage: userModel.imageProfile == null
                            ? const NetworkImage(
                                'https://www.its.ac.id/aktuaria/wp-content/uploads/sites/100/2018/03/user-320x320.png')
                            : NetworkImage(userModel.imageProfile!),
                      ),
              ),
            ),
            Container(
                margin: const EdgeInsets.only(left: 20, top: 30, bottom: 10),
                child: Text(
                  'Nama',
                  style: GoogleFonts.poppins(),
                )),
            CustomInputBox(
                isPassword: false,
                hintText: 'Input Nama',
                errorMessage: 'Nama Tidak Boleh Kosong!',
                controllerText: name.value),
            Container(
                margin: const EdgeInsets.only(left: 20, top: 30, bottom: 10),
                child: Text(
                  'Nomor HP',
                  style: GoogleFonts.poppins(),
                )),
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20).r,
              child: Obx(
                () => IntlPhoneField(
                  initialCountryCode: userModel.countryCode,
                  initialValue: userModel.mobileNumberPhone,
                  disableLengthCheck: validNumber.value,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  cursorHeight: 20.h,
                  cursorColor: Colors.blueGrey,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                            color: control.value == true
                                ? Colors.red
                                : Colors.blue,
                            width: 2)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                            color: control.value == true
                                ? Colors.red
                                : Colors.blue.shade900,
                            width: 2)),
                    hintText: 'Masukkan Nomor HP',
                    border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                  ),
                  onChanged: (phone) {
                    if (phone.number.isEmpty) {
                      control.value = true;
                    } else {
                      mobileNumberPhone.text = phone.number;
                      countryCode = phone.countryISOCode;
                      countryNumberCode = phone.countryCode;
                      control.value = false;
                    }
                  },
                  onCountryChanged: (country) {
                    countryCode = country.code;
                    countryNumberCode = country.dialCode;
                  },
                ),
              ),
            ),
            control.value == true
                ? Container(
                    margin: const EdgeInsets.fromLTRB(30, 5, 0, 0).r,
                    child: Text(
                      'Nomor HP Tidak Boleh Kosong!',
                      style: GoogleFonts.poppins(
                          fontSize: 12.sp, color: Colors.red),
                    ))
                : const SizedBox(),
            SizedBox(
              height: 20.h,
            ),
            Center(
              child: SizedBox(
                width: 120.w,
                height: 50.h,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(shape: const StadiumBorder()),
                  onPressed: editController.isLoading.value == true ||
                          isEmpty.value == true ||
                          control.value == true
                      ? null
                      : () async {
                          if (name.value.text.isNotEmpty &&
                              mobileNumberPhone.text.isNotEmpty &&
                              countryCode.isNotEmpty &&
                              countryNumberCode.isNotEmpty) {
                            editController.isLoading.value = true;
                            await editController.editUser(
                                userModel,
                                name.value.text,
                                countryCode,
                                countryNumberCode,
                                mobileNumberPhone.text);
                          } else {
                            showToast('Harap Isi Semua Kolom Data',
                                position: const ToastPosition(
                                    align: Alignment.bottomCenter));
                          }
                        },
                  child: editController.isLoading.value == true
                      ? SizedBox(
                          width: 30.w,
                          height: 30.h,
                          child: const CircularProgressIndicator(
                            color: Colors.black,
                            backgroundColor: Colors.white,
                          ))
                      : Text(
                          'Save',
                          style: GoogleFonts.poppins(),
                        ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
