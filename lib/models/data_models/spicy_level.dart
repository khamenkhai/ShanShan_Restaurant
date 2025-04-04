class SpicyLevelModel {
  final int? id;
  final String? name;
  final String? description;
  final int? position;

  SpicyLevelModel({
    this.id,
    this.name,
    this.description,
    this.position,
  });

  factory SpicyLevelModel.fromMap(Map<String, dynamic> map) {
    return SpicyLevelModel(
      id: map["id"] ?? 0,
      name: map["name"] ?? "",
      description: map["description"] ?? "",
      position: map["position"] ?? 0,
    );
  }

  toJson() {
    return {
      "id": id,
      "name": name,
      "description": description,
    };
  }
}
