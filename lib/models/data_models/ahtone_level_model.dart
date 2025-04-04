class AhtoneLevelModel {
  final int? id;
  final String? name;
  final String? description;
  final int? position;

  AhtoneLevelModel({this.id, this.name, this.description,this.position});

  factory AhtoneLevelModel.fromMap( Map<String, dynamic> map) {
    return AhtoneLevelModel(
      id: map["id"] ?? 0,
      name: map["name"] ?? "",
      description: map["description"] ?? "",
      position: map["position"] ?? "",
    );
  }

  toJson() {
    return {
      "id": id,
      "name": name,
      "description": description,
      "position": position,
    };
  }
}
