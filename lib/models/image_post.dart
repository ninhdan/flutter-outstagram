class ImagePost {
  final String id;
  final String postId;
  final String url;
  // final DateTime createdAt;
  // final DateTime updatedAt;
//DateTime? delectedAt;

  ImagePost({
    required this.id,
    required this.postId,
    required this.url,
    // required this.createdAt,
    // required this.updatedAt,
    //this.delectedAt,
  });

  factory ImagePost.fromJson(Map<String, dynamic> json) {
    return ImagePost(
      id: json['id'],
      postId: json['post_id'],
      url: json['url'],
      // createdAt: DateTime.parse(json['created_at']),
      // updatedAt: DateTime.parse(json['updated_at']),
      //delectedAt: DateTime.parse(json['deleted_at']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'post_id': postId,
        'url': url,
        // 'created_at': createdAt,
        // 'updated_at': updatedAt,
        // 'deleted_at': delectedAt,
      };
}
