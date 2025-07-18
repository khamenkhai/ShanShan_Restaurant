class SaleModel {
  final int menuId;
  final int? spicyLevelId;
  final int? ahtoneLevelId;
  final int tableNumber;
  final String orderNo;
  final int dineInOrParcel;
  final int subTotal;
  final int tax;
  final int discount;
  final int grandTotal;
  int paidCash;
  int paidOnline;
  final int refund;
  final List<Product> products;
  final String remark;
  final int prawnCount;
  final int octopusCount;

  SaleModel({
    required this.menuId,
    required this.spicyLevelId,
    required this.ahtoneLevelId,
    required this.tableNumber,
    required this.orderNo,
    required this.dineInOrParcel,
    required this.subTotal,
    required this.tax,
    required this.discount,
    required this.grandTotal,
    required this.paidCash,
    required this.paidOnline,
    required this.refund,
    required this.products,
    required this.remark,
    required this.octopusCount,
    required this.prawnCount,
  });

  factory SaleModel.fromJson(Map<String, dynamic> json) => SaleModel(
        menuId: json['menu_id'],
        spicyLevelId: json['spicy_level_id'],
        ahtoneLevelId: json['ahtone_level_id'],
        remark: json['remark'],
        tableNumber: json['tableNo'],
        orderNo: json['order_no'],
        dineInOrParcel: json['dine_in_or_percel'],
        subTotal: json['sub_total'],
        tax: json['tax'],
        discount: json['discount'],
        grandTotal: json['grand_total'],
        paidCash: json['paid_cash'],
        paidOnline: json['paid_online'],
        refund: json['refund'],
        octopusCount: json['octopus_count'],
        prawnCount: json['pawn_count'],
        products: (json['products'] as List)
            .map((item) => Product.fromJson(item))
            .toList(),
      );

  SaleModel copyWith({
    int? menuId,
    int? spicyLevelId,
    int? ahtoneLevelId,
    int? tableNumber,
    String? orderNo,
    int? dineInOrParcel,
    int? subTotal,
    int? tax,
    int? discount,
    int? grandTotal,
    int? paidCash,
    int? paidOnline,
    int? refund,
    List<Product>? products,
    String? remark,
    int? octopusCount,
    int? prawnCount,
  }) {
    return SaleModel(
      menuId: menuId ?? this.menuId,
      spicyLevelId: spicyLevelId ?? this.spicyLevelId,
      ahtoneLevelId: ahtoneLevelId ?? this.ahtoneLevelId,
      tableNumber: tableNumber ?? this.tableNumber,
      orderNo: orderNo ?? this.orderNo,
      dineInOrParcel: dineInOrParcel ?? this.dineInOrParcel,
      subTotal: subTotal ?? this.subTotal,
      tax: tax ?? this.tax,
      discount: discount ?? this.discount,
      grandTotal: grandTotal ?? this.grandTotal,
      paidCash: paidCash ?? this.paidCash,
      paidOnline: paidOnline ?? this.paidOnline,
      refund: refund ?? this.refund,
      products: products ?? this.products,
      remark: remark ?? this.remark,
      octopusCount: octopusCount ?? this.octopusCount,
      prawnCount: prawnCount ?? this.prawnCount,
    );
  }

  Map<String, dynamic> toJson() => {
        'menu_id': menuId,
        'spicy_level_id': spicyLevelId,
        'ahtone_level_id': ahtoneLevelId,
        'tableNo': tableNumber,
        'order_no': orderNo,
        'dine_in_or_percel': dineInOrParcel,
        'sub_total': subTotal,
        'tax': tax,
        'discount': discount,
        'grand_total': grandTotal,
        'paid_cash': paidCash,
        'paid_online': paidOnline,
        'pawn_count': prawnCount,
        'octopus_count': octopusCount,
        'refund': refund,
        'remark': remark,
        'products': products.map((item) => item.toJson()).toList(),
      };
}

class Product {
  final int productId;
  final int qty;
  final int price;
  final int totalPrice;
  final bool isGram;

  const Product({
    required this.productId,
    required this.qty,
    required this.price,
    required this.totalPrice,
    this.isGram = false,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        productId: json['product_id'],
        qty: json['qty'],
        price: json['price'],
        totalPrice: json['total_price'],
        isGram: json['is_gram'] == 1,
      );

  Map<String, dynamic> toJson() => {
        'product_id': productId,
        'qty': qty,
        'price': price,
        'total_price': totalPrice,
        'is_gram': isGram ? 1 : 0,
      };
}
