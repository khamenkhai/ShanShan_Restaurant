class CategoryModel {
  int? id;
  String? name;
  String? description;
  int? status;
  String? remark;

  CategoryModel({
    this.id,
    this.name,
    this.description,
    this.status,
    this.remark,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? "",
      description: json['description'] ?? "",
      status: json['status'] ?? 0,
      remark: json['remark'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'status': status,
      'remark': remark,
    };
  }
}
