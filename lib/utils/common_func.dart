import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:three_tapp_app/view/common_view/profile_screen_root.dart';

import '../main.dart';
import '../model/scrap_type.dart';
import '../view/admin/admin_root_screen.dart';
import '../view/common_view/profile_screen.dart';
import '../view/customer/customer_home/customer_root_screen.dart';

class CommonFunc {
  static void showToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black45,
        textColor: Colors.white,
        fontSize: 12.0);
  }

  static void configLoading() {
    EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: 2000)
      ..indicatorType = EasyLoadingIndicatorType.circle
      ..loadingStyle = EasyLoadingStyle.custom
      ..backgroundColor = Colors.grey
      ..indicatorSize = 32.0
      ..radius = 12.0
      ..lineWidth = 2.0
      ..progressColor = Colors.yellow
      ..indicatorColor = Colors.white
      ..textColor = Colors.yellow
      ..maskColor = Colors.blue.withOpacity(0.5)
      ..userInteractions = true
      ..dismissOnTap = false;
  }

  static void goToCustomerRootScreen() {
    Navigator.pushReplacement(
      navigationKey.currentContext!,
      MaterialPageRoute(builder: (context) => CustomerRootScreen()),
    );
  }

  static void goToAdminRootScreen() {
    print("go to admin root");
    Navigator.pushReplacement(
      navigationKey.currentContext!,
      MaterialPageRoute(builder: (context) => AdminRootScreen()),
    );
  }

  static void goToProfileScreen() {
    Navigator.push(
      navigationKey.currentContext!,
      MaterialPageRoute(builder: (context) => ProfileScreenRoot()),
    );
  }

  static String getSenDaNameByType(String sendaType) {
    switch (sendaType) {
      case "giay":
        return "Giấy";
      case "nhua":
        return "Nhựa";
      case "kim_loai":
        return "Kim loại";
      case "thuy_tinh":
        return "Thủy tinh";
      default:
        return "Khác";
    }
  }

  static ScrapType getScrapTypeByName(String scrapType) {
    switch (scrapType) {
      case "giay":
        return ScrapType.giay;
      case "nhua":
        return ScrapType.nhua;
      case "kim_loai":
        return ScrapType.kim_loai;
      case "thuy_tinh":
        return ScrapType.thuy_tinh;
      default:
        return ScrapType.khac;
    }
  }

  static String getUsernameByEmail(String? email) {
    if (email == null) {
      return "Unknown username";
    }
    return email.split("@").first;
  }
  static Future<String> getUsernameByUid(String uid) async {
  try {
    // Kết nối đến Firestore collection 'USERS'
    final CollectionReference usersCollection = FirebaseFirestore.instance.collection('USERS');

    // Truy vấn người dùng có UID tương ứng
    QuerySnapshot querySnapshot = await usersCollection.where('uid', isEqualTo: uid).get();

    // Lấy danh sách các tài khoản có UID tương ứng
    List<DocumentSnapshot> userList = querySnapshot.docs;

    // Kiểm tra xem có người dùng nào hay không
    if (userList.isNotEmpty) {
      // Lấy username từ người dùng đầu tiên (nếu có nhiều người dùng cùng UID)
      String username = getUsernameByEmail(userList.first['email']);
      return username;
    } else {
      return "Unknown username";
    }
  } catch (e) {
    print('Lỗi khi truy cập Firestore: $e');
    return "Unknown username";
  }
}

  static Future<Map<String, dynamic>?> getUserInfoFromFirebase(String uid) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await FirebaseFirestore.instance.collection('USERS').doc(uid).get();
      if (documentSnapshot.exists) {
        return documentSnapshot.data();
      }
    } catch (e) {
      print('Error fetching user info from Firestore: $e');
    }

    return null;
  }

  static String getOrderStatusName(String status) {
    switch (status) {
      case "NEW":
        return "Mới tạo";
      case "PROCESSING":
        return "Đang xử lý";
      case "DONE":
        return "Đã giao";
      case "CANCEL":
        return "Đã huỷ";
      default:
        return "Mới tạo";
    }
  }

  static Color getOrderStatusColor(String status) {
    switch (status) {
      case "NEW":
        return Colors.black;
      case "PROCESSING":
        return Colors.blueAccent;
      case "DONE":
        return Colors.green;
      default:
        return Colors.black;
    }
  }
}
