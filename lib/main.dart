import 'package:doan/const/theme_data.dart';
import 'package:doan/provider/theme_provider.dart';
import 'package:doan/screen/auth/login.dart';
import 'package:doan/screen/profile/oders_screen.dart';
import 'package:doan/screen/product/product_detail.dart';
import 'package:doan/screen/profile/user_info.dart';
import 'package:doan/screen/profile/viewed_recently.dart';
import 'package:doan/screen/profile/wishlist_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ThemeProvider(),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'CashBack Demo',
            theme: Style.themeData(
                isDarkTheme: themeProvider.getIsDarkTheme, context: context),
            home: const LoginScreen(),
            routes: {
              ProductDetail.routeName: (context) => const ProductDetail(),
              WishlistScreen.routeName: (context) =>
                  WishlistScreen(favoriteProducts: []),
              RecentlyViewedScreen.routeName: (context) =>
                  RecentlyViewedScreen(recentlyViewedProducts: []),
              UserInfoScreen.routeName: (context) => const UserInfoScreen(),
              OderScreen.routeName: (context) => const OderScreen(),
            },
          );
        },
      ),
    );
  }
}
