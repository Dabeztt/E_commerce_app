import 'dart:convert';

import 'package:doan/data/sharepre.dart';
import 'package:doan/screen/profile/oders_screen.dart';
import 'package:doan/screen/profile/user_info.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:doan/provider/theme_provider.dart';
import 'package:doan/widget/app_name_text.dart';
import 'package:doan/widget/custom_list_tile.dart';
import 'package:doan/widget/subtitle_text.dart';
import 'package:doan/widget/title_text.dart';
import 'package:doan/service/assets_manager.dart';
import 'package:doan/screen/profile/viewed_recently.dart';
import 'package:doan/screen/profile/wishlist_screen.dart';
import 'package:doan/model/user.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User user = User.userEmpty();

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userData = prefs.getString('user');

    if (userData != null) {
      setState(() {
        user = User.fromJson(jsonDecode(userData));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const AppNameTextWidget(),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(AssetsManager.shoppingCart),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              children: [
                Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).cardColor,
                    border: Border.all(
                      color: Theme.of(context).colorScheme.background,
                      width: 3,
                    ),
                    image: DecorationImage(
                      image: NetworkImage(
                          user.imageURL ?? 'https://via.placeholder.com/200'),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TitleTextWidget(label: user.fullName ?? 'N/A'),
                    SubtitleTextWidget(label: user.idNumber ?? 'N/A')
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const TitleTextWidget(label: "Cài đặt chung"),
                CustomListTile(
                  imagePath: AssetsManager.orderSvg,
                  text: "Đơn hàng",
                  function: () {
                    Navigator.pushNamed(context, OderScreen.routeName);
                  },
                ),
                CustomListTile(
                  imagePath: AssetsManager.wishlistSvg,
                  text: "Yêu thích",
                  function: () {
                    Navigator.pushNamed(context, WishlistScreen.routeName);
                  },
                ),
                CustomListTile(
                  imagePath: AssetsManager.recent,
                  text: "Đã xem gần đây",
                  function: () {
                    Navigator.pushNamed(
                        context, RecentlyViewedScreen.routeName);
                  },
                ),
                CustomListTile(
                  imagePath: AssetsManager.address,
                  text: "Địa chỉ",
                  function: () {
                    Navigator.pushNamed(context, UserInfoScreen.routeName);
                  },
                ),
                Divider(
                  thickness: 1,
                ),
                SizedBox(
                  height: 10,
                ),
                TitleTextWidget(label: "Cài đặt hệ thống"),
                SwitchListTile(
                  title: Text(themeProvider.getIsDarkTheme
                      ? "Chế độ tối"
                      : "Chế độ sáng"),
                  value: themeProvider.getIsDarkTheme,
                  onChanged: (value) {
                    themeProvider.setDarkTheme(themeValue: value);
                  },
                ),
                Divider(
                  thickness: 1,
                ),
                SizedBox(
                  height: 10,
                ),
                Center(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () async {
                      logOut(context);
                    },
                    icon: const Icon(
                      Icons.login,
                      color: Colors.white,
                    ),
                    label: const Text(
                      "Đăng xuất",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
