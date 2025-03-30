class UserModel {
  String? id;
  String? name;
  String? email;
  String? phone;
  String? password;
  bool? isChanged;
  String? changedDate;
  String? dob;
  String? status;
  String? profilePhoto;

  UserModel({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.password,
    this.isChanged,
    this.changedDate,
    this.dob,
    this.status,
    this.profilePhoto,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      password: json['password'],
      isChanged: json['is_changed'],
      changedDate: json['changed_date'],
      dob: json['dob'],
      status: json['status'],
      profilePhoto: json['profile_photo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'password': password,
      'is_changed': isChanged,
      'changed_date': changedDate,
      'dob': dob,
      'status': status,
      'profile_photo': profilePhoto,
    };
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? password,
    bool? isChanged,
    String? changedDate,
    String? dob,
    String? status,
    String? profilePhoto,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      password: password ?? this.password,
      isChanged: isChanged ?? this.isChanged,
      changedDate: changedDate ?? this.changedDate,
      dob: dob ?? this.dob,
      status: status ?? this.status,
      profilePhoto: profilePhoto ?? this.profilePhoto,
    );
  }
}
