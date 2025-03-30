class MenuModel{
  final  id;
  final String? name;
  final bool? is_fish;

  MenuModel({this.id, this.name,required this.is_fish});

  factory MenuModel.fromMap(Map<String,dynamic> map){
    return MenuModel(
      id: map["id"] ?? 0,
      name: map["name"] ?? "",
      is_fish: map["is_fish"] ?? false,
    );
  }
}


