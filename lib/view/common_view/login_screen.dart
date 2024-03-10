import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:three_tapp_app/utils/common_func.dart';
import 'package:three_tapp_app/view/common_view/phone_verification_screen.dart';
import 'package:three_tapp_app/view/customer/authentication/simple_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../model/roles_type.dart';
import '../../utils/validator.dart';
import '../../viewmodel/auth_viewmodel.dart';
import '../customer/authentication/signup_screen.dart';
import 'custom_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// import 'package:shared_preferences/shared_preferences.dart';

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

// Hàm để đăng xuất khỏi tài khoản Google
  void signOutGoogle() async {
    try {
      await _googleSignIn.signOut();
    } catch (error) {
      print('Error signing out: $error');
    }
  }

// Hàm xử lý việc đăng xuất khỏi tài khoản Google và xóa session
  void handleSignOut() async {
    try {
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // await prefs.remove('user_email');
      // await prefs.remove('user_token');
      signOutGoogle(); // Remove the await keyword here
      await _auth.signOut();
    } catch (error) {
      print('Error handling sign out: $error');
    }
  }

  void _navigateToSimpleSignInScreen({required bool isAdmin}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SimpleSignInScreen(
          isAdmin: isAdmin, // Truyền tham số isAdmin vào SimpleSignInScreen
        ),
      ),
    );
  }

  void signInWithGoogle() async {
    try {
      //handleSignOut();
      // Gọi hàm signInWithGoogle từ AuthViewModel
      bool signInResult = await authViewModel.signInWithGoogle();
      // ton tai email =false,
      if (signInResult) {
        _navigateToSimpleSignInScreen(
          isAdmin: authViewModel.rolesType == RolesType.seller,
        );

        // true là email 0 tồn tại
      } else {
        if (authViewModel.rolesType == RolesType.seller) {
          CommonFunc.goToAdminRootScreen();
        } else {
          CommonFunc.goToCustomerRootScreen();
        }
      }
    } catch (e) {
      // Xử lý lỗi nếu có
      print("Sign in with Google error: ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title:  Text(
          "${AppLocalizations.of(context)?.login}",
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
                      "${AppLocalizations.of(context)?.loginInAccount}",
                      style: const TextStyle(color: Colors.black, fontSize: 16),
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
                    return "Email ${AppLocalizations.of(context)?.invalid}";
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
                  text: "${AppLocalizations.of(context)?.login}",
                  textColor: Colors.white,
                  bgColor: Colors.green,
                ),
              ),
              const Padding(padding: EdgeInsets.only(top: 8)),
              GestureDetector(
                onTap: () {
                  if (authViewModel.rolesType == RolesType.seller) {
                    goToSignUpScreen(true);
                  } else {
                    goToSignUpScreen(false);
                  }
                },
                child: Text(
                  "${AppLocalizations.of(context)?.noAccountQues}? ${AppLocalizations.of(context)?.signUp}",
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
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                ElevatedButton.icon(
                  onPressed: () async {
                    try {
                      signInWithGoogle();
                    } catch (e) {
                      print('Error signing in with Google: $e');
                    }
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PhoneVerificationScreen(),
                      ),
                    );
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
