import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:instagram_flutter/views/Individual_reels_screen.dart';
import 'package:instagram_flutter/views/gallery_screen.dart';
import 'package:instagram_flutter/views/images_video_screen.dart';
import 'package:instagram_flutter/views/widgets/profile_header_widget.dart';
import 'package:instagram_flutter/views/widgets/slide_widget.dart';

void main() {
  runApp(ProfileApp());
}

class ProfileApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profile Screen',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ProfileScreen(),
    );
  }
}

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
              title: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text(
                  "john.doe",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontSize: 26,
                  ),
                ),
              ),
              centerTitle: false,
              elevation: 0,
              actions: [
                IconButton(
                  icon: Image.asset("assets/images/Add.png"),
                  onPressed: () {
                    // Your onPressed functionality here
                    print("Add button pressed");
                  },
                  tooltip: "Add",
                ),
                Builder(
                  builder: (context) => IconButton(
                    icon: Icon(FontAwesomeIcons.bars, color: Colors.black),
                    onPressed: () => Scaffold.of(context).openEndDrawer(),
                  ),
                )
              ],
            ),

          ),

        ),
      ),
      endDrawer: Slide(), // Use Slide directly here

      body: DefaultTabController(
        length: 3,
        child: NestedScrollView(
          headerSliverBuilder: (context, _) {
            return [
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    profileHeaderWidget(context),
                  ],
                ),
              ),
            ];
          },
          body: Column(
            children: <Widget>[
              Material(
                color: Colors.white,
                child: TabBar(
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.grey[400],
                  indicatorWeight: 1,
                  indicatorColor: Colors.black,
                  tabs: [
                    Tab(
                      icon: Icon(
                        Icons.grid_on_sharp,
                        color: Colors.black,
                      ),
                    ),
                    Tab(
                      icon: Image.asset(
                        'assets/images/UserTuong.png',
                        height: 30,
                        width: 30,
                      ),
                    ),
                    Tab(
                      icon: Image.asset(
                        'assets/images/Reels.png',
                        height: 25,
                        width: 25,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    Gallery(),
                    ImagesVideo(),
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
