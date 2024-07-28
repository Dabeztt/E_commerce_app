import 'dart:convert';
import 'package:doan/widget/title_text.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/user.dart';

class UserInfoScreen extends StatefulWidget {
  static const routeName = "/UserInfoScreen";
  const UserInfoScreen({super.key});

  @override
  State<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  User user = User.userEmpty();

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
  void initState() {
    super.initState();
    _fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle titleStyle = TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Theme.of(context).colorScheme.onBackground,
    );
    TextStyle valueStyle = TextStyle(
      fontSize: 20,
      color: Theme.of(context).colorScheme.onBackground,
    );

    return Scaffold(
      appBar: AppBar(
        title: const TitleTextWidget(label: "Thông tin cá nhân"),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(
            onPressed: () {
              Navigator.canPop(context) ? Navigator.pop(context) : null;
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              size: 18,
            ),
            tooltip: 'Quay lại',
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: double.infinity,
                    height: 210,
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage(
                            user.imageURL ?? 'https://via.placeholder.com/200'),
                        fit: BoxFit.cover,
                        onError: (error, stackTrace) {
                          // Handle image load error
                          setState(() {
                            user.imageURL = 'https://via.placeholder.com/200';
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildInfoCard('Mã tài khoản:', user.idNumber ?? 'N/A',
                  titleStyle, valueStyle, Icons.perm_identity),
              const SizedBox(height: 10),
              _buildInfoCard('Họ và tên:', user.fullName ?? 'N/A', titleStyle,
                  valueStyle, Icons.person),
              const SizedBox(height: 10),
              _buildInfoCard('Số điện thoại:', user.phoneNumber ?? 'N/A',
                  titleStyle, valueStyle, Icons.phone),
              const SizedBox(height: 10),
              _buildInfoCard('Giới tính:', user.gender ?? 'N/A', titleStyle,
                  valueStyle, Icons.wc),
              const SizedBox(height: 10),
              _buildInfoCard('Ngày sinh:', user.birthDay ?? 'N/A', titleStyle,
                  valueStyle, Icons.cake),
              const SizedBox(height: 10),
              _buildInfoCard('Ngày tham gia:', user.dateCreated ?? 'N/A',
                  titleStyle, valueStyle, Icons.calendar_today),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String value, TextStyle titleStyle,
      TextStyle valueStyle, IconData icon) {
    return Card(
      elevation: 4,
      color: Theme.of(context).cardColor,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Icon(icon,
                size: 30, color: const Color.fromARGB(255, 56, 109, 194)),
            const SizedBox(width: 10),
            Text(title, style: titleStyle),
            const SizedBox(width: 10),
            Flexible(child: Text(value, style: valueStyle)),
          ],
        ),
      ),
    );
  }
}
