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
    data['user_id'] = this.userId;
    data['payment_id'] = this.paymentId;
    data['invoice_numbers'] = this.invoiceNumbers;
    data['sale_date'] = this.saleDate?.toIso8601String();
    data['sub_total'] = this.subTotal;
    data['tax_id'] = this.taxId;
    data['total_discount'] = this.totalDiscount;
    data['grand_total'] = this.grandTotal;
    data['cash'] = this.cash;
    data['change'] = this.change;
    data['id'] = this.id;
    return data;
  }

  // SaleResponseModel copyWith({
  //   int? userId,
  //   int? paymentId,
  //   String? invoiceNumbers,
  //   DateTime? saleDate,
  //   String? subTotal,
  //   int? taxId,
  //   dynamic totalDiscount,
  //   String? grandTotal,
  //   String? cash,
  //   String? change,
  //   DateTime? updatedAt,
  //   DateTime? createdAt,
  //   int? id,
  // }) =>
  //     SaleResponseModel(
  //       userId: userId ?? this.userId,
  //       paymentId: paymentId ?? this.paymentId,
  //       invoiceNumbers: invoiceNumbers ?? this.invoiceNumbers,
  //       saleDate: saleDate ?? this.saleDate,
  //       subTotal: subTotal ?? this.subTotal,
  //       taxId: taxId ?? this.taxId,
  //       totalDiscount: totalDiscount ?? this.totalDiscount,
  //       grandTotal: grandTotal ?? this.grandTotal,
  //       cash: cash ?? this.cash,
  //       change: change ?? this.change,
  //       id: id ?? this.id,
  //     );

}
// class SaleResponseModel {
//   int? userId;
//   int? paymentId;
//   String? invoiceNumbers;
//   DateTime? saleDate;
//   String? subTotal;
//   int? taxId;
//   dynamic totalDiscount;
//   String? grandTotal;
//   String? cash;
//   String? change;
//   int? id;

//   SaleResponseModel({
//     this.userId,
//     this.paymentId,
//     this.invoiceNumbers,
//     this.saleDate,
//     this.subTotal,
//     this.taxId,
//     this.totalDiscount,
//     this.grandTotal,
//     this.cash,
//     this.change,
//     this.id,
//   });

//   factory SaleResponseModel.fromMap(Map<String, dynamic> json) {
    
//     return SaleResponseModel(
//       userId: json['user_id'],
//       paymentId: json['payment_id'],
//       invoiceNumbers: json['invoice_numbers'],
//       saleDate:
//           json['sale_date'] != null ? DateTime.parse(json['sale_date']) : null,
//       subTotal: json['sub_total'],
//       taxId: json['tax_id'],
//       totalDiscount: json['total_discount'],
//       grandTotal: json['grand_total'],
//       cash: json['cash'],
//       change: json['change'],
//       id: json['id'],
//     );
//   }

//   Map<String, dynamic> toMap() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['user_id'] = this.userId;
//     data['payment_id'] = this.paymentId;
//     data['invoice_numbers'] = this.invoiceNumbers;
//     data['sale_date'] = this.saleDate?.toIso8601String();
//     data['sub_total'] = this.subTotal;
//     data['tax_id'] = this.taxId;
//     data['total_discount'] = this.totalDiscount;
//     data['grand_total'] = this.grandTotal;
//     data['cash'] = this.cash;
//     data['change'] = this.change;
//     data['id'] = this.id;
//     return data;
//   }

//   SaleResponseModel copyWith({
//     int? userId,
//     int? paymentId,
//     String? invoiceNumbers,
//     DateTime? saleDate,
//     String? subTotal,
//     int? taxId,
//     dynamic totalDiscount,
//     String? grandTotal,
//     String? cash,
//     String? change,
//     DateTime? updatedAt,
//     DateTime? createdAt,
//     int? id,
//   }) =>
//       SaleResponseModel(
//         userId: userId ?? this.userId,
//         paymentId: paymentId ?? this.paymentId,
//         invoiceNumbers: invoiceNumbers ?? this.invoiceNumbers,
//         saleDate: saleDate ?? this.saleDate,
//         subTotal: subTotal ?? this.subTotal,
//         taxId: taxId ?? this.taxId,
//         totalDiscount: totalDiscount ?? this.totalDiscount,
//         grandTotal: grandTotal ?? this.grandTotal,
//         cash: cash ?? this.cash,
//         change: change ?? this.change,
//         id: id ?? this.id,
//       );
// }
