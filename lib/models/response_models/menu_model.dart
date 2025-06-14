class MenuModel {
  final int id;
  final String? name;

  MenuModel({required this.id, this.name});

  factory MenuModel.fromMap(Map<String, dynamic> map) {
    return MenuModel(
      id: map["id"] ?? 0,
      name: map["name"] ?? "",
    );
  }
}
