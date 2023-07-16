import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/controller.dart';
import '../controller/photo_controller.dart';
import '../model/user_model.dart';

class EditController extends GetxController {
  var isLoading = false.obs;
  var controller = Get.put(Controller());

  Future<void> editUser(UserModel userModel, String name, String kodeNegara,
      String kodeNomorNegara, String nomorHP) async {
    String? imageSave;
    final auth = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore firebase = FirebaseFirestore.instance;
    CollectionReference user = firebase.collection('user');
    var photoController = Get.put(PhotoController());

    photoController.uploading.value = !photoController.uploading.value;
    await photoController.upload('ProfileImages', true);
    if (photoController.pathImage.isEmpty && userModel.imageProfile != null) {
      imageSave = userModel.imageProfile;
    } else if (photoController.pathImage.isNotEmpty &&
        userModel.imageProfile != null) {
      imageSave = photoController.downloadUrl.value;
    } else if (photoController.pathImage.isNotEmpty) {
      imageSave = photoController.downloadUrl.value;
    }
    user.doc(auth).update(({
          'name': name,
          'kodeNegara': kodeNegara,
          'kodeNomorNegara': kodeNomorNegara,
          'nomorHP': nomorHP,
          'imageProfile': imageSave,
        }));
    isLoading.value = false;
    Get.back();
  }

  Future<void> changePassword(BuildContext context, UserModel userModel,
      String currentPassword, String newPassword) async {
    final user = FirebaseAuth.instance.currentUser;
    try {
      isLoading.value = true;
      final cred = EmailAuthProvider.credential(
          email: userModel.email, password: currentPassword);
      await user!.reauthenticateWithCredential(cred).then((value) async {
        await user.updatePassword(newPassword).then((value) => {
              CoolAlert.show(
                      context: context,
                      type: CoolAlertType.success,
                      text: 'Password Berhasil Diganti!')
                  .then((value) => {Get.back()})
            });
      }).catchError((error) {
        if (error.toString().contains('wrong-password')) {
          isLoading.value = false;
          controller.showNotification(
              context, 'Password Yang Anda Masukkan Salah!');
        } else if (error.toString().contains('too-many-requests')) {
          isLoading.value = false;
          controller.showNotification(context,
              'Terlalu Banyak Mencoba Ganti Password, Coba Lagi Nanti!');
        } else {
          isLoading.value = false;
          controller.showNotification(context, error.toString());
        }
      });
    } on FirebaseAuthException catch (e) {
      isLoading.value = false;
      controller.showNotification(context, e.message!);
    }
  }
}
