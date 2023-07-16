import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oktoast/oktoast.dart';
import '../model/product_model.dart';
import '../model/rating_model.dart';
import '../model/user_model.dart';
import '../model/wishlist_model.dart';
import '../model/store.dart';

class FirebaseController extends GetxController {
  final firebase = FirebaseFirestore.instance;
  var isLoading = false.obs;
  User? user = FirebaseAuth.instance.currentUser;
  final auth = FirebaseAuth.instance.currentUser!.uid;

  void addRating(
      String idProduct, double star, String comment, int size) async {
    final ratingRef = firebase.collection('rating');
    await ratingRef
        .add(({
          'idProduct': idProduct,
          'size': size,
          'uidUser': user!.uid,
          'star': star,
          'comment': comment,
          'createdAt': DateTime.now()
        }))
        .then((value) => {isLoading.value = false});
  }

  Query<Product> queryProduct() {
    return firebase.collection('product').withConverter<Product>(
        fromFirestore: (snapshot, _) => Product.fromJson(snapshot.data()),
        toFirestore: (product, _) => product.toJson());
  }

  Query<RatingModel> queryRating() {
    return firebase.collection('rating').withConverter<RatingModel>(
        fromFirestore: (snapshot, _) => RatingModel.fromJson(snapshot.data()),
        toFirestore: (ratingModel, _) => ratingModel.toJson());
  }

  DocumentReference<UserModel> queryUser() {
    return firebase.collection('user').doc(auth).withConverter<UserModel>(
        fromFirestore: (snapshot, _) => UserModel.fromJson(snapshot.data()),
        toFirestore: (users, _) => users.toJson());
  }

  DocumentReference<Product> querySingleProduct(String id) {
    return firebase.collection('product').doc(id).withConverter<Product>(
        fromFirestore: (snapshot, _) => Product.fromJson(snapshot.data()),
        toFirestore: (product, _) => product.toJson());
  }

  Query<WishlistModel> queryWishlist() {
    return firebase
        .collection('wishlist')
        .where('uidUser', isEqualTo: auth)
        .withConverter<WishlistModel>(
            fromFirestore: (snapshot, _) =>
                WishlistModel.fromJson(snapshot.data()),
            toFirestore: (wishlist, _) => wishlist.toJson());
  }

  DocumentReference<Store> queryStore() {
    return firebase.collection('store').doc('yourbae').withConverter<Store>(
        fromFirestore: (snapshot, _) => Store.fromJson(snapshot.data()),
        toFirestore: (store, _) => store.toJson());
  }

  Future addWishList(List<QueryDocumentSnapshot<WishlistModel>> listWishList,
      String id) async {
    String? idWishList;
    bool isExist = true;
    CollectionReference ref = firebase.collection('wishlist');
    for (QueryDocumentSnapshot<WishlistModel> documentSnapshot
        in listWishList) {
      WishlistModel data = documentSnapshot.data();
      if (data.idProduct == id) {
        idWishList = documentSnapshot.id;
        isExist = false;
      }
    }
    if (isExist) {
      await ref.add(({'uidUser': auth, 'idProduct': id})).then((value) => {
            showToast('Item Berhasil Ditambahkan Ke WishList',
                textStyle: GoogleFonts.poppins(color: Colors.white),
                position: const ToastPosition(align: Alignment.bottomCenter))
          });
    } else {
      await ref.doc(idWishList).delete().then((value) => {
            showToast('Item Berhasil Dihapus Dari WishList',
                textStyle: GoogleFonts.poppins(color: Colors.white),
                position: const ToastPosition(align: Alignment.bottomCenter))
          });
    }
  }
}
