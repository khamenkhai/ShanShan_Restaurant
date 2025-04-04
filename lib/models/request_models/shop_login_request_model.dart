class ShopLoginRequest {
  String username;
  String password;

  ShopLoginRequest({required this.username, required this.password});

  toJson() {
    return {
      "username": username,
      "password": password,
    };
  }
}
