class CartModel {
  String uidUser;
  int time;
  List<String> idProduct;
  List<int> qty;
  List<int> size;
  List<num> subTotal;
  bool isCheckout, isPay;

  CartModel(
      {required this.uidUser,
      required this.idProduct,
      required this.qty,
      required this.size,
      required this.isCheckout,
      required this.isPay,
      required this.time,
      required this.subTotal});

  CartModel.fromJson(Map<String, dynamic>? json)
      : this(
            uidUser: json!['uid_user'] as String,
            idProduct: (json['id_product'] as List).cast<String>(),
            qty: (json['qty'] as List).cast<int>(),
            size: (json['size'] as List).cast<int>(),
            isCheckout: json['is_checkout'] as bool,
            isPay: json['is_pay'] as bool,
            time: json['time'] as int,
            subTotal: (json['sub_total'] as List).cast<num>());
  Map<String, Object?> toJson() {
    return {
      'uidUser': uidUser,
      'idProduct': idProduct,
      'qty': qty,
      'size': size,
      'isPay': isPay,
      'isCheckout': isCheckout,
      'time': time,
      'subTotal': subTotal
    };
  }
}
