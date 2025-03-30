class SaleTotalModel{
  final num? total_sale_amount;
  final num? total_slip_numbers;

  SaleTotalModel({this.total_sale_amount,this.total_slip_numbers});

  factory SaleTotalModel.fromMap(Map<String,dynamic> map){
    return SaleTotalModel(
      total_sale_amount: map["total_sale_amount"] ?? 0,
      total_slip_numbers: map["total_slip_numbers"] ?? 0,
    );
  }
}