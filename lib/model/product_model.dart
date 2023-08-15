class Product {
  final String nameProduct, descItem, category;
  final List<String> imageUrl;
  final int price, size37, size38, size39, size40, size41, size42;

  Product(
      {required this.nameProduct,
      required this.category,
      required this.imageUrl,
      required this.descItem,
      required this.price,
      required this.size37,
      required this.size38,
      required this.size39,
      required this.size40,
      required this.size41,
      required this.size42});

  Product.fromJson(Map<String, dynamic>? json)
      : this(
          nameProduct: json!['name_product'] as String,
          category: json['category'] as String,
          imageUrl: (json['image_url'] as List).cast<String>(),
          descItem: json['desc_item'] as String,
          price: json['price'] as int,
          size37: json['size37'] as int,
          size38: json['size38'] as int,
          size39: json['size39'] as int,
          size40: json['size40'] as int,
          size41: json['size41'] as int,
          size42: json['size42'] as int,
        );

  Map<String, Object?> toJson() {
    return {
      'namaProduct': nameProduct,
      'category': category,
      'imageUrl': imageUrl,
      'price': price,
      'descItem': descItem,
      'size37': size37,
      'size38': size38,
      'size39': size39,
      'size40': size40,
      'size41': size41,
      'size42': size42,
    };
  }
}
