import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oktoast/oktoast.dart';
import 'package:intl/intl.dart';
import 'package:yourbae_project/controller/controller.dart';
import 'package:yourbae_project/controller/photo_controller.dart';
import 'package:yourbae_project/view/home.dart';

import '../view_model/box_custom_payment.dart';

class PaymentConfirmation extends StatelessWidget {
  PaymentConfirmation(
      {super.key, required this.totalTagihan, required this.id});
  num totalTagihan;
  String id;

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firebase = FirebaseFirestore.instance;
    CollectionReference order = firebase.collection('order');
    var isExpandedMobile = false.obs;
    var isExpandedAtm = false.obs;
    var isLoading = false.obs;
    var photoController = Get.put(PhotoController());
    var controller = Get.put(Controller());
    photoController.pathImage.value = '';
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            CupertinoIcons.chevron_back,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text('Konfirmasi Pembayaran',
            style: GoogleFonts.poppins(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 20)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 20.h,
            ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 0).r,
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r)),
                elevation: 3,
                color: Colors.grey.shade100,
                child: Padding(
                  padding: const EdgeInsets.all(20.0).r,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BoxCustomPayment(
                          totalTagihan: totalTagihan,
                          label: 'Nomor Rekening Yourbae',
                          isPaymentAccount: true,
                          bankAccount: 123456789),
                      SizedBox(
                        height: 20.h,
                      ),
                      BoxCustomPayment(
                          totalTagihan: totalTagihan,
                          label: 'Total Tagihan Anda',
                          isPaymentAccount: false),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.fromLTRB(20, 20, 20, 0).r,
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r)),
                elevation: 3,
                color: Colors.grey.shade100,
                child: Padding(
                  padding: const EdgeInsets.all(20.0).r,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Instruksi Pembayaran',
                        style: GoogleFonts.poppins(),
                      ),
                      Container(
                        decoration: const BoxDecoration(
                            border: Border(
                          bottom: BorderSide(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                        )),
                        child: Obx(
                          () => Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Mobile Banking'),
                                  IconButton(
                                      onPressed: () {
                                        isExpandedMobile.value =
                                            !isExpandedMobile.value;
                                      },
                                      icon: isExpandedMobile.isFalse
                                          ? const Icon(
                                              CupertinoIcons.chevron_down)
                                          : const Icon(
                                              CupertinoIcons.chevron_up))
                                ],
                              ),
                              isExpandedMobile.isTrue
                                  ? Text(
                                      'Panduan Bayar\nLogin Mobile Banking\nPilih m-Transfer\nPilih Bank BCA\nInput Nomor Rekening\nLalu Klik Send\nKlik OK\nMuncul Informasi Klik OK\nMasukkan Jumlah Transfer\nInput PIN Mobile Banking\nScreenShot Bukti Pembayaran Berhasil\nUpload Bukti Pembayaran\nSelesai\n',
                                      style:
                                          GoogleFonts.poppins(fontSize: 12.sp))
                                  : const SizedBox()
                            ],
                          ),
                        ),
                      ),
                      Container(
                        decoration: const BoxDecoration(
                            border: Border(
                          bottom: BorderSide(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                        )),
                        child: Obx(
                          () => Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('ATM'),
                                  IconButton(
                                      onPressed: () {
                                        isExpandedAtm.value =
                                            !isExpandedAtm.value;
                                      },
                                      icon: isExpandedAtm.isFalse
                                          ? const Icon(
                                              CupertinoIcons.chevron_down)
                                          : const Icon(
                                              CupertinoIcons.chevron_up))
                                ],
                              ),
                              isExpandedAtm.isTrue
                                  ? Text(
                                      'Panduan Bayar\nPilih Menu Transaksi Lainnya\nPilih Transfer\nPilih Ke Rekening BCA\nInput Nomor Rekening\nPilih Benar\nMasukkan Jumlah Transfer\nPilih Benar\nMAsukkan PIN\nAmbil Bukti Bayar Anda\nUpload Bukti Pembayaran\nSelesai\n',
                                      style:
                                          GoogleFonts.poppins(fontSize: 12.sp))
                                  : const SizedBox()
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            MaterialButton(
              onPressed: isLoading.isTrue
                  ? null
                  : () {
                      photoController.showModal(context);
                    },
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    color: Colors.white70,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade200,
                        offset: const Offset(0.0, 0.5),
                        blurRadius: 30.0,
                      )
                    ]),
                width: 300.w,
                height: 150.h,
                child: Obx(
                  () => Center(
                    child: (photoController.pathImage.value != '')
                        ? Image.file(
                            File(photoController.pathImage.toString()),
                            width: 100.h,
                            height: 100.h,
                          )
                        : Image.network(
                            'https://static.thenounproject.com/png/3322766-200.png',
                            height: 100.0,
                            width: 100.0,
                          ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            Obx(
              () => isLoading.isTrue
                  ? SizedBox(
                      width: 50.w,
                      height: 50.h,
                      child: CircularProgressIndicator(),
                    )
                  : ActionChip(
                      backgroundColor: Colors.blue,
                      onPressed: photoController.pathImage.isEmpty
                          ? null
                          : () async {
                              isLoading.value = true;
                              await photoController.upload(
                                  'PaymentConfirmation', false);
                              await order
                                  .doc(id)
                                  .update(({
                                    'isPay': false,
                                    'buktiBayar':
                                        photoController.downloadUrl.value
                                  }))
                                  .then(
                                (value) {
                                  isLoading.value = false;
                                  Get.back();
                                  // Future.delayed(
                                  //   Duration(seconds: 1),
                                  //   () {
                                  //     showDialog(
                                  //       context: context,
                                  //       builder: (context) {
                                  //         return CupertinoAlertDialog(
                                  //           title: Text(
                                  //             'Bukti Berhasil Dikirim',
                                  //             style: GoogleFonts.poppins(),
                                  //           ),
                                  //           content: Image.asset(
                                  //               'assets/success7.gif'),
                                  //           actions: [
                                  //             TextButton(
                                  //                 onPressed: () {
                                  //                   Navigator.pop(context);
                                  //                 },
                                  //                 child: Text(
                                  //                   'OK',
                                  //                   style: GoogleFonts.poppins(
                                  //                       color: Colors.black),
                                  //                 ))
                                  //           ],
                                  //         );
                                  //       },
                                  //     );
                                  //   },
                                  // );
                                },
                              );
                            },
                      padding: const EdgeInsets.fromLTRB(50, 15, 50, 15).r,
                      label: Text(
                        'Kirim Bukti Pembayaran',
                        style: GoogleFonts.poppins(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      )),
            ),
            SizedBox(
              height: 20.h,
            ),
            // Center(
            //   child: SizedBox(
            //     width: 300.w,
            //     height: 50.h,
            //     child: TextField(
            //       cursorHeight: 20,
            //       decoration: InputDecoration(
            //           suffixIcon: IconButton(
            //               onPressed: () {}, icon: Icon(CupertinoIcons.search)),
            //           border: OutlineInputBorder(
            //               borderRadius: BorderRadius.circular(30.r))),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
