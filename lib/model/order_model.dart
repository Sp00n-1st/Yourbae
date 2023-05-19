import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  String uidUser, alamat, buktiBayar;
  List<String> idProduct;
  List<int> qty, size;
  List<num> subTotal;
  int time;
  num totalTagihan, ongkosKirim;
  bool isPay;
  Timestamp timeStamp;
  OrderModel(
      {required this.uidUser,
      required this.alamat,
      required this.buktiBayar,
      required this.size,
      required this.idProduct,
      required this.qty,
      required this.isPay,
      required this.time,
      required this.subTotal,
      required this.ongkosKirim,
      required this.totalTagihan,
      required this.timeStamp});

  OrderModel.fromJson(Map<String, dynamic>? json)
      : this(
          uidUser: json!['uidUser'] as String,
          alamat: json['alamat'] as String,
          buktiBayar: json['buktiBayar'] as String,
          isPay: json['isPay'] as bool,
          idProduct: (json['idProduct'] as List).cast<String>(),
          qty: (json['qty'] as List).cast<int>(),
          size: (json['size'] as List).cast<int>(),
          time: json['time'] as int,
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
      'idProduct': idProduct,
      'qty': qty,
      'size': size,
      'time': time,
      'subTotal': subTotal,
      'totalTagihan': totalTagihan,
      'ongkosKirim': ongkosKirim,
      'timeStamp': timeStamp
    };
  }
}
