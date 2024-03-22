import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepo {
  int get userMode;
//   Future<bool> signUp(
//       {required String email,
//       required String password,
//       required String phone,
//       required String address,
//       required String username,
//       required bool isAdmin
// });
  Future<bool> signUp({
    required String email,
    required String password,
    required String phone,
    required String address,
    required String username,
    required bool isAdmin,
    required File avatarFile, // Thêm tham số cho ảnh đại diện
  });
  // Future<bool> addUser(User user);
  Future<User?> login(
      {required String email,
      required String password,
      required bool isCheckAdmin});

  // Future<bool> editProfile(
  //   String newName,
  //   String newAddress,
  //   String newPhoneNumber,

  // );
  Future<bool> editProfile(String newName, String newAddress,
      String newPhoneNumber, File? imageFile);
  Future<bool> uploadAvatar(File imageFile, String userId);

  Future<bool> addUser(User user,
      {String phone = '',
      String address = '',
      String username = '',
      bool isAdmin = false,
      required File avatarFile});
  Future<bool> addUserByGoogleSignIn(
      {required String phone,
      required String address,
      required String username,
      required bool isAdmin,
      required File avatarFile});
  Future<bool> signInWithGoogle();

  Future<bool> isEmailExistsInUsers(String email);

  Future<List<String>> getUserInfo();
  Future<void> logout();
  Future<String> signInWithPhoneNumber(String phoneNumber);
  Future<UserCredential> verifyOTP(String verificationId, String smsCode);
  Future<List<String>> getUserInfoWidget(String email);
}
