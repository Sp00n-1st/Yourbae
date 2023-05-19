import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oktoast/oktoast.dart';
import 'package:uuid/uuid.dart';

class PhotoController extends GetxController {
  List<Widget> itemPhotosWidgetList = <Widget>[];
  XFile? photo;
  XFile? itemImagesList;
  final auth = FirebaseAuth.instance.currentUser!.uid;
  final ImagePicker _picker = ImagePicker();
  var downloadUrl = ''.obs;
  var uploading = false.obs;
  var pathImage = ''.obs;

  pickPhotoFromGallery(ImageSource? source) async {
    photo = await _picker.pickImage(source: source!);
    if (photo != null) {
      itemImagesList = photo!;
      pathImage.value = photo!.path;
    }
  }

  upload(String pathStorage, bool isUSer) async {
    await uplaodImageAndSaveItemInfo(pathStorage, isUSer);
    uploading.value = false;
    itemPhotosWidgetList.clear();
  }

  Future<String> uplaodImageAndSaveItemInfo(
      String pathStorage, bool isUser) async {
    uploading.value = true;

    String randomId = const Uuid().v4();
    String? imageId;
    if (isUser == true) {
      imageId = '$pathStorage/$auth';
    } else {
      imageId = '$pathStorage/$randomId';
    }

    if (itemImagesList != null) {
      PickedFile? pickedFile = PickedFile(itemImagesList!.path.toString());
      await uploadImageToStorage(pickedFile, imageId);
    }
    return pathStorage;
  }

  uploadImageToStorage(PickedFile? pickedFile, String imageId) async {
    Reference? reference = FirebaseStorage.instance.ref().child(imageId);

    await reference.putData(
      await pickedFile!.readAsBytes(),
      SettableMetadata(contentType: 'image/jpeg'),
    );
    String value = await reference.getDownloadURL();
    downloadUrl.value = value;
  }

  showModal(BuildContext context) {
    return showModalBottomSheet(
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
                    await pickPhotoFromGallery(ImageSource.camera);
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
                    await pickPhotoFromGallery(ImageSource.gallery);
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
  }
}
