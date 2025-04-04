class CartItem {
  int id;
  String name;
  int price;
  int qty;
  int totalPrice;
  bool isGram;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.qty,
    required this.totalPrice,
    required this.isGram,
  });

  toJson() {
    return {
      "id": id,
      "name": name,
      "price": price,
      "qty": qty,
      "total_price": totalPrice
    };
  }

  toTransfer() {
    return {
      "name": name,
      "price": price,
      "qty": qty,
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      id: map["id"],
      name: map["name"],
      price: map["price"],
      qty: map["quantity"] ?? 0,
      totalPrice: map["total_price"] ?? "0",
      isGram: map["isGram"],
    );
  }

  CartItem copyWith({
    int? id,
    String? name,
    int? price,
    int? qty,
    int? totalPrice,
  }) =>
      CartItem(
        id: id ?? this.id,
        name: name ?? this.name,
        price: price ?? this.price,
        qty: qty ?? this.qty,
        totalPrice: totalPrice ?? this.totalPrice,
        isGram: isGram,
      );
}


