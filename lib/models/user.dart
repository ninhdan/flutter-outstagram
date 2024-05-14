class User {
  String id;
  String username;
  //String password;
  String full_name;
  String phone;
  String email;
  String avatar;
  String bio;
  bool gender;
  bool role;
  bool active;
  DateTime birthday;
  DateTime createdAt;
  DateTime updatedAt;
  //DateTime? delectedAt;
  String token;

  User({
    required this.id,
    required this.full_name,
    required this.username,
    //required this.password,
    required this.birthday,
    required this.createdAt,
    required this.updatedAt,
    required this.role,
    required this.active,
    required this.gender,
    required this.phone,
    required this.email,
    required this.avatar,
    required this.bio,
    //this.delectedAt,
    required this.token,

    });

  factory User.empty() {
    return User(
      id: '',
      full_name: '',
      username: '',
      //password: '',
      birthday: DateTime.now(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      role: false,
      active: false,
      gender: false,
      phone: '',
      email: '',
      avatar: '',
      bio: '',
      token: '',
    );
  }


  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['user']['id'],
      full_name: json['user']['full_name'],
      phone: json['user']['phone'],
      email: json['user']['email'],
      username: json['user']['username'],
      //password: json['user']['_'],
      avatar: json['user']['avatar'],
      bio: json['user']['bio'],
      role: json['user']['role'],
      active: json['user']['active'],
      gender: json['user']['gender'],
      birthday: DateTime.parse(json['user']['birthday']),
      createdAt: DateTime.parse(json['user']['created_at']),
      updatedAt: DateTime.parse(json['user']['updated_at']),
      //delectedAt: DateTime.parse(json['deleted_at']),
      token: json['token'],

    );
  }

  Map<String, dynamic>toJson()=>{
    'id': id,
    'full_name': full_name,
    'phone': phone,
    'email': email,
    'username': username,
    //'_': password,
    'avatar': avatar,
    'bio': bio,
    'role': role,
    'active': active,
    'gender': gender,
    'birthday': birthday.toIso8601String(),
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
    //'deleted_at': delectedAt?.toIso8601String(),
    'token': token,
  };

}
