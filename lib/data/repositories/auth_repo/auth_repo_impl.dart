import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../utils/common_func.dart';
import 'auth_repo.dart';

class AuthRepoImpl with AuthRepo {
  @override
  Future<User?> login({
    required String email,
    required String password,
    required bool isCheckAdmin,
  }) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (isCheckAdmin) {
        bool isAdmin = false;
        await FirebaseFirestore.instance
            .collection('USERS')
            .doc(credential.user?.uid)
            .get()
            .then((value) {
          isAdmin = value['isAdmin'] as bool;
        });
        if (isAdmin) {
          return FirebaseAuth.instance.currentUser;
        } else {
          CommonFunc.showToast("Tài khoản của bạn không có quyền Admin.");
          return null;
        }
      } else {
        return FirebaseAuth.instance.currentUser;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        CommonFunc.showToast("Không tìm thấy người dùng.");
      } else if (e.code == 'wrong-password') {
        CommonFunc.showToast("Sai tài khoản/mật khẩu.");
      }
    }
    return null;
  }

  @override
  Future<bool> signUp({
    required String email,
    required String password,
    required String phone,
    required String address,
    required String username, // Thêm trường username
    required bool isAdmin,
  }) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Lưu thông tin người dùng vào Firestore
      if (FirebaseAuth.instance.currentUser != null) {
        await addUser(
          FirebaseAuth.instance.currentUser!,
          phone: phone,
          address: address,
          username: username,
          isAdmin: isAdmin, // Truyền username vào addUser
        ).then((value) {
          print("add user success");
          return Future.value(true);
        }).onError((error, stackTrace) {
          print("add user error: ${error.toString()}");
          return Future.value(false);
        });
      }

      return Future.value(true);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        CommonFunc.showToast("Mật khẩu quá yếu.");
      } else if (e.code == 'email-already-in-use') {
        CommonFunc.showToast("Email đã tồn tại.");
      }
    } catch (e) {
      print("signup error:${e.toString()}");
    }
    return Future.value(false);
  }

  @override
  Future<bool> addUser(User user,
      {String phone = '',
      String address = '',
      String username = '',
      bool isAdmin = false}) async {
    try {
      Map<String, dynamic> userMap = {
        'username': username, // Sử dụng giá trị username được truyền từ signUp
        'email': user.email,
        'isAdmin': isAdmin,
        'phone': phone,
        'address': address,
      };

      await FirebaseFirestore.instance
          .collection('USERS')
          .doc(user.uid)
          .set(userMap);
      return Future.value(true);
    } on FirebaseAuthException catch (e) {
      CommonFunc.showToast("Đã có lỗi xảy ra.");
      print("add user error: ${e.toString()}");
    } catch (e) {
      CommonFunc.showToast("Đã có lỗi xảy ra.");
    }
    return Future.value(false);
  }
}
