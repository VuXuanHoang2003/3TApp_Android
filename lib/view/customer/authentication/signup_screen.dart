import 'dart:ffi';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../utils/validator.dart';
import '../../../viewmodel/auth_viewmodel.dart';
import '../../common_view/custom_button.dart';

bool isadminProp = false;

class SignUpScreen extends StatefulWidget {
  SignUpScreen(bool isAdmin) {
    isadminProp = isAdmin;
    print(isadminProp);
  }

  @override
  State<StatefulWidget> createState() => _LoginScreen();
}

class _LoginScreen extends State<SignUpScreen> {
  bool obscureText = true;
  bool obscureReEnterPassword = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController reEnterPasswordController = TextEditingController();
  TextEditingController phoneController = TextEditingController(); // New field
  TextEditingController addressController =
      TextEditingController(); // New field
  TextEditingController usernameController = TextEditingController();
  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  FocusNode reEnterPasswordFocusNode = FocusNode();
  AuthViewModel authViewModel = AuthViewModel();
  FocusNode usernameFocusNode = FocusNode();

  void backToLoginScreen() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
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
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 40,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(
                  height: 16), // Thêm khoảng cách 16 pixel giữa các dòng

              TextFormField(
                controller: emailController,
                focusNode: emailFocusNode,
                keyboardType: TextInputType.emailAddress,
                autovalidateMode: AutovalidateMode.always,
                validator: (input) {
                  if (input!.isEmpty || Validators.isValidEmail(input)) {
                    return null;
                  } else {
                    return "Email không hợp lệ!";
                  }
                },
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(8),
                  labelText: "Email",
                  fillColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.blueAccent, width: 2.0),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey, width: 1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.redAccent, width: 1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.redAccent, width: 1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const Padding(padding: EdgeInsets.only(top: 16)),
              TextFormField(
                controller: passwordController,
                focusNode: passwordFocusNode,
                keyboardType: TextInputType.text,
                obscureText: obscureText,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(8),
                  labelText: "Mật khẩu",
                  fillColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.blueAccent, width: 2.0),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey, width: 1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscureText ? Icons.visibility : Icons.visibility_off,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        obscureText = !obscureText;
                      });
                    },
                  ),
                ),
              ),

              const Padding(padding: EdgeInsets.only(top: 16)),

              TextFormField(
                controller: reEnterPasswordController,
                focusNode: reEnterPasswordFocusNode,
                keyboardType: TextInputType.text,
                obscureText: obscureReEnterPassword,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(8),
                  labelText: "Nhập lại mật khẩu",
                  fillColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.blueAccent, width: 2.0),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey, width: 1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscureReEnterPassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        obscureReEnterPassword = !obscureReEnterPassword;
                      });
                    },
                  ),
                ),
              ),

              const Padding(padding: EdgeInsets.only(top: 16)),
              TextFormField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(8),
                  labelText: "Số điện thoại",
                  fillColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.blueAccent, width: 2.0),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey, width: 1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const Padding(padding: EdgeInsets.only(top: 16)),
              TextFormField(
                controller: addressController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(8),
                  labelText: "Địa chỉ",
                  fillColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.blueAccent, width: 2.0),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey, width: 1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const Padding(padding: EdgeInsets.only(top: 16)),
              TextFormField(
                controller: usernameController,
                focusNode: usernameFocusNode,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(8),
                  labelText: "Tên người dùng", // New field
                  fillColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.blueAccent, width: 2.0),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey, width: 1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const Padding(padding: EdgeInsets.only(top: 32)),
              SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                child: CustomButton(
                  onPressed: () {
                    if (emailController.text.toString().trim().isNotEmpty &&
                        passwordController.text.toString().trim().isNotEmpty &&
                        reEnterPasswordController.text
                            .toString()
                            .trim()
                            .isNotEmpty &&
                        phoneController.text.toString().trim().isNotEmpty &&
                        addressController.text.toString().trim().isNotEmpty) {
                      String email = emailController.text.toString().trim();
                      String password =
                          passwordController.text.toString().trim();
                      String reEnterPassword =
                          reEnterPasswordController.text.toString().trim();
                      String phone = phoneController.text.toString().trim();
                      String address = addressController.text.toString().trim();
                      String username = usernameController.text
                          .toString()
                          .trim(); // New field
                      bool isAdmin = isadminProp;
                      if (!Validators.isValidEmail(email)) {
                        Fluttertoast.showToast(
                          msg: "Vui lòng nhập đúng định dạng email.",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.black45,
                          textColor: Colors.white,
                          fontSize: 12.0,
                        );
                      } else if (password != reEnterPassword) {
                        Fluttertoast.showToast(
                          msg: "Nhập lại mật khẩu không khớp.",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.black45,
                          textColor: Colors.white,
                          fontSize: 12.0,
                        );
                      } else {
                        authViewModel.signUp(
                          email,
                          password,
                          phone,
                          address,
                          username,
                          isAdmin,
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
                  text: "Đăng ký",
                  textColor: Colors.white,
                  bgColor: Colors.green,
                ),
              ),
              const Padding(padding: EdgeInsets.only(top: 8)),
              GestureDetector(
                onTap: () {
                  backToLoginScreen();
                },
                child: const Text(
                  'Đã có tài khoản? Đăng nhập',
                  style: TextStyle(color: Colors.black, fontSize: 12),
                ),
              ),
              const Padding(padding: EdgeInsets.only(top: 16)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 70.0, // Điều chỉnh độ dài của đường ngang
                    height: 1.0,
                    color: Colors.black,
                    margin: const EdgeInsets.only(right: 8.0),
                  ),
                  Text(
                    'Đăng nhập bằng',
                    style: const TextStyle(color: Colors.black, fontSize: 20),
                  ),
                  Container(
                    width: 70.0, // Điều chỉnh độ dài của đường ngang
                    height: 1.0,
                    color: Colors.black,
                    margin: const EdgeInsets.only(left: 8.0),
                  ),
                ],
              ),
              const Padding(padding: EdgeInsets.only(top: 32)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      // Handle Google Sign-Up
                    },
                    icon: Image.asset(
                      "assets/images/google-logo.png",
                      width: 24,
                      height: 24,
                    ),
                    label: Text(''),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                    ),
                  ),
                  const SizedBox(width: 100),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Handle Phone Sign-Up
                    },
                    icon: Image.asset(
                      "assets/images/phone-logo.jpeg",
                      width: 24,
                      height: 24,
                    ),
                    label: Text(''),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                    ),
                  ),
                ],
              ),
              const Padding(padding: EdgeInsets.only(top: 16)),
            ],
          ),
        ),
      ),
    );
  }
}
