class SaleResponseModel {
  int? userId;
  int? paymentId;
  String? invoiceNumbers;
  DateTime? saleDate;
  num? subTotal;
  num? taxId;
  num? totalDiscount;
  num? grandTotal;
  num? cash;
  num? change;
  num? id;

  SaleResponseModel({
    this.userId,
    this.paymentId,
    this.invoiceNumbers,
    this.saleDate,
    this.subTotal,
    this.taxId,
    this.totalDiscount,
    this.grandTotal,
    this.cash,
    this.change,
    this.id,
  });

  factory SaleResponseModel.fromMap(Map<String, dynamic> json) {
    return SaleResponseModel(
      userId: json['user_id'],
      paymentId: json['payment_id'],
      invoiceNumbers: json['invoice_numbers'],
      saleDate:
          json['sale_date'] != null ? DateTime.parse(json['sale_date']) : null,
      subTotal: json['sub_total'],
      taxId: json['tax_id'],
      totalDiscount: json['total_discount'],
      grandTotal: json['grand_total'],
      cash: json['cash'],
      change: json['change'],
      id: json['id'],
    );
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['payment_id'] = paymentId;
    data['invoice_numbers'] = invoiceNumbers;
    data['sale_date'] = saleDate?.toIso8601String();
    data['sub_total'] = subTotal;
    data['tax_id'] = taxId;
    data['total_discount'] = totalDiscount;
    data['grand_total'] = grandTotal;
    data['cash'] = cash;
    data['change'] = change;
    data['id'] = id;
    return data;
  }
}
