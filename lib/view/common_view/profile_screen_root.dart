//import 'dart:ui_web';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:three_tapp_app/view/common_view/change_password_screen.dart';
import 'package:three_tapp_app/view/common_view/profile_edit_screen.dart';

import '../../model/roles_type.dart';
import '../../utils/common_func.dart';
import '../../utils/image_path.dart';
import '../../viewmodel/auth_viewmodel.dart';
import 'package:three_tapp_app/view/common_view/profile_screen.dart';

class ProfileScreenRoot extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ProfileScreenRootState();
}

class _ProfileScreenRootState extends State<ProfileScreenRoot> {
  AuthViewModel authViewModel = AuthViewModel();
  User? user;
  Map<String, dynamic>? userInfo;
  String? _avatarUrl; // Đường dẫn của ảnh người dùng

  @override
  void initState() {
   _getUserInfo();

    super.initState();
    user = FirebaseAuth.instance.currentUser;
    // Lấy thông tin từ Cloud Firestore
    getUserAdditionalInfo();
  }

  Future<void> _getUserInfo() async {
  List<String> userInfo = await authViewModel.getUserInfo();
  setState(() {
    _avatarUrl = userInfo[3]; // Gán đường dẫn của ảnh từ avatarUrl
    print("Hello root");
    print(_avatarUrl);
  });
}

  Future<void> getUserAdditionalInfo() async {
    try {
      // Lấy thông tin từ Firestore
      Map<String, dynamic>? additionalInfo =
          await CommonFunc.getUserInfoFromFirebase(user?.uid ?? "");
      print(additionalInfo);
      if (additionalInfo != null) {
        setState(() {
          // Cập nhật thông tin người dùng
          userInfo = additionalInfo;
        });
      }
    } catch (e) {
      print('Error fetching additional user info: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thông tin của bạn'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Phần đầu
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Ảnh đại diện
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.transparent,
                  child: ClipOval(
                    child: _avatarUrl != null
                        ? Image.network(
                            _avatarUrl!,
                            fit: BoxFit.cover,
                            width: 100,
                            height: 100,
                          )
                        : Image.asset(
                            'assets/images/default-avatar.png',
                            fit: BoxFit.cover,
                            width: 50,
                            height: 50,
                          ),
                  ),
                ),
                SizedBox(width: 16),
                // Thông tin người dùng
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        userInfo?['username'] ?? "Unknown username",
                        style: const TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        userInfo?['email'] ?? "Unknown email",
                        style: const TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () {
                          // TODO: Xử lý khi bấm vào nút chỉnh sửa hồ sơ
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditProfileScreen()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green, // Màu nền xanh lá
                        ),
                        child: Text(
                          'Chỉnh sửa hồ sơ',
                          style: TextStyle(color: Colors.white),
                        ), // Màu chữ đen
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            // Phần dưới
            Expanded(
              child: ListView(
                children: [
                  CustomListTile('Lịch sử'),
                  CustomListTile('Hướng dẫn'),
                  CustomListTile('Ngôn ngữ'),
                  if (authViewModel.userMode == 1)
                    CustomListTile('Đổi mật khẩu'),
                  CustomListTile('Thoát tài khoản'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomListTile extends StatelessWidget {
  final String itemName;
  AuthViewModel authViewModel = AuthViewModel();

  CustomListTile(this.itemName);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(itemName),
          Icon(Icons.arrow_forward_ios), // Ký hiệu ">"
        ],
      ),
      onTap: () async {
        if (itemName == 'Thông tin') {
          // Navigator.pushReplacement(
          //   context,
          //   MaterialPageRoute(builder: (context) => ProfileScreen()),
          // );
        } else if (itemName == 'Lịch sử') {
          // Xử lý khi chọn "Lịch sử"
        } else if (itemName == 'Đổi mật khẩu') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => ChangePasswordPage()),
          );
        } else if (itemName == 'Thoát tài khoản') {
          await authViewModel.logout();
        } else {
          // Xử lý khi bấm vào các mục khác
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DetailsScreen(itemName)),
          );
        }
      },
    );
  }
}

class DetailsScreen extends StatelessWidget {
  final String itemName;

  DetailsScreen(this.itemName);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chi tiết'),
      ),
      body: Center(
        child: Text('Chi tiết về $itemName'),
      ),
    );
  }
}
