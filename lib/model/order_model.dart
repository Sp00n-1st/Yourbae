import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  List<String> idProduct;
  List<int> qty, size;
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
      required this.qty,
      required this.isPay,
      required this.isConfirm,
      required this.isRating,
      required this.subTotal,
      required this.ongkosKirim,
      required this.totalTagihan,
      required this.timeStamp});

  OrderModel.fromJson(Map<String, dynamic>? json)
      : this(
          uidUser: json!['uidUser'] as String,
          alamat: json['alamat'] as String,
          buktiBayar: json['buktiBayar'] as String,
          nomorResi: json['nomorResi'] as String,
          isPay: json['isPay'] as bool,
          isConfirm: json['isConfirm'] as bool,
          isRating: (json['isRating'] as List).cast<bool>(),
          idProduct: (json['idProduct'] as List).cast<String>(),
          qty: (json['qty'] as List).cast<int>(),
          size: (json['size'] as List).cast<int>(),
          subTotal: (json['subTotal'] as List).cast<num>(),
          totalTagihan: json['totalTagihan'] as num,
          ongkosKirim: json['ongkosKirim'] as num,
          timeStamp: json['timeStamp'] as Timestamp,
        );
  Map<String, Object?> toJson() {
    return {
      'uidUser': uidUser,
      'alamat': alamat,
      'buktiBayar': buktiBayar,
      'isPay': isPay,
      'isConfirm': isConfirm,
      'isRating': isRating,
      'idProduct': idProduct,
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
