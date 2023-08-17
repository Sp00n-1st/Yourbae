import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  List<String> productName, idProduct;
  List<int> qty, size, price;
  List<num> subTotal;
  List<bool> isRating;
  String uidUser, alamat, buktiBayar, nomorResi;
  num totalTagihan, ongkosKirim;
  bool isPay, isConfirm;
  Timestamp timeStamp;
  OrderModel(
      {required this.uidUser,
      required this.alamat,
      required this.nomorResi,
      required this.buktiBayar,
      required this.size,
      required this.idProduct,
      required this.productName,
      required this.qty,
      required this.price,
      required this.isPay,
      required this.isConfirm,
      required this.isRating,
      required this.subTotal,
      required this.ongkosKirim,
      required this.totalTagihan,
      required this.timeStamp});

  OrderModel.fromJson(Map<String, dynamic>? json)
      : this(
          uidUser: json!['uid_user'] as String,
          alamat: json['address'] as String,
          buktiBayar: json['proof_of_payment'] as String,
          nomorResi: json['shipping_number'] as String,
          isPay: json['is_pay'] as bool,
          isConfirm: json['is_confirm'] as bool,
          isRating: (json['is_rating'] as List).cast<bool>(),
          productName: (json['product'] as List).cast<String>(),
          idProduct: (json['id_product'] as List).cast<String>(),
          qty: (json['qty'] as List).cast<int>(),
          price: (json['price'] as List).cast<int>(),
          size: (json['size'] as List).cast<int>(),
          subTotal: (json['sub_total'] as List).cast<num>(),
          totalTagihan: json['total'] as num,
          ongkosKirim: json['shipping_cost'] as num,
          timeStamp: json['time_stamp'] as Timestamp,
        );
  Map<String, Object?> toJson() {
    return {
      'uidUser': uidUser,
      'alamat': alamat,
      'buktiBayar': buktiBayar,
      'isPay': isPay,
      'isConfirm': isConfirm,
      'isRating': isRating,
      'productName': productName,
      'idProduct': idProduct,
      'price': price,
      'qty': qty,
      'nomorResi': nomorResi,
      'size': size,
      'subTotal': subTotal,
      'totalTagihan': totalTagihan,
      'ongkosKirim': ongkosKirim,
      'timeStamp': timeStamp
    };
  }
}
