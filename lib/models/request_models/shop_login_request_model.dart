class ShopLoginRequest {
  String username;
  String password;

  ShopLoginRequest({required this.username, required this.password});

  toMap() {
    return {"username": this.username, "password": this.password};
  }
}
