import 'package:instagram_flutter/models/images_post.dart';

class Post {
  final String id;
  final String caption;
  final String userId;
  // final bool isHideLike;
  // final bool isHideComment;
  // final bool isActive;
  final List<ImagePost> images;
  final DateTime createdAt;
  // final DateTime updatedAt;
//DateTime? delectedAt;

  Post({
    required this.id,
    required this.caption,
    required this.userId,
    // required this.isHideLike,
    // required this.isHideComment,
    // required this.isActive,
    required this.images,
    required this.createdAt,
    // required this.updatedAt,
    //this.delectedAt,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      caption: json['caption'],
      userId: json['user_id'],
      // isHideLike: json['is_hide_like'],
      // isHideComment: json['is_hide_comment'],
      // isActive: json['is_active'],
      images: (json['post_images'] as List)
          .map((e) => ImagePost.fromJson(e))
          .toList(),
      createdAt: DateTime.parse(json['created_at']),
      //  updatedAt: DateTime.parse(json['updated_at']),
      //delectedAt: DateTime.parse(json['deleted_at']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'caption': caption,
        'user_id': userId,
        // 'is_hide_like': isHideLike,
        // 'is_hide_comment': isHideComment,
        // 'is_active': isActive,
        'post_images': images.map((e) => e.toJson()).toList(),
        'created_at': createdAt,
        // 'updated_at': updatedAt,
        // 'deleted_at': delectedAt,
      };
}
