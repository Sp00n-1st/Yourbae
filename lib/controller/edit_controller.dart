import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:yourbae_project/controller/foto_controller.dart';

import '../model/user.dart';

class EditController extends GetxController {
  var isLoading = false.obs;

  Future<void> editUser(UserAccount userAccount, String name, String kodeNegara,
      String kodeNomorNegara, String nomorHP) async {
    String? imageSave;
    final auth = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore firebase = FirebaseFirestore.instance;
    CollectionReference user = firebase.collection('user');
    var photoController = Get.put(PhotoController());

    photoController.uploading.value = !photoController.uploading.value;
    print(photoController.uploading);
    await photoController.upload();
    if (photoController.pathImage.isEmpty && userAccount.imageProfile != null) {
      imageSave = userAccount.imageProfile;
    } else if (photoController.pathImage.isNotEmpty &&
        userAccount.imageProfile != null) {
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
}
