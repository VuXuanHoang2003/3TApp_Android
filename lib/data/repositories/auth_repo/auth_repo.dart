import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepo {
  Future<bool> signUp(
      {required String email,
      required String password,
      required String phone,
      required String address,
      required String username,
      required bool isAdmin});
  Future<bool> addUser(User user);
  Future<User?> login(
      {required String email,
      required String password,
      required bool isCheckAdmin});

  Future<bool> editProfile(
    String newName,
    String newAddress,
    String newPhoneNumber,
    String oldPassword,
    String newPassword,
  );
  
  Future<List<String>>getUserInfo();
}
