class UserEdit {
  String name;
  String username;
  String bio;
  String avatar;
  DateTime birthday;
  bool gender;

  UserEdit({
    required this.name,
    required this.username,
    required this.bio,
    required this.avatar,
    required this.birthday,
    required this.gender,
  });

  factory UserEdit.empty() {
    return UserEdit(
      name: '',
      username: '',
      bio: '',
      avatar: '',
      birthday: DateTime.now(),
      gender: false,
    );
  }

  factory UserEdit.fromJson(Map<String, dynamic> json) {
    return UserEdit(
        name: json['full_name'],
        username: json['username'],
        bio: json['bio'],
        avatar: json['avatar'],
        birthday: DateTime.parse(json['birthday']),
        gender: json['gender']

    );



  }

  Map<String, dynamic> toJson() {
    return {
      'full_name': name,
      'username': username,
      'bio': bio,
      'avatar': avatar,
      'birthday': birthday.toIso8601String(),
      'gender': gender,

    };
  }



}