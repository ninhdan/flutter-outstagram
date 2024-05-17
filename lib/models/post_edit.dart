class PostEdit {
  final String postId;
  final String caption;

  PostEdit({
    required this.postId,
    required this.caption,
  });

  factory PostEdit.empty() {
    return PostEdit(
      postId: '',
      caption: '',
    );
  }

  factory PostEdit.fromJson(Map<String, dynamic> json) {
    return PostEdit(
      postId: json['id'],
      caption: json['caption'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': postId,
      'caption': caption,
    };
  }
}