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
            uidUser: json!['uidUser'] as String,
            idProduct: (json['idProduct'] as List).cast<String>(),
            qty: (json['qty'] as List).cast<int>(),
            size: (json['size'] as List).cast<int>(),
            isCheckout: json['isCheckout'] as bool,
            isPay: json['isPay'] as bool,
            time: json['time'] as int,
            subTotal: (json['subTotal'] as List).cast<num>());
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
