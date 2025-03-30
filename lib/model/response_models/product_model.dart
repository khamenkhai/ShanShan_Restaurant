class ProductModel {
  final int? id;
  final String? name;
  final int? price;
  final int? category_id;
  final is_gram;
  final int? qty;
  final String? category;
  final bool? is_default;

  ProductModel({
    this.id,
    this.name,
    this.price,
    this.category_id,
    this.is_gram,
    this.qty,
    this.category,
    this.is_default,
  });

  factory ProductModel.fromMap(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? "",
      name: json['name'] ?? "",
      price: json['prices'] ?? 0,
      is_gram: json['is_gram'] ?? "",
      category: json['category'] ?? "",
      qty: json['qty'] ?? 0,
      is_default: json['is_default'] ?? false,
      category_id: json['category_id'] ,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "category_id": category_id,
      "name": name,
      "qty": qty.toString(),
      "is_gram": is_gram,
      "prices": price,
      "is_default": is_default,
    };
  }

  ProductModel copyWith({
    int? id,
    String? name,
    int? price,
    List<ProductImage>? productImages,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      is_gram: is_gram,
    );
  }
}

class ProductImage {
  final int? id;
  final int? productId;
  final String? filePath;

  ProductImage({
    this.id,
    this.productId,
    this.filePath,
  });

  factory ProductImage.fromMap(Map<String, dynamic> json) {
    return ProductImage(
      id: json['id'],
      productId: json['product_id'],
      filePath: json['file_path'],
    );
  }
}
