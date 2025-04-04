class SaleTotalModel{
  final num? totalSaleAmount;
  final num? totalSlipNumber;

  SaleTotalModel({this.totalSaleAmount,this.totalSlipNumber});

  factory SaleTotalModel.fromMap(Map<String,dynamic> map){
    return SaleTotalModel(
      totalSaleAmount: map["totalSaleAmount"] ?? 0,
      totalSlipNumber: map["totalSlipNumber"] ?? 0,
    );
  }
}