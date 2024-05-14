import 'package:flutter/material.dart';
import 'package:instagram_flutter/models/post.dart';

class Gallery extends StatefulWidget {
  final List<Post> posts;
  const Gallery({Key? key, required this.posts}) : super(key: key);
  @override
  _GalleryState createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  late OverlayEntry _popupDialog;



  final List<String> imageUrls = [
    'https://thuelens.com/wp-content/uploads/2020/08/iStock-517188688.jpg',
    'https://thuelens.com/wp-content/uploads/2020/08/iStock-517188688.jpg',
    'https://thuelens.com/wp-content/uploads/2020/08/iStock-517188688.jpg',
    'https://thuelens.com/wp-content/uploads/2020/08/iStock-517188688.jpg',
    'https://thuelens.com/wp-content/uploads/2020/08/iStock-517188688.jpg',
    'https://thuelens.com/wp-content/uploads/2020/08/iStock-517188688.jpg',
    'https://thuelens.com/wp-content/uploads/2020/08/iStock-517188688.jpg',
    'https://thuelens.com/wp-content/uploads/2020/08/iStock-517188688.jpg',
    'https://thuelens.com/wp-content/uploads/2020/08/iStock-517188688.jpg',
    'https://thuelens.com/wp-content/uploads/2020/08/iStock-517188688.jpg',
    'https://thuelens.com/wp-content/uploads/2020/08/iStock-517188688.jpg',
    'https://thuelens.com/wp-content/uploads/2020/08/iStock-517188688.jpg',
    'https://thuelens.com/wp-content/uploads/2020/08/iStock-517188688.jpg',
    'https://thuelens.com/wp-content/uploads/2020/08/iStock-517188688.jpg',
    'https://thuelens.com/wp-content/uploads/2020/08/iStock-517188688.jpg',
    'https://thuelens.com/wp-content/uploads/2020/08/iStock-517188688.jpg',
    'https://thuelens.com/wp-content/uploads/2020/08/iStock-517188688.jpg',
  ];

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
      return GestureDetector(
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
        leading: CircleAvatar(
          backgroundImage: NetworkImage('https://thuelens.com/wp-content/uploads/2020/08/iStock-517188688.jpg'),
        ),
        title: Text(
          'john.doe',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
      ));

  Widget _createActionBar() => Container(
    padding: EdgeInsets.symmetric(vertical: 10.0),
    color: Colors.white,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Icon(
          Icons.favorite_border,
          color: Colors.black,
        ),
        Icon(
          Icons.chat_bubble_outline_outlined,
          color: Colors.black,
        ),
        Icon(
          Icons.send,
          color: Colors.black,
        ),
      ],
    ),
  );

  Widget _createPopupContent(String url) => Container(
    padding: EdgeInsets.symmetric(horizontal: 16.0),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _createPhotoTitle(),
          Image.network(url, fit: BoxFit.fitWidth),
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
