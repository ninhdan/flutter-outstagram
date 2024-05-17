class CommentPost {

  final String id;
  final String content;
  final DateTime createdAt;
  final String userId;
  final String userName;
  final String fullName;
  final String avatar;

  CommentPost({
    required this.id,
    required this.content,
    required this.createdAt,
    required this.userId,
    required this.userName,
    required this.fullName,
    required this.avatar,
  });


  factory CommentPost.empty() {
    return CommentPost(
      id: '',
      content: '',
      createdAt: DateTime.now(),
      userId: '',
      userName: '',
      fullName: '',
      avatar: '',
    );
  }


  factory CommentPost.fromJson(Map<String, dynamic> json) {
    return CommentPost(
      id: json['id'],
      content: json['content'],
      createdAt: DateTime.parse(json['created_at']),
      userId: json['user']['user_id'],
      userName: json['user']['username'],
      fullName:json ['user']['full_name'],
      avatar: json['user']['avatar'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'content': content,
    'created_at': createdAt,
    'user_id': userId,
    'username': userName,
    'full_name': fullName,
    'avatar': avatar,
  };


}