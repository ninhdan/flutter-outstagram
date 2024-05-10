class User {
  String userid;
  String name;
  String? phone;
  String? email;
  String userName;
  String password;
  String? avatar;
  String? bio;
  String? pronouns;
  bool gender;
  bool role;
  bool active;
  DateTime birthDate;
  DateTime createdAt;
  DateTime updatedAt;


  User({
    required this.userid,
    required this.name,
    required this.userName,
    required this.password,
    required this.birthDate,
    required this.createdAt,
    required this.updatedAt,
    required this.role,
    required this.active,
    required this.gender,
    required this.phone,
    required this.email,
    this.avatar,
    this.bio,
    this.pronouns,
    });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userid: json['userid'],
      name: json['name'],
      phone: json['phone'],
      email: json['email'],
      userName: json['username'],
      password: json['password'],
      avatar: json['avatar'],
      bio: json['bio'],
      pronouns: json['pronouns'],
      role: json['role'],
      active: json['active'],
      gender: json['gender'],
      birthDate: DateTime.parse(json['birthdate']),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),

    );
  }

  Map<String, dynamic>toJson()=>{
    'userid': userid,
    'name': name,
    'phone': phone,
    'email': email,
    'username': userName,
    'password': password,
    'avatar': avatar,
    'bio': bio,
    'pronouns': pronouns,
    'role': role,
    'active': active,
    'gender': gender,
    'birthdate': birthDate.toIso8601String(),
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String()
  };

}
