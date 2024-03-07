import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:three_tapp_app/model/roles_type.dart';
import 'package:three_tapp_app/utils/common_func.dart';
import 'package:three_tapp_app/viewmodel/auth_viewmodel.dart';

class SimpleSignInScreen extends StatefulWidget {
  // final String email;
  final bool isAdmin;
  //final User user;

  SimpleSignInScreen(
      { //required this.user,
      //required this.email,
      required this.isAdmin}); // Include isAdmin in the constructor

  @override
  _SimpleSignInScreenState createState() => _SimpleSignInScreenState();
}

class _SimpleSignInScreenState extends State<SimpleSignInScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  AuthViewModel authViewModel = AuthViewModel();
  Future<User?>? _currentUser = null;
  File? _image;
  final picker = ImagePicker();
  TextEditingController addressController = TextEditingController();

  void backToLoginScreen() {
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();
  }

  void getImage() async {
    var pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "Đăng ký",
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Tạo tài khoản',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 40,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 16), // Thêm khoảng cách 16 pixel giữa các dòng

              const SizedBox(height: 16),
              Column(
                children: [
                  // Hiển thị ảnh đại diện trong CircleAvatar
                  CircleAvatar(
                    radius: 50, // Độ lớn của ảnh đại diện
                    backgroundColor:
                        Colors.grey[200], // Màu nền khi không có ảnh
                    backgroundImage: _image != null
                        ? FileImage(_image!) // Sử dụng ảnh từ _image nếu có
                        : null,
                    child: _image == null
                        ? Icon(
                            Icons.person, // Icon mặc định nếu không có ảnh
                            size: 60,
                            color: Colors.grey[400],
                          )
                        : null,
                  ),
                  const SizedBox(
                      height: 16), // Khoảng cách giữa ảnh và nút chọn
                  ElevatedButton.icon(
                    onPressed: getImage,
                    icon: Icon(Icons.photo_camera), // Icon chọn ảnh
                    label: Text('Chọn ảnh đại diện'), // Text nút chọn ảnh
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.green, // Màu chữ trên nút
                      padding: EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12), // Padding cho nút
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(8), // Bo tròn viền nút
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: nameController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(8),
                  labelText: "Tên",
                  fillColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.blueAccent, width: 2.0),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              SizedBox(height: 16),

              TextFormField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(8),
                  labelText: "Số điện thoại",
                  fillColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.blueAccent, width: 2.0),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              SizedBox(height: 16),

              TextFormField(
                controller: addressController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(8),
                  labelText: "Địa chỉ",
                  fillColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.blueAccent, width: 2.0),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              SizedBox(height: 16),

              SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                child: ElevatedButton(
                  onPressed: () async {
                    String name = nameController.text.toString().trim();
                    String phone = phoneController.text.toString().trim();
                    String address = addressController.text.toString().trim();

                    if (name.isNotEmpty &&
                        phone.isNotEmpty &&
                        address.isNotEmpty) {
                      // Thực hiện thêm thông tin người dùng vào Firestore
                      bool addUserResult =
                          await authViewModel.addUserByGoogleSignIn(
                        phone: phone,
                        address: address,
                        username: name,
                        isAdmin: widget.isAdmin,
                        avatarFile: _image!,
                      );

                      if (addUserResult) {
                        Fluttertoast.showToast(
                          msg: "Đăng ký thành công!",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.black45,
                          textColor: Colors.white,
                          fontSize: 12.0,
                        );
                        // Thực hiện các xử lý tiếp theo sau khi đăng ký thành công
                        var rolesType;
                        if (rolesType == RolesType.seller) {
                          CommonFunc.goToAdminRootScreen();
                        } else {
                          CommonFunc.goToCustomerRootScreen();
                        }
                      } else {
                        Fluttertoast.showToast(
                          msg: "Đã xảy ra lỗi khi đăng ký.",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.black45,
                          textColor: Colors.white,
                          fontSize: 12.0,
                        );
                      }
                    } else {
                      Fluttertoast.showToast(
                        msg: "Vui lòng nhập đủ thông tin.",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.black45,
                        textColor: Colors.white,
                        fontSize: 12.0,
                      );
                    }
                  },
                  child: Text("Đăng ký"),
                ),
              ),

              SizedBox(height: 8),
              GestureDetector(
                onTap: () {
                  backToLoginScreen();
                },
                child: Text(
                  'Đã có tài khoản? Đăng nhập',
                  style: TextStyle(color: Colors.black, fontSize: 12),
                ),
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
