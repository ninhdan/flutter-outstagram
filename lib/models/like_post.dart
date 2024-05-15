class LikePost {
  final String id;
  final String userId;
  final String postId;
  final bool isLiked;
  final DateTime createdAt;
  final DateTime updatedAt;
  //DateTime? delectedAt;

  LikePost({
    required this.id,
    required this.userId,
    required this.postId,
    required this.isLiked,
    required this.createdAt,
    required this.updatedAt,
    //this.delectedAt,
  });

  factory LikePost.fromJson(Map<String, dynamic> json) {
    return LikePost(
      id: json['id'],
      userId: json['user_id'],
      postId: json['post_id'],
      isLiked: json['is_liked'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      //delectedAt: DateTime.parse(json['deleted_at']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'post_id': postId,
        'is_liked': isLiked,
        'created_at': createdAt,
        'updated_at': updatedAt,
        // 'deleted_at': delectedAt,
      };
}
