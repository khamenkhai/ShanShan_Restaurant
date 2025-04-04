class TaxModel {
  int id;
  String name;
  String type;
  int? percentage;
  String? amount;

  TaxModel({
    required this.id,
    required this.name,
    required this.type,
    required this.percentage,
    this.amount,
  });

  factory TaxModel.fromMap(Map<String, dynamic> map) {
    return TaxModel(
      id: map['id'],
      name: map['name'] ?? "",
      type: map['type'] ?? "",
      percentage: map['percentage'] ?? 0,
      amount: map['amount']?.toString(),
    );
  }
}
