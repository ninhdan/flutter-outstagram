import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter/models/user.dart';
import 'package:instagram_flutter/utils/highlight.dart';
import 'package:instagram_flutter/views/edit_profile_screen.dart';

Widget profileHeaderWidget(BuildContext context, User user, int countPosts) {
  return Container(
    width: double.infinity,
    decoration: const BoxDecoration(color: Colors.white),
    child: Padding(
      padding: const EdgeInsets.only(left: 18.0, right: 18.0, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors
                        .grey.shade500, // Adjust the color to your preference
                    width: 3.5, // Adjust the width to your preference
                  ),
                ),
                child: CircleAvatar(
                  radius: 38, // Adjust the radius to fit within the border
                  backgroundColor: const Color(0xff74EDED),
                  backgroundImage: NetworkImage(
                    user.avatar.isEmpty
                        ? 'https://instagram.fixc1-9.fna.fbcdn.net/v/t51.2885-19/44884218_345707102882519_2446069589734326272_n.jpg?_nc_ht=instagram.fixc1-9.fna.fbcdn.net&_nc_cat=1&_nc_ohc=TokSSzUDPVcQ7kNvgGMF0u_&edm=AJ9x6zYBAAAA&ccb=7-5&ig_cache_key=YW5vbnltb3VzX3Byb2ZpbGVfcGlj.2-ccb7-5&oh=00_AYCetGx_2KnUphpAbrzv_kkxLPaX07mcXeJxPNOXkBSYIg&oe=6648F00F&_nc_sid=65462d'
                        : user.avatar,
                  ),
                ),
              ),
               Row(
                children: [
                  Column(
                    children: [
                      Text(
                        countPosts.toString(),
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        "Posts",
                        style: TextStyle(
                          fontSize: 15,
                          letterSpacing: 0.4,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  Column(
                    children: [
                      Text(
                        "1.5M",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        "Followers",
                        style: TextStyle(
                          letterSpacing: 0.4,
                          fontSize: 15,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  Column(
                    children: [
                      Text(
                        "234",
                        style: TextStyle(
                          letterSpacing: 0.4,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        "Following",
                        style: TextStyle(
                          letterSpacing: 0.4,
                          fontSize: 15,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    width: 15,
                  ),
                ],
              )
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            user.full_name == '' ? "" : user.full_name,
            style: const TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w700,
              fontSize: 16,
              letterSpacing: 0.4,
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            user.bio == '' ? "" : user.bio,
            style: const TextStyle(
              letterSpacing: 0.4,
              fontSize: 14,
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          actions(context),
          const SizedBox(
            height: 25,
          ),
          Container(
            height: 85,
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: highlightItems.length,
              itemBuilder: (context, index) {
                return Row(
                  children: [
                    Column(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.grey,
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: CircleAvatar(
                              backgroundImage:
                                  AssetImage(highlightItems[index].thumbnail),
                              radius: 28,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            highlightItems[index].title,
                            style: const TextStyle(fontSize: 13),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      width: 10,
                    )
                  ],
                );
              },
            ),
          )
        ],
      ),
    ),
  );
}

Widget actions(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Expanded(
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            minimumSize: const Size(0, 35),
            backgroundColor: Colors.grey[300],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(7),
            ),
            side: BorderSide.none,
          ),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => EditProfileScreen()
              ),
            );
          },
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              "Edit Profile",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
      const SizedBox(width: 10),
      Expanded(
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            minimumSize: const Size(0, 35),
            backgroundColor: Colors.grey[300],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(7),
            ),
            side: BorderSide.none,
          ),
          onPressed: () {},
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "Share Profile",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
    ],
  );
}
