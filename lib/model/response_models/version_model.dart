class AppVersionModel {
  final int id;
  final String number;
  final String file_path;
  final String published_at;
  final int is_release;
  final int force_update;
  final String size;

  AppVersionModel({
    required this.id,
    required this.number,
    required this.file_path,
    required this.published_at,
    required this.is_release,
    required this.force_update,
    required this.size,
  });

  factory AppVersionModel.fromMap(Map<String, dynamic> map) {
    return AppVersionModel(
      id: map['id'],
      number: map['number'],
      file_path: map['file_path'],
      published_at: map['published_at'] ?? "",
      is_release: map['is_release'],
      force_update: map['force_update'],
      size: map['size'],
    );
  }
}
