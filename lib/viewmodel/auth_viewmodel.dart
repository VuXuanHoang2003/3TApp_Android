import 'dart:async';
import 'dart:ffi';

import 'package:awesome_notifications_fcm/awesome_notifications_fcm.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../base/baseviewmodel/base_viewmodel.dart';
import '../data/repositories/auth_repo/auth_repo.dart';
import '../data/repositories/auth_repo/auth_repo_impl.dart';
import '../main.dart';
import '../model/fcm.dart';
import '../model/roles_type.dart';
import '../utils/common_func.dart';
import '../view/common_view/select_role.dart';
import 'notification_viewmodel.dart';

class AuthViewModel extends BaseViewModel {
  static final AuthViewModel _instance = AuthViewModel._internal();

  factory AuthViewModel() {
    return _instance;
  }

  AuthViewModel._internal();

  AuthRepo authRepo = AuthRepoImpl();

  RolesType rolesType = RolesType.none;

  @override
  FutureOr<void> init() {}

  onRolesChanged(RolesType rolesType) {
    this.rolesType = rolesType;
    notifyListeners();
  }

  String getUserEmail() {
    User? user = FirebaseAuth.instance.currentUser;
    return user?.email ??
        ""; // Nếu user không null thì trả về email, ngược lại trả về chuỗi rỗng
  }

  Future<void> login(
      {required String email,
      required String password,
      required bool isCheckAdmin}) async {
    EasyLoading.show();
    await authRepo
        .login(email: email, password: password, isCheckAdmin: isCheckAdmin)
        .then((value) async {
      if (value != null) {
        if (rolesType == RolesType.seller) {
          CommonFunc.goToAdminRootScreen();
        } else {
          CommonFunc.goToCustomerRootScreen();
        }
        FCM fcm = FCM(
            id: UniqueKey().toString(),
            email: email,
            isAdmin: rolesType == RolesType.seller,
            fcmToken:
                await AwesomeNotificationsFcm().requestFirebaseAppToken());
        // Add FCM to receive notification
        NotificationViewModel().addFCM(fcm: fcm);
      }
      EasyLoading.dismiss();
    }).onError((error, stackTrace) {
      EasyLoading.dismiss();
      CommonFunc.showToast("Lỗi đăng nhập!");
    });
  }

  Future<void> signUp(String email, String password, String phone,
      String address, String username, bool isAdmin) async {
    EasyLoading.show();
    await authRepo
        .signUp(
            email: email,
            password: password,
            phone: phone,
            address: address,
            username: username,
            isAdmin: isAdmin)
        .then((value) {
      EasyLoading.dismiss();
      if (value) {
        CommonFunc.showToast("Đăng ký thành công.");
        // Back to login screen
        Navigator.of(navigationKey.currentContext!).pop();
      } else {
        print("Sign up error");
      }
    }).onError((error, stackTrace) {
      EasyLoading.dismiss();
      CommonFunc.showToast("Đăng ký thất bại!");
    });
  }

  Future<void> logout() async {
    EasyLoading.show();
    await FirebaseAuth.instance.signOut();
    notifyListeners();
    EasyLoading.dismiss();
    if (FirebaseAuth.instance.currentUser == null) {
      Navigator.pushReplacement(navigationKey.currentContext!,
          MaterialPageRoute(builder: (context) => SelectRole()));
    }
  }
}
