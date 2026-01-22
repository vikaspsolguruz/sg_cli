class UserModel {
  String? id;
  String? firstName;
  String? lastName;
  String? email;
  String? status;
  String? token;
  String? googleId;
  String? appleId;
  String? name;

  UserModel({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.status,
    this.token,
    this.googleId,
    this.appleId,
    this.name,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    final userJson = json['user'];
    id = userJson['id'];
    firstName = userJson['first_name'];
    lastName = userJson['last_name'];
    email = userJson['email'];
    status = userJson['status'];
    token = userJson['token'];
    googleId = userJson['google_id'];
    appleId = userJson['apple_id'];
    name = userJson['name'];
  }

  Map<String, dynamic> toJson() {
    return {
      'user': {
        'id': id,
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'status': status,
        'token': token,
        'google_id': googleId,
        'apple_id': appleId,
        'name': name,
      },
    };
  }

  UserModel copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? status,
    String? token,
    String? googleId,
    String? appleId,
    String? name,
  }) {
    return UserModel(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      status: status ?? this.status,
      token: token ?? this.token,
      googleId: googleId ?? this.googleId,
      appleId: appleId ?? this.appleId,
      name: name ?? this.name,
    );
  }

  bool get isSocialLogin => appleId != null || googleId != null;
}
