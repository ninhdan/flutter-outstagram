import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_flutter/models/user.dart';
import 'package:instagram_flutter/utils/global.dart';
import 'package:instagram_flutter/views/add_posts_screen.dart';
import 'package:instagram_flutter/views/add_screen.dart';
import 'package:instagram_flutter/views/explor_screen.dart';
import 'package:instagram_flutter/views/home.dart';
import 'package:instagram_flutter/views/profile_screen.dart';
import 'package:instagram_flutter/views/reels_screen.dart';
import 'package:instagram_flutter/views/widgets/profile_header_widget.dart';


class Navigations_Screen extends StatefulWidget {
  const Navigations_Screen({super.key});

  @override
  State<Navigations_Screen> createState() => _Navigations_ScreenState();
}

int _currentIndex = 0;
class _Navigations_ScreenState extends State<Navigations_Screen> {
  late PageController pageController;

  User user = Global.user ?? User.empty();



  @override
  void initState(){
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose(){
    super.dispose();
    pageController.dispose();
  }

  onPageChanged(int page){
    setState(() {
      _currentIndex = page;
    });
  }

  navigationTapped(int page){
    pageController.jumpToPage(page);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        height: 79,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5), // Màu của bóng
              spreadRadius: 2, // Bán kính lan rộng của bóng
              blurRadius: 7, // Độ mờ của bóng
              offset: Offset(0, 3), // Vị trí của bóng, dương số là bên dưới
            ),
          ],
        ),

        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey,
          currentIndex: _currentIndex,
          onTap: navigationTapped,

          items: [
            BottomNavigationBarItem(
              icon:  SvgPicture.asset(
                'assets/images/Home.svg',
                width: 30,
                height: 30,
                color: _currentIndex == 0 ? Colors.black : Colors.black54,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/images/Search.svg',
                width: 30,
                height: 30,
                color: _currentIndex == 1 ? Colors.black : Colors.black54 ,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/images/Add.svg',
                width: 30,
                height: 30,
                color: _currentIndex == 2 ? Colors.black : Colors.black54
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/images/Reels.svg',
                width: 30,
                height: 30,
                color: _currentIndex == 3 ? Colors.black : Colors.black54,
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                'assets/images/User.svg',
                width: 30,
                height: 30,
                color: _currentIndex == 4 ? Colors.black : Colors.black54,
              ),
              label: '',
            ),

          ],
        ),
      ),
      body: PageView(
        controller: pageController,
        onPageChanged: onPageChanged,
        children: [
          const HomeScreen(),
          const ExplorScreen(),
          const AddScreen(),
          const ReelsScreen(),
          ProfileScreen(user: user),

        ],
      )

    );
  }
}
