import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:instagram_flutter/models/post.dart';
import 'package:instagram_flutter/models/user.dart';
import 'package:instagram_flutter/views/post_screen.dart';

class Gallery extends StatefulWidget {
  final List<Post> posts;
  final User user;
  const Gallery({Key? key, required this.posts, required this.user})
      : super(key: key);
  @override
  _GalleryState createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  late OverlayEntry _popupDialog;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.count(
        crossAxisCount: 3,
        childAspectRatio: 1.0,
        children: widget.posts.map(_createGridTileWidget).toList(),
      ),
    );
  }

  Widget _createGridTileWidget(Post post) => Builder(
        builder: (context) {
          String imageUrl = post.images.first.url;
          String postId = post.id;
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PostScreen(postId: postId),
                ),
              );
            },
            onLongPress: () {
              _popupDialog = _createPopupDialog(imageUrl);
              Overlay.of(context).insert(_popupDialog);
            },
            onLongPressEnd: (details) => _popupDialog?.remove(),
            child: Image.network(imageUrl, fit: BoxFit.cover),
          );
        },
      );

  OverlayEntry _createPopupDialog(String url) {
    return OverlayEntry(
      builder: (context) => AnimatedDialog(
        child: _createPopupContent(url),
      ),
    );
  }

  Widget _createPhotoTitle() => Container(
      width: double.infinity,
      color: Colors.white,
      child: ListTile(
        leading: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.grey.shade500,
              width: 1.5,
            ),
          ),
          child: CircleAvatar(
            radius: 20, // Adjust the radius as needed
            backgroundImage: NetworkImage(
              widget.user.avatar.isEmpty
                  ? 'https://instagram.fixc1-9.fna.fbcdn.net/v/t51.2885-19/44884218_345707102882519_2446069589734326272_n.jpg?_nc_ht=instagram.fixc1-9.fna.fbcdn.net&_nc_cat=1&_nc_ohc=TokSSzUDPVcQ7kNvgGMF0u_&edm=AJ9x6zYBAAAA&ccb=7-5&ig_cache_key=YW5vbnltb3VzX3Byb2ZpbGVfcGlj.2-ccb7-5&oh=00_AYCetGx_2KnUphpAbrzv_kkxLPaX07mcXeJxPNOXkBSYIg&oe=6648F00F&_nc_sid=65462d'
                  : widget.user.avatar,
            ),
          ),
        ),
        title: Text(
          widget.user.username,
          style:
              const TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
      ));

  Widget _createActionBar() => Container(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        color: Colors.white,
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(
              FontAwesomeIcons.heart,
              color: Colors.black87,
            ),
            Icon(
              FontAwesomeIcons.comment,
              color: Colors.black87,
            ),
            Icon(
              FontAwesomeIcons.paperPlane,
              color: Colors.black87,
            ),
            Icon(
              FontAwesomeIcons.ellipsisVertical,
              color: Colors.black87,
            ),
          ],
        ),
      );

  Widget _createPopupContent(String url) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _createPhotoTitle(),
              AspectRatio(
                aspectRatio: 1.0, // Maintains the aspect ratio of 1:1
                child: CachedNetworkImage(
                  imageUrl: url,
                  fit: BoxFit
                      .cover, // Ensures the image covers the area without changing its aspect ratio
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
              _createActionBar(),
            ],
          ),
        ),
      );
}

class AnimatedDialog extends StatefulWidget {
  const AnimatedDialog({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  State<StatefulWidget> createState() => AnimatedDialogState();
}

class AnimatedDialogState extends State<AnimatedDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> opacityAnimation;
  late Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.easeOutExpo);
    opacityAnimation = Tween<double>(begin: 0.0, end: 0.6).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeOutExpo));

    controller.addListener(() => setState(() {}));
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withOpacity(opacityAnimation.value),
      child: Center(
        child: FadeTransition(
          opacity: scaleAnimation,
          child: ScaleTransition(
            scale: scaleAnimation,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
