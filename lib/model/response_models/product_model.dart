class ProductModel {
  final int? id;
  final String? name;
  final int? price;
  final int? categoryId;
  final isGram;
  final int? qty;
  final String? category;
  final bool? isDefault;

  ProductModel({
    this.id,
    this.name,
    this.price,
    this.categoryId,
    this.isGram,
    this.qty,
    this.category,
    this.isDefault,
  });

  factory ProductModel.fromMap(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? "",
      name: json['name'] ?? "",
      price: json['prices'] ?? 0,
      isGram: json['is_gram'] ?? "",
      category: json['category'] ?? "",
      qty: json['qty'] ?? 0,
      isDefault: json['is_default'] ?? false,
      categoryId: json['category_id'] ,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "category_id": categoryId,
      "name": name,
      "qty": qty.toString(),
      "is_gram": isGram,
      "prices": price,
      "is_default": isDefault,
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
      isGram: isGram,
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
