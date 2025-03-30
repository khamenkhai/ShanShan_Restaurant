class SaleModel {
  //int payment_type_id;
  int menu_id;
  int? spicy_level_id;
  int? ahtone_level_id;
  int table_number;
  String order_no;
  int dine_in_or_percel;
  int sub_total;
  int tax;
  int? discount;
  int grand_total;
  int paid_cash;
  int? paid_online;
  int refund;
  List<Product> products;
  final String? remark;
  final int? prawnCount;
  final int? octopusCount;

  SaleModel(
      {
      //required this.payment_type_id,
      required this.menu_id,
      required this.spicy_level_id,
      required this.ahtone_level_id,
      required this.table_number,
      required this.order_no,
      required this.dine_in_or_percel,
      required this.sub_total,
      required this.tax,
      this.discount,
      required this.grand_total,
      required this.paid_cash,
      this.paid_online,
      required this.refund,
      required this.products,
      required this.remark,
      required this.octopusCount,
      required this.prawnCount});

  factory SaleModel.fromJson(Map<String, dynamic> json) {
    return SaleModel(
      menu_id: json['menu_id'],
      spicy_level_id: json['spicy_level_id'],
      ahtone_level_id: json['ahtone_level_id'],
      remark: json['remark'],
      table_number: json['table_number'],
      order_no: json['order_no'],
      dine_in_or_percel: json['dine_in_or_percel'],
      sub_total: json['sub_total'],
      tax: json['tax'],
      discount: json['discount'],
      grand_total: json['grand_total'],
      paid_cash: json['paid_cash'],
      paid_online: json['paid_online'],
      refund: json['refund'],
      //^^^^^^^^^^
      octopusCount: json["octopus_count"],
      prawnCount: json["pawn_count"],

      products: (json['products'] as List)
          .map((item) => Product.fromJson(item))
          .toList(),
    );
  }

  SaleModel copyWith({
    int? menu_id,
    int? spicy_level_id,
    int? ahtone_level_id,
    int? remark_id,
    int? table_number,
    String? order_no,
    int? dine_in_or_percel,
    int? sub_total,
    int? tax,
    int? discount,
    int? grand_total,
    int? paid_cash,
    int? paid_online,
    int? refund,
    List<Product>? products,
    String? remark,
  }) {
    return SaleModel(
        menu_id: menu_id ?? this.menu_id,
        spicy_level_id: spicy_level_id ?? this.spicy_level_id,
        ahtone_level_id: ahtone_level_id ?? this.ahtone_level_id,
        table_number: table_number ?? this.table_number,
        order_no: order_no ?? this.order_no,
        dine_in_or_percel: dine_in_or_percel ?? this.dine_in_or_percel,
        sub_total: sub_total ?? this.sub_total,
        tax: tax ?? this.tax,
        discount: discount ?? this.discount,
        grand_total: grand_total ?? this.grand_total,
        paid_cash: paid_cash ?? this.paid_cash,
        paid_online: paid_online ?? this.paid_online,
        refund: refund ?? this.refund,
        products: products ?? this.products,
        remark: remark ?? this.remark,
        octopusCount: octopusCount ?? this.octopusCount,
        prawnCount: prawnCount ?? this.prawnCount);
  }

  Map<String, dynamic> toMap() {
    return {
      'menu_id': menu_id,
      'spicy_level_id': spicy_level_id,
      'ahtone_level_id': ahtone_level_id,
      'table_number': table_number,
      'order_no': order_no,
      'dine_in_or_percel': dine_in_or_percel,
      'sub_total': sub_total,
      'tax': tax,
      'discount': discount,
      'grand_total': grand_total,
      'paid_cash': paid_cash,
      'paid_online': paid_online,
      'pawn_count': prawnCount ?? 0,
      'octopus_count': octopusCount ?? 0,
      'refund': refund,
      'remark': remark,
      'products': products.map((item) => item.toJson()).toList(),
    };
  }
}

class Product {
  int product_id;
  int qty;
  int price;
  int total_price;
  bool? is_gram;

  Product({
    required this.product_id,
    required this.qty,
    required this.price,
    required this.total_price,
    this.is_gram,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      product_id: json['product_id'],
      qty: json['qty'],
      price: json['price'],
      total_price: json['total_price'],
      is_gram: json['is_gram'] == null
          ? false
          : json["is_gram"] == 0
              ? false
              : json["is_gram"] == 1
                  ? true
                  : false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': product_id,
      'qty': qty,
      'price': price,
      'total_price': total_price,
    };
  }
}
