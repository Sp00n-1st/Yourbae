class WishlistModel {
  String idProduct;
  String uidUser;

  WishlistModel({required this.idProduct, required this.uidUser});

  WishlistModel.fromJson(Map<String, dynamic>? json)
      : this(
          idProduct: (json!['idProduct'] as String),
          uidUser: (json['uidUser'] as String),
        );
  Map<String, Object?> toJson() {
    return {'idProduct': idProduct, 'uidUser': uidUser};
  }
}
