class MenuModel {
  final int id;
  final String? name;
  final bool? isFish;

  MenuModel({required this.id, this.name, required this.isFish});

  factory MenuModel.fromMap(Map<String, dynamic> map) {
    return MenuModel(
      id: map["id"] ?? 0,
      name: map["name"] ?? "",
      isFish: map["is_fish"] ?? false,
    );
  }
}
