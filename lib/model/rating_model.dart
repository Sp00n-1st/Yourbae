import 'package:cloud_firestore/cloud_firestore.dart';

class RatingModel {
  final String comment, idProduct, uidUser;
  final Timestamp createdAt;
  final int size;
  final double star;

  RatingModel(
      {required this.comment,
      required this.createdAt,
      required this.idProduct,
      required this.size,
      required this.star,
      required this.uidUser});

  RatingModel.fromJson(Map<String, dynamic>? json)
      : this(
            comment: json!['comment'] as String,
            createdAt: json['createdAt'] as Timestamp,
            idProduct: json['idProduct'] as String,
            uidUser: json['uidUser'] as String,
            size: json['size'] as int,
            star: json['star'] as double);

  Map<String, Object?> toJson() {
    return {
      'comment': comment,
      'createdAt': createdAt,
      'idProduct': idProduct,
      'uidUser': uidUser,
      'size': size,
      'star': star
    };
  }
}
