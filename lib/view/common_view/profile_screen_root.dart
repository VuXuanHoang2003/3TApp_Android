import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:three_tapp_app/view/common_view/profile_edit_screen.dart';

import '../../model/roles_type.dart';
import '../../utils/common_func.dart';
import '../../utils/image_path.dart';
import '../../viewmodel/auth_viewmodel.dart';
import 'package:three_tapp_app/view/common_view/profile_screen.dart';


class ProfileScreenRoot extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ProfileScreenRoot();
}
class _ProfileScreenRoot extends State<ProfileScreenRoot>{
  AuthViewModel authViewModel = AuthViewModel();
  User? user;
  Map<String, dynamic>? userInfo;
  
  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    // Lấy thông tin từ Cloud Firestore
    getUserAdditionalInfo();
  }

  Future<void> getUserAdditionalInfo() async {
    try {
      // Lấy thông tin từ Firestore
      Map<String, dynamic>? additionalInfo = await CommonFunc.getUserInfoFromFirebase(user?.uid ?? "");
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
                  // TODO: Thêm ảnh đại diện của người dùng
                  backgroundImage: AssetImage('assets/images/default-avatar.png'),
                ),
                SizedBox(width: 16),
                // Thông tin người dùng
                Expanded(
                  child: Column(
                    children: [
                      Text(
                  userInfo?['username'] ?? "Unknown username",
                  style: const TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
                ),
                      SizedBox(height: 8),
                       Text(
                      userInfo?['email'] ?? "Unknown email",
                      style: const TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                      SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () {
                          // TODO: Xử lý khi bấm vào nút chỉnh sửa hồ sơ
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => EditProfileScreen()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green, // Màu nền xanh lá
                        ),
                        child: Text('Chỉnh sửa hồ sơ',
                            style: TextStyle(color: Colors.white),
                            ),// Màu chữ đen
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
                
                  CustomListTile('Thông tin'),
                  CustomListTile('Hướng dẫn'),
                  CustomListTile('Ngôn ngữ'),
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
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => ProfileScreen()),
          );
        }
        else if(itemName=='Lịch sử'){

        }
        else if(itemName=='Thoát tài khoản'){
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
