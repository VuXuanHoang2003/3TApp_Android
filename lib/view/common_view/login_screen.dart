import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../model/roles_type.dart';
import '../../utils/validator.dart';
import '../../viewmodel/auth_viewmodel.dart';
import '../customer/authentication/signup_screen.dart';
import 'custom_button.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginScreen();
}

class _LoginScreen extends State<LoginScreen> {
  bool obscureText = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  AuthViewModel authViewModel = AuthViewModel();
  final _auth = FirebaseAuth.instance;
  final _googleSignIn = GoogleSignIn();
  void goToSignUpScreen(bool isAdmin) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignUpScreen(isAdmin)),
    );
  }

  signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final AuthCredential authCredential = GoogleAuthProvider.credential(
            accessToken: googleSignInAuthentication.accessToken,
            idToken: googleSignInAuthentication.idToken);
        await _auth.signInWithCredential(authCredential);
      }
    } on FirebaseAuthException catch (e) {
      print(e.message);
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "Đăng nhập",
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/donaso-logo.png",
                width: 100,
                height: 100,
              ),
              const Padding(padding: EdgeInsets.only(top: 16)),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Hello!',
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 40,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Flexible(
                    child: Text(
                      'Đăng nhập vào tài khoản của bạn',
                      style: const TextStyle(color: Colors.black, fontSize: 20),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const Padding(padding: EdgeInsets.only(top: 32)),
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
              const Padding(padding: EdgeInsets.only(top: 32)),
              SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                child: CustomButton(
                  onPressed: () {
                    if (emailController.text.toString().trim().isNotEmpty &&
                        passwordController.text.toString().trim().isNotEmpty) {
                      String email = emailController.text.toString().trim();
                      String password =
                          passwordController.text.toString().trim();
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
                      } else {
                        authViewModel.login(
                          email: email,
                          password: password,
                          isCheckAdmin:
                              authViewModel.rolesType == RolesType.seller,
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
                  text: "ĐĂNG NHẬP",
                  textColor: Colors.white,
                  bgColor: Colors.green,
                ),
              ),
              const Padding(padding: EdgeInsets.only(top: 8)),
              GestureDetector(
                onTap: () {
                  print('Đăng nhập');
                  if (authViewModel.rolesType == RolesType.seller) {
                    goToSignUpScreen(true);
                  } else {
                    goToSignUpScreen(false);
                  }
                },
                child: const Text(
                  'Bạn chưa có tài khoản? Đăng ký',
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
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                ElevatedButton.icon(
                  onPressed: () {
                    signInWithGoogle();
                  },
                  icon: Image.asset(
                    "assets/images/google-logo.png",
                    width: 24,
                    height: 24,
                  ),
                  label: Text(''),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                  ),
                ),
                const SizedBox(width: 100),
                ElevatedButton.icon(
                  onPressed: () {
                    // Handle Phone Sign-In
                  },
                  icon: Image.asset(
                    "assets/images/phone-logo.jpeg",
                    width: 24,
                    height: 24,
                  ),
                  label: Text(''),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                  ),
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
