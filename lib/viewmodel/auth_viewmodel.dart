import 'dart:async';
import 'dart:ffi';
import 'dart:io';

import 'package:awesome_notifications_fcm/awesome_notifications_fcm.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  GoogleSignIn _googleSignIn = GoogleSignIn(); // Khởi tạo trường _googleSignIn

  static final AuthViewModel _instance = AuthViewModel._internal();

  factory AuthViewModel() {
    return _instance;
  }

  AuthViewModel._internal();

  AuthRepo authRepo = AuthRepoImpl();

  RolesType rolesType = RolesType.none;
  String? _currentUid;

  // Getter để lấy giá trị uid
  String? get currentUid => _currentUid;

  @override
  FutureOr<void> init() {}

  onRolesChanged(RolesType rolesType) {
    this.rolesType = rolesType;
    notifyListeners();
  }

  String? getCurrentUserID() {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      return currentUser.uid;
    } else {
      return null;
    }
  }

  String getUserEmail() {
    User? user = FirebaseAuth.instance.currentUser;
    return user?.email ??
        ""; // Nếu user không null thì trả về email, ngược lại trả về chuỗi rỗng
  }

  int get userMode {
    return authRepo.userMode;
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

  Future<bool> uploadAvatar(File imageFile, String userId) async {
    try {
      return await authRepo.uploadAvatar(imageFile, userId);
    } catch (e) {
      print("Error uploading avatar from uploadAvatar: $e");
      return false; // Trả về giá trị mặc định trong trường hợp xảy ra lỗi
    }
  }

  Future<String> getUsernameByEmail(String email) async {
    try {
      // Connect to Firestore collection 'USERS'
      final CollectionReference usersCollection =
          FirebaseFirestore.instance.collection('USERS');

      // Query users with the corresponding email
      QuerySnapshot querySnapshot =
          await usersCollection.where('email', isEqualTo: email).get();

      // Get the list of accounts with the matching email
      List<DocumentSnapshot> userList = querySnapshot.docs;

      // Check if there is any user
      if (userList.isNotEmpty) {
        // Get the username from the first user (if there are multiple users with the same email)
        String username = userList.first['username'];
        return username;
      } else {
        return "Unknown username";
      }
    } catch (e) {
      print('Error accessing Firestore: $e');
      return "Unknown username";
    }
  }

  Future<bool> editProfile(String newName, String newAddress, String newPhone,
      File? imageFile) async {
    try {
      return await authRepo.editProfile(
          newName, newAddress, newPhone, imageFile);
    } catch (error) {
      print('Error updating user profile: $error');
      return false;
    }
  }

  Future<void> changePassword(String newPassword) async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        await currentUser.updatePassword(newPassword);
        CommonFunc.showToast("Mật khẩu đã được thay đổi thành công");
      } else {
        // Xử lý trường hợp người dùng không đăng nhập
      }
    } catch (error) {
      CommonFunc.showToast("Đã xảy ra lỗi khi thay đổi mật khẩu");
      print('Error changing password: $error');
    }
  }

  Future<String> getUsername() async {
    String email = FirebaseAuth.instance.currentUser?.email ?? "";
    return await getUsernameByEmail(email) ?? "Unknown username";
  }

  Future<bool> addUserByGoogleSignIn(
      {required String phone,
      required String address,
      required String username,
      required bool isAdmin,
      required File avatarFile}) async {
    // Gọi lại hàm addUserByGoogleSignIn từ AuthRepoImpl
    return await authRepo.addUserByGoogleSignIn(
      phone: phone,
      address: address,
      username: username,
      isAdmin: isAdmin,
      avatarFile: avatarFile,
    );
  }

  // Future<bool> addUser(User user,
  //     {String phone = '',
  //     String address = '',
  //     String username = '',
  //     bool isAdmin = false}) async {
  //   try {
  //     Map<String, dynamic> userMap = {
  //       'username': username, // Sử dụng giá trị username được truyền từ signUp
  //       'email': user.email,
  //       'isAdmin': isAdmin,
  //       'phone': phone,
  //       'address': address,
  //     };

  //     await FirebaseFirestore.instance
  //         .collection('USERS')
  //         .doc(user.uid)
  //         .set(userMap);
  //     return true;
  //   } on FirebaseAuthException catch (e) {
  //     print("add user error: ${e.toString()}");
  //     return false;
  //   } catch (e) {
  //     print("add user error: ${e.toString()}");
  //     return false;
  //   }
  // }

  // String getUsernameByEmail1(String? email) {
  //   if (email == null) {
  //     return "Unknown username";
  //   }
  //   return email.split("@").first;
  // }

  // Future<void> signUp(String email, String password, String phone,
  //     String address, String username, bool isAdmin) async {
  //   EasyLoading.show();
  //   await authRepo
  //       .signUp(
  //           email: email,
  //           password: password,
  //           phone: phone,
  //           address: address,
  //           username: username,
  //           isAdmin: isAdmin)
  //       .then((value) {
  //     EasyLoading.dismiss();
  //     if (value) {
  //       CommonFunc.showToast("Đăng ký thành công.");
  //       // Back to login screen
  //       Navigator.of(navigationKey.currentContext!).pop();
  //     } else {
  //       print("Sign up error");
  //     }
  //   }).onError((error, stackTrace) {
  //     EasyLoading.dismiss();
  //     CommonFunc.showToast("Đăng ký thất bại!");
  //   });
  // }

  Future<void> signUp(
    String email,
    String password,
    String phone,
    String address,
    String username,
    bool isAdmin,
    File avatarFile, // Add this argument
  ) async {
    EasyLoading.show();
    await authRepo
        .signUp(
      email: email,
      password: password,
      phone: phone,
      address: address,
      username: username,
      isAdmin: isAdmin,
      avatarFile: avatarFile, // Pass the avatarFile argument
    )
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

  void signOutGoogle() async {
    try {
      // Ngắt kết nối với tài khoản Google
      //await _googleSignIn.disconnect();
      _googleSignIn.signOut();
      // Xóa thông tin đăng nhập của tài khoản Google trước đó từ SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('user_email');
      await prefs.remove('user_token');

      print("Đăng xuất khỏi tài khoản Google thành công");
    } catch (error) {
      print('Lỗi khi đăng xuất khỏi tài khoản Google: $error');
    }
  }

  Future<void> logout() async {
    EasyLoading.show();
    try {
      // Đăng xuất khỏi Google Sign-In
      await authRepo.logout();

      await FirebaseAuth.instance.signOut();

      notifyListeners();
      EasyLoading.dismiss();
      Navigator.pushReplacement(navigationKey.currentContext!,
          MaterialPageRoute(builder: (context) => SelectRole()));
    } catch (e) {
      // Xử lý lỗi nếu có
      print("Error during logout: $e");
      EasyLoading.dismiss();
    }
  }

  Future<List<String>> getUserInfo() async {
    try {
      return await authRepo.getUserInfo();
    } catch (error) {
      print('Error fetching user info: $error');
      return [
        '',
        '',
        '',
        '',
      ]; // Trả về danh sách rỗng trong trường hợp có lỗi xảy ra
    }
  }

  Future<bool> signInWithGoogle() async {
    // Gọi hàm signInWithGoogle từ model và nhận giá trị trả về
    bool isSignedIn = await authRepo.signInWithGoogle();

    // Xử lý kết quả trả về từ hàm signInWithGoogle
    if (isSignedIn) {
      // Đăng nhập thành công, điều hướng hoặc thực hiện các hành động tiếp theo
      return true;
    } else {
      // Xử lý khi đăng nhập không thành công
      return false;
    }
  }

  Future<String> signInWithPhoneNumber(String phoneNumber) async {
    try {
      String verificationId = await authRepo.signInWithPhoneNumber(phoneNumber);
      return verificationId;
    } catch (e) {
      // Xử lý lỗi nếu cần
      print('Error signing in with phone number: $e');
      rethrow;
    }
  }

  // Hàm xác thực mã OTP
  Future<UserCredential> verifyOTP(
      String verificationId, String smsCode) async {
    try {
      UserCredential userCredential =
          await authRepo.verifyOTP(verificationId, smsCode);
      return userCredential;
    } catch (e) {
      // Xử lý lỗi nếu cần
      print('Error verifying OTP from vm: $e');
      rethrow;
    }
  }
}
