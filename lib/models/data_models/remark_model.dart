class RemarkModel {
  final int? id;
  final String? name;
  final String? description;

  RemarkModel({this.id, this.name, this.description});

  factory RemarkModel.fromMap(Map<String, dynamic> map) {
    return RemarkModel(
      id: map["id"] ?? 0,
      name: map["name"] ?? "",
      description: map["description"] ?? "",
    );
  }

  toMap() {
    return {
      "id": id,
      "name": name,
      "description": description,
    };
  }
}
