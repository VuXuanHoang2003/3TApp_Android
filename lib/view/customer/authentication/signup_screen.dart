import 'dart:ffi';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../utils/validator.dart';
import '../../../viewmodel/auth_viewmodel.dart';
import '../../common_view/custom_button.dart';

bool isadminProp = false;

class SignUpScreen extends StatefulWidget {
  final bool isAdmin;

  SignUpScreen(this.isAdmin);

  @override
  State<StatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<SignUpScreen> {
  File? _image;
  final picker = ImagePicker();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "${AppLocalizations.of(context)?.signUp}",
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
                    "${AppLocalizations.of(context)?.createAccount}",
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 40,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Column(
                children: [
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
                    label: Text(
                        '${AppLocalizations.of(context)?.chooseAva}'), // Text nút chọn ảnh
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
              const SizedBox(height: 16), // Khoảng cách giữa các dòng
              TextFormField(
                controller: emailController,
                focusNode: emailFocusNode,
                keyboardType: TextInputType.emailAddress,
                autovalidateMode: AutovalidateMode.always,
                validator: (input) {
                  if (input!.isEmpty || Validators.isValidEmail(input)) {
                    return null;
                  } else {
                    return "Email ${AppLocalizations.of(context)?.invalid}!";
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
                  labelText: "${AppLocalizations.of(context)?.password}",
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
                  labelText: "${AppLocalizations.of(context)?.reenterPassword}",
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
                  labelText: "${AppLocalizations.of(context)?.phoneNumber}",
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
                  labelText: "${AppLocalizations.of(context)?.address}",
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
                  labelText: "${AppLocalizations.of(context)?.userName}",
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
                      bool isAdmin = widget.isAdmin;
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
                        if (_image != null) {
                          authViewModel.signUp(
                            email,
                            password,
                            phone,
                            address,
                            username,
                            isAdmin,
                            _image!, // Sử dụng !_image để bỏ qua kiểm tra null
                          );
                        } else {
                          // Xử lý trường hợp _image là null
                        }
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
                  text: "${AppLocalizations.of(context)?.signUp}",
                  textColor: Colors.white,
                  bgColor: Colors.green,
                ),
              ),
              const Padding(padding: EdgeInsets.only(top: 8)),
              GestureDetector(
                onTap: () {
                  backToLoginScreen();
                },
                child: Text(
                  "${AppLocalizations.of(context)?.accountExist}? ${AppLocalizations.of(context)?.login}",
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
                    "${AppLocalizations.of(context)?.loginBy}",
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

  void getImage() async {
    var pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  void backToLoginScreen() {
    Navigator.of(context).pop();
  }
}
