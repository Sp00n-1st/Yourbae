class WishlistModel {
  final String idProduct;
  final String uidUser;

  WishlistModel({required this.idProduct, required this.uidUser});

  WishlistModel.fromJson(Map<String, dynamic>? json)
      : this(
          idProduct: (json!['id_product'] as String),
          uidUser: (json['uid_user'] as String),
        );

  Map<String, Object?> toJson() {
    return {'idProduct': idProduct, 'uidUser': uidUser};
  }
}
