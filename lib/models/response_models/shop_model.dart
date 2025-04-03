class ShopModel {
  final int? id;
  final String username;
  final String email;
  final String accessToken;

  ShopModel({
    this.id,
    required this.username,
    required this.email,
    required this.accessToken,
  });

  // Factory constructor to create a ShopModel instance from a map
  factory ShopModel.fromMap(Map<String, dynamic> map) {
    return ShopModel(
      id: map['id'],
      username: map['username'] ?? "",
      email: map['email'] ?? "",
      accessToken: map['access_token'] ?? "",
    );
  }

  // Method to convert a ShopModel instance to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'access_token': accessToken,
    };
  }
}
