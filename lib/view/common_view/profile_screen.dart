import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../model/roles_type.dart';
import '../../utils/common_func.dart';
import '../../utils/image_path.dart';
import '../../viewmodel/auth_viewmodel.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ProfileScreen();
}

class _ProfileScreen extends State<ProfileScreen> {
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
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          title: const Text(
            "Thông tin cá nhân",
            style: TextStyle(color: Colors.black),
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.grey,
              size: 20,
            ),
          ),
          elevation: 0,
        ),
        body: Padding(
          padding: EdgeInsets.only(
            left: 16,
            top: MediaQuery.of(context).padding.top + 8,
            right: 16,
            bottom: MediaQuery.of(context).padding.bottom + 16,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    backgroundImage: AssetImage(ImagePath.imgLogo),
                    radius: 28,
                  ),
                ),
              ),
              Center(
                child: Text(
                  userInfo?['username'] ?? "Unknown username",
                  style: const TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Center(
                  child: Text(authViewModel.rolesType == RolesType.seller
                      ? "(Người bán)"
                      : "(Người mua)")),
              const Divider(
                thickness: 0.5,
                color: Colors.grey,
                height: 8,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    buildUserInfoRow(Icons.email, "Email",
                        userInfo?['email'] ?? "Unknown email"),
                    const SizedBox(height: 8),
                    buildUserInfoRow(Icons.phone, "Phone",
                        userInfo?['phone'] ?? "Unknown phone"),
                    const SizedBox(height: 8),
                    buildUserInfoRow(Icons.location_on, "Address",
                        userInfo?['address'] ?? "Unknown address"),
                  ],
                ),
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    await authViewModel.logout();
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue, // Màu sắc nút
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(10.0), // Góc bo tròn của nút
                    ),
                    padding: EdgeInsets.symmetric(
                        vertical: 15.0,
                        horizontal:
                            20.0), // Khoảng cách giữa vị trí chữ và mép nút
                  ),
                  child: Text(
                    "Đăng xuất",
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildUserInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(value),
        ),
      ],
    );
  }
}
