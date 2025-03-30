import 'package:shan_shan/model/response_models/cart_item_model.dart';

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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['user_name'] = this.userName;
    data['payment_id'] = this.paymentId;
    data['payment_type'] = this.paymentType;
    data['invoice_numbers'] = this.invoiceNumbers;
    data['sale_date'] = this.saleDate;
    data['sub-total'] = this.subTotal;
    data['tax_id'] = this.taxId;
    data['total_discount'] = this.totalDiscount;
    data['grand_total'] = this.grandTotal;
    data['cash'] = this.cash;
    data['change'] = this.change;
    if (this.products != null) {
      data['products'] = this.products!.map((v) => v.toMap()).toList();
    }
    return data;
  }
}
