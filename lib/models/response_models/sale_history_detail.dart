import 'package:shan_shan/models/response_models/cart_item_model.dart';

class SaleHistoryDetail {
  int? userId;
  String? userName;
  int? paymentId;
  String? paymentType;
  String? invoiceNumbers;
  String? saleDate;
  String? subTotal;
  int? taxId;
  int? totalDiscount;
  String? grandTotal;
  String? cash;
  String? change;
  List<CartItem>? products;

  SaleHistoryDetail({
    this.userId,
    this.userName,
    this.paymentId,
    this.paymentType,
    this.invoiceNumbers,
    this.saleDate,
    this.subTotal,
    this.taxId,
    this.totalDiscount,
    this.grandTotal,
    this.cash,
    this.change,
    this.products,
  });

  factory SaleHistoryDetail.fromMap(Map<String, dynamic> map) {
    List<CartItem>? productItems;
    if (map['products'] != null) {
      productItems = <CartItem>[];
      map['products'].forEach((v) {
        productItems!.add(CartItem.fromMap(v));
      });
    }

    return SaleHistoryDetail(
      userId: map['user_id'],
      userName: map['user_name'] ?? "",
      paymentId: map['payment_id'],
      paymentType: map['payment_type'],
      invoiceNumbers: map['invoice_numbers'],
      saleDate: map['sale_date'],
      subTotal: map['sub-total'],
      taxId: map['tax_id'],
      totalDiscount: map['total_discount'],
      grandTotal: map['grand_total'],
      cash: map['cash'],
      change: map['change'],
      products: productItems,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['user_name'] = userName;
    data['payment_id'] = paymentId;
    data['payment_type'] = paymentType;
    data['invoice_numbers'] = invoiceNumbers;
    data['sale_date'] = saleDate;
    data['sub-total'] = subTotal;
    data['tax_id'] = taxId;
    data['total_discount'] = totalDiscount;
    data['grand_total'] = grandTotal;
    data['cash'] = cash;
    data['change'] = change;
    if (products != null) {
      data['products'] = products!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
