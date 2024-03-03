import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../utils/common_func.dart';
import 'auth_repo.dart';

class AuthRepoImpl with AuthRepo {
  bool isUserLoggedInWithEmail = false;

  Future<User?>? _currentUser = null;
  @override
  String? _currentUid;
  final _googleSignIn = GoogleSignIn();

  // Getter để lấy giá trị uid
  String? get currentUid => _currentUid;
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
      _currentUid = credential.user?.uid;
            isUserLoggedInWithEmail = true; // Đánh dấu người dùng đăng nhập bằng email

      if (isCheckAdmin) {
        bool isAdmin = false;
        final doc = await FirebaseFirestore.instance
            .collection('USERS')
            .doc(credential.user?.uid)
            .get();
        if (doc.exists) {
          isAdmin = doc.data()?['isAdmin'] as bool;
        }
        if (isAdmin) {
          print(FirebaseAuth.instance.currentUser?.email);
          return FirebaseAuth.instance.currentUser;
        } else {
          CommonFunc.showToast(
              "Tài khoản của bạn không có quyền của người bán.");
          return null;
        }
      } else {
        print(FirebaseAuth.instance.currentUser?.email);
        return FirebaseAuth.instance.currentUser;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        CommonFunc.showToast("Không tìm thấy người dùng.");
      } else if (e.code == 'wrong-password') {
        CommonFunc.showToast("Sai tài khoản/mật khẩu.");
      } else {
        CommonFunc.showToast("Đăng nhập thất bại");
      }
    } catch (e) {
      CommonFunc.showToast("Đã xảy ra lỗi: $e");
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

  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Future<bool> editProfile(String newName, String newAddress,
  //     String newPhoneNumber, String oldPassword, String newPassword) async {
  //   try {
  //     // Lấy người dùng hiện tại
  //     User? currentUser = _auth.currentUser;

  //     // Kiểm tra mật khẩu mới nếu được cung cấp
  //     if (oldPassword.isNotEmpty && newPassword.isNotEmpty) {
  //       if (newPassword == oldPassword) {
  //         CommonFunc.showToast("Mật khẩu mới trùng mật khẩu cũ");
  //         return false;
  //       }

  //       // Xác thực người dùng bằng mật khẩu cũ
  //       AuthCredential credential = EmailAuthProvider.credential(
  //           email: currentUser!.email!, password: oldPassword);
  //       await currentUser.reauthenticateWithCredential(credential);

  //       // Thay đổi mật khẩu
  //       await currentUser.updatePassword(newPassword);
  //     }

  //     // Cập nhật thông tin người dùng trong Firestore
  //     await _firestore.collection('USERS').doc(currentUser?.uid).update({
  //       'username': newName,
  //       'address': newAddress,
  //       'phone': newPhoneNumber,
  //     });

  //     // Trả về true để thể hiện rằng thông tin đã được cập nhật thành công
  //     return true;
  //   } catch (error) {
  //     // Xử lý lỗi (nếu có)
  //     print('Error updating user data: $error');

  //     // Kiểm tra nếu lỗi là do xác thực mật khẩu cũ không thành công
  //     if (error is FirebaseAuthException && error.code == 'wrong-password') {
  //       // Nếu mật khẩu cũ không chính xác, thông báo cho người dùng biết
  //       print('Old password is incorrect');
  //     }

  //     // Trả về false để thể hiện rằng có lỗi xảy ra
  //     return false;
  //   }
  // }
  Future<bool> editProfile(String newName, String newAddress,
      String newPhoneNumber) async {
    try {
      // Lấy người dùng hiện tại
      User? currentUser = _auth.currentUser;

    

      // Cập nhật thông tin người dùng trong Firestore
      await _firestore.collection('USERS').doc(currentUser?.uid).update({
        'username': newName,
        'address': newAddress,
        'phone': newPhoneNumber,
      });

      // Trả về true để thể hiện rằng thông tin đã được cập nhật thành công
      return true;
    } catch (error) {
      // Xử lý lỗi (nếu có)
      print('Error updating user data: $error');

     

     
      return false;
    }
  }

  Future<List<String>> getUserInfo() async {
    try {
      // Lấy dữ liệu người dùng từ Firestore
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('USERS')
          .doc(_currentUid!)
          .get();

      // Kiểm tra xem dữ liệu người dùng có tồn tại không
      if (userSnapshot.exists) {
        // Lấy thông tin từ dữ liệu người dùng
        String username = userSnapshot.get('username') ?? '';
        String address = userSnapshot.get('address') ?? '';
        String phone = userSnapshot.get('phone') ?? '';

        // Trả về kết quả dưới dạng danh sách
        return [username, address, phone];
      } else {
        // Trường hợp dữ liệu người dùng không tồn tại, trả về danh sách rỗng
        return ['', '', ''];
      }
    } catch (error) {
      // Xử lý lỗi nếu có
      print('Error getting user data: $error');

      // Trả về danh sách rỗng trong trường hợp có lỗi xảy ra
      return ['', '', ''];
    }
  }

  Future<bool> signInWithGoogle() async {
    try {
            isUserLoggedInWithEmail = false; // Đánh dấu người dùng đăng nhập bằng Google

      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final AuthCredential authCredential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );
        final UserCredential userCredential =
            await FirebaseAuth.instance.signInWithCredential(authCredential);
        final User user = userCredential.user!;
        final String email = user.email ?? '';
        _currentUid = userCredential.user?.uid;

        // Check if the email already exists in the database
        bool emailExists = await isEmailExistsInUsers(email);

        if (emailExists) {
          // Tồn tại email
          return false;
        } else {
          // Email mới hoàn toàn
          return true;
        }
      }
    } catch (e) {
      // Handle errors
      print("Sign in with Google error: ${e.toString()}");
    }

    return false;
  }

  Future<bool> addUserByGoogleSignIn({
    required String phone,
    required String address,
    required String username,
    required bool isAdmin,
  }) async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final AuthCredential authCredential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );
        final UserCredential userCredential =
            await FirebaseAuth.instance.signInWithCredential(authCredential);
        final User user = userCredential.user!;
        final String email = user.email ?? '';

        // Kiểm tra xem email đã tồn tại trong collection USERS hay không
        bool emailExists = await isEmailExistsInUsers(email);
        if (emailExists) {
          // Email đã tồn tại trong USERS, nên chỉ cần cập nhật thông tin
          await FirebaseFirestore.instance
              .collection('USERS')
              .doc(user.uid)
              .update({
            'phone': phone,
            'address': address,
            'username': username,
            'isAdmin': isAdmin,
          });
        } else {
          // Email chưa tồn tại trong USERS, thêm tài liệu mới
          await FirebaseFirestore.instance
              .collection('USERS')
              .doc(user.uid)
              .set({
            'email': email,
            'phone': phone,
            'address': address,
            'username': username,
            'isAdmin': isAdmin,
          });
        }

        return true; // Trả về true nếu thêm thành công
      }
    } catch (e) {
      print("add user error: ${e.toString()}");
    }
    return false; // Trả về false nếu có lỗi xảy ra
  }

  Future<bool> isEmailExistsInUsers(String email) async {
    try {
      // Get a list of all users from Firestore
      QuerySnapshot usersSnapshot = await FirebaseFirestore.instance
          .collection('USERS')
          .where('email', isEqualTo: email)
          .get();

      // Check if any user has the email
      return usersSnapshot.docs.isNotEmpty;
    } catch (error) {
      print('Error checking email existence: $error');
      return false;
    }
  }

  Future<void> logout() async {
    try {
      // Đăng xuất khỏi Google Sign-In
      await _googleSignIn.signOut();

      // Đăng xuất khỏi Firebase Auth
      await FirebaseAuth.instance.signOut();

      // Xóa thông tin đăng nhập trước đó
      _currentUid = null;
    } catch (e) {
      // Xử lý lỗi nếu có
      print("Error during logout: $e");
      EasyLoading.dismiss();
    }
  }
}
