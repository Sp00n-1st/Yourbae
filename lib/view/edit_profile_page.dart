import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:oktoast/oktoast.dart';
import 'package:yourbae_project/controller/edit_controller.dart';
import 'package:yourbae_project/controller/foto_controller.dart';
import 'package:yourbae_project/model/user.dart';

class EditProfilePage extends StatelessWidget {
  EditProfilePage({super.key, required this.userAccount});
  UserAccount userAccount;

  @override
  Widget build(BuildContext context) {
    var name = TextEditingController(text: userAccount.name).obs;
    TextEditingController nomorHP =
        TextEditingController(text: userAccount.nomorHP);
    String kodeNegara = userAccount.kodeNegara;
    String kodeNomorNegara = userAccount.kodeNomorNegara;
    var isEmpty = false.obs;
    var validNumber = true.obs;
    var control = false.obs;
    var photoController = Get.put(PhotoController());
    var editController = Get.put(EditController());

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            CupertinoIcons.back,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Edit Profile',
          style: GoogleFonts.poppins(
              color: Colors.black, fontWeight: FontWeight.w600, fontSize: 30),
        ),
      ),
      body: SingleChildScrollView(
        child: Obx(
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
                    print('data');
                    showModalBottomSheet(
                      backgroundColor: Colors.transparent,
                      context: context,
                      builder: (context) {
                        return Container(
                          width: double.infinity,
                          height: 100.h,
                          padding: EdgeInsets.fromLTRB(20, 10, 0, 0).r,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20.r),
                                topRight: Radius.circular(20.r),
                              )),
                          child: Column(
                            children: [
                              Container(
                                width: double.infinity,
                                height: 40.h,
                                child: MaterialButton(
                                  onPressed: () async {
                                    print('Camera');
                                    Navigator.pop(context);
                                    await photoController.pickPhotoFromGallery(
                                        ImageSource.camera);
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
                              Container(
                                width: double.infinity,
                                height: 40.h,
                                child: MaterialButton(
                                  onPressed: () async {
                                    print('Gallerry');
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
                          backgroundImage: userAccount.imageProfile == null
                              ? const NetworkImage(
                                  'https://www.its.ac.id/aktuaria/wp-content/uploads/sites/100/2018/03/user-320x320.png')
                              : NetworkImage(userAccount.imageProfile!),
                        ),
                ),
              ),
              Container(
                  margin: const EdgeInsets.only(left: 20, top: 30, bottom: 10),
                  child: Text(
                    'Nama',
                    style: GoogleFonts.poppins(),
                  )),
              Container(
                margin: const EdgeInsets.only(left: 20, right: 20).r,
                child: TextFormField(
                  style: GoogleFonts.poppins(),
                  controller: name.value,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    errorStyle:
                        GoogleFonts.poppins(fontSize: 12.sp, color: Colors.red),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide:
                            BorderSide(color: Colors.blue.shade900, width: 2)),
                    hintText: 'Input First Name',
                    border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      Future.delayed(Duration(milliseconds: 50), () {
                        isEmpty.value = true;
                      });
                      return 'Nama Tidak Boleh Kosong!';
                    } else {
                      Future.delayed(Duration(milliseconds: 50), () {
                        isEmpty.value = false;
                      });
                    }

                    return null;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
              ),
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
                    initialCountryCode: userAccount.kodeNegara,
                    initialValue: userAccount.nomorHP,
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
                        nomorHP.text = phone.number;
                        kodeNegara = phone.countryISOCode;
                        kodeNomorNegara = phone.countryCode;
                        control.value = false;
                      }
                    },
                    onCountryChanged: (country) {
                      kodeNegara = country.code;
                      kodeNomorNegara = country.dialCode;
                      print('Country changed to: ' + country.name);
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
                    style:
                        ElevatedButton.styleFrom(shape: const StadiumBorder()),
                    onPressed: editController.isLoading.value == true ||
                            isEmpty.value == true ||
                            control.value == true
                        ? null
                        : () async {
                            if (name.value.text.isNotEmpty &&
                                nomorHP.text.isNotEmpty &&
                                kodeNegara.isNotEmpty &&
                                kodeNomorNegara.isNotEmpty) {
                              print('object');
                              editController.isLoading.value = true;
                              await editController.editUser(
                                  userAccount,
                                  name.value.text,
                                  kodeNegara,
                                  kodeNomorNegara,
                                  nomorHP.text);
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
      ),
    );
  }
}
