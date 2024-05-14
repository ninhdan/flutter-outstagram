import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';
import 'package:instagram_flutter/models/post.dart';
import 'package:instagram_flutter/models/user.dart';
import 'package:instagram_flutter/services/postservice.dart';
import 'package:instagram_flutter/utils/global.dart';
import 'package:instagram_flutter/views/Individual_reels_screen.dart';
import 'package:instagram_flutter/views/widgets/gallery_screen.dart';
import 'package:instagram_flutter/views/widgets/profile_header_widget.dart';
import 'package:instagram_flutter/views/widgets/slide_widget.dart';

class ProfileScreen extends StatefulWidget {
  late User user;
  ProfileScreen({required this.user});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late List<Post> posts = [];
  late bool isCurrentUser = false;

  @override
  void initState() {
    super.initState();
    isCurrentUser = Global.user?.id == widget.user.id;
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    List<Post> fetchedPosts =
        await PostService().getAllPostOfUser(widget.user.id);
    setState(() {
      posts = fetchedPosts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(44),
        child: SizedBox(
          height: 100,
          child: Container(
            child: AppBar(
              backgroundColor: Colors.white,
              title: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0), // Điều chỉnh khoảng cách theo nhu cầu của bạn
                    child: const Icon(
                      Icons.lock_outline,
                      color: Colors.black,
                      size: 20,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: Text(
                      isCurrentUser == true
                          ? widget.user.username
                          : "Your Profile",
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 24,
                      ),
                    ),
                  ),
                ],
              ),
              centerTitle: false,
              elevation: 0,
              actions: [
                IconButton(
                  icon: Image.asset("assets/images/Add.png"),
                  onPressed: () {},
                  tooltip: "Add",
                ),
                Builder(
                  builder: (context) => IconButton(
                    icon:
                        const Icon(FontAwesomeIcons.bars, color: Colors.black),
                    onPressed: () => Scaffold.of(context).openEndDrawer(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      endDrawer: Slide(widget.user),
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (context, _) {
            return [
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    profileHeaderWidget(context, widget.user),
                  ],
                ),
              ),
            ];
          },
          body: Column(
            children: <Widget>[
              //color: Colors.white,
              TabBar.secondary(
                unselectedLabelColor: Colors.grey,
                labelColor: Colors.black,
                indicatorColor: Colors.black,
                tabs: [
                  const Tab(
                    icon: Icon(
                      Icons.grid_view_rounded,
                      size: 30,
                    ),
                  ),
                  Builder(
                    builder: (BuildContext context) {
                      return const Tab(
                        icon: Icon(
                          FontAwesomeIcons.clapperboard,
                        ),
                      );
                    },
                  ),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    Gallery(posts: posts, user: widget.user),
                    IndividualReels(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
