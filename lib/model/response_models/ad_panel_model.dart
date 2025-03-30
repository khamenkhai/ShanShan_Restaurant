class AdPanelModel {
  final int? id;
  final String? img_path;

  AdPanelModel({
    this.id,
    this.img_path,
  });

  factory AdPanelModel.fromMap(Map<String, dynamic> map) {
    return AdPanelModel(
      id: map["id"] ?? 0,
      img_path: map["img_path"] ?? "",
    );
  }
}
