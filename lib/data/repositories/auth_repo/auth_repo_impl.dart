import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_sign_in/google_sign_in.dart';
  import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;


import '../../../utils/common_func.dart';
import 'auth_repo.dart';

class AuthRepoImpl with AuthRepo {
  int userMode = 0;

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
      userMode = 1; // Đánh dấu người dùng đăng nhập bằng email

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
  // Future<bool> signUp({
  //   required String email,
  //   required String password,
  //   required String phone,
  //   required String address,
  //   required String username, // Thêm trường username
  //   required bool isAdmin,
  // }) async {
  //   try {
  //     final credential =
  //         await FirebaseAuth.instance.createUserWithEmailAndPassword(
  //       email: email,
  //       password: password,
  //     );

  //     // Lưu thông tin người dùng vào Firestore
  //     if (FirebaseAuth.instance.currentUser != null) {
  //       await addUser(
  //         FirebaseAuth.instance.currentUser!,
  //         phone: phone,
  //         address: address,
  //         username: username,
  //         isAdmin: isAdmin, // Truyền username vào addUser
  //       ).then((value) {
  //         print("add user success");
  //         return Future.value(true);
  //       }).onError((error, stackTrace) {
  //         print("add user error: ${error.toString()}");
  //         return Future.value(false);
  //       });
  //     }

  //     return Future.value(true);
  //   } on FirebaseAuthException catch (e) {
  //     if (e.code == 'weak-password') {
  //       CommonFunc.showToast("Mật khẩu quá yếu.");
  //     } else if (e.code == 'email-already-in-use') {
  //       CommonFunc.showToast("Email đã tồn tại.");
  //     }
  //   } catch (e) {
  //     print("signup error:${e.toString()}");
  //   }
  //   return Future.value(false);
  // }
  Future<bool> editProfile(String newName, String newAddress,
      String newPhoneNumber, File? imageFile) async {
    try {
      // Lấy người dùng hiện tại
      User? currentUser = _auth.currentUser;

      // Upload ảnh mới nếu người dùng đã chọn ảnh
      String? imagePath;
      if (imageFile != null) {
        return uploadAvatar(imageFile, currentUser!.uid);
      }

      // Cập nhật thông tin người dùng trong Firestore
      Map<String, dynamic> userData = {
        'username': newName,
        'address': newAddress,
        'phone': newPhoneNumber,
      };

      // Nếu người dùng đã chọn ảnh mới, cập nhật đường dẫn ảnh vào dữ liệu người dùng
      if (imagePath != null) {
        userData['avatar'] = imagePath;
      }

      await _firestore
          .collection('USERS')
          .doc(currentUser?.uid)
          .update(userData);

      // Trả về true để thể hiện rằng thông tin đã được cập nhật thành công
      return true;
    } catch (error) {
      // Xử lý lỗi (nếu có)
      print('Error updating user data: $error');
      return false;
    }
  }

// Hàm upload ảnh mới lên Firebase Storage và trả về đường dẫn của ảnh
  Future<bool> uploadAvatar(File imageFile, String userId) async {
    try {
      // Tạo tham chiếu tới thư mục của avatar trên Firebase Storage
      Reference storageRef =
          FirebaseStorage.instance.ref().child('users/$userId');

      // Lấy danh sách các tệp tin trong thư mục
      ListResult result = await storageRef.listAll();
      int numberOfFiles = result.items.length;

      // Tạo tên mới cho tệp tin sẽ được tải lên
      String fileName =
          '${numberOfFiles + 1}.jpg'; // Đặt tên cho file ảnh đại diện

      // Tạo tham chiếu đến tệp tin mới
      Reference fileRef = storageRef.child(fileName);

      // Tải ảnh lên Firebase Storage
      await fileRef.putFile(imageFile);

      // Nếu quá trình tải ảnh thành công, trả về true
      return true;
    } catch (e) {
      // Nếu có lỗi xảy ra, in ra lỗi và trả về false
      print("Error uploading avatar from model: $e");
      return false;
    }
  }

// Future<bool> uploadAvatar(File imageFile, String userId) async {
//   try {
//     // Tạo tham chiếu tới thư mục của avatar trên Firebase Storage
//     Reference storageRef = FirebaseStorage.instance.ref().child('users/$userId');

//     // Lấy danh sách các tệp tin trong thư mục
//     ListResult result = await storageRef.listAll();
//     int numberOfFiles = result.items.length;

//     // Tạo tên mới cho tệp tin sẽ được tải lên
//     String fileName = '${numberOfFiles + 1}.jpg'; // Đặt tên cho file ảnh đại diện

//     // Tạo tham chiếu đến tệp tin mới
//     Reference fileRef = storageRef.child(fileName);

//     // Tạo metadata với thông tin thời gian upload
//     SettableMetadata metadata = SettableMetadata(
//       customMetadata: {
//         'upload_time': DateTime.now().millisecondsSinceEpoch.toString(),
//       },
//     );

//     // Tải ảnh lên Firebase Storage với metadata
//     await fileRef.putFile(imageFile, metadata);

//     // Nếu quá trình tải ảnh thành công, trả về true
//     return true;
//   } catch (e) {
//     // Nếu có lỗi xảy ra, in ra lỗi và trả về false
//     print("Error uploading avatar from model: $e");
//     return false;
//   }
// }

  @override

  Future<bool> addUser(User user,
      {String phone = '',
      String address = '',
      String username = '',
      bool isAdmin = false,
      required File avatarFile}) async {
    try {
      String userId = user.uid;
      String fileName = '1.jpg'; // Đặt tên cho file ảnh đại diện
      String userFolder = 'users/$userId'; // Đường dẫn của thư mục người dùng
      Reference storageRef =
          FirebaseStorage.instance.ref().child('$userFolder/$fileName');

      // Tải ảnh lên Firebase Storage
      await storageRef.putFile(avatarFile);

      // Lấy URL của ảnh đại diện sau khi tải lên
      String avatarUrl = await storageRef.getDownloadURL();

      // Lưu thông tin người dùng vào Firestore
      Map<String, dynamic> userMap = {
        'username': username,
        'email': user.email,
        'isAdmin': isAdmin,
        'phone': phone,
        'address': address,
        'avatar': userFolder, // Lưu đường dẫn URL của ảnh đại diện
      };

      await FirebaseFirestore.instance
          .collection('USERS')
          .doc(user.uid)
          .set(userMap);

      return true; // Trả về true nếu thành công
    } catch (e) {
      print("Error adding user: $e");
      return false; // Trả về false nếu có lỗi xảy ra
    }
  }

  @override
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
  //     return Future.value(true);
  //   } on FirebaseAuthException catch (e) {
  //     CommonFunc.showToast("Đã có lỗi xảy ra.");
  //     print("add user error: ${e.toString()}");
  //   } catch (e) {
  //     CommonFunc.showToast("Đã có lỗi xảy ra.");
  //   }
  //   return Future.value(false);
  // }
  Future<bool> signUp({
    required String email,
    required String password,
    required String phone,
    required String address,
    required String username,
    required bool isAdmin,
    required File avatarFile, // Thêm tham số cho ảnh đại diện
  }) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Lưu thông tin người dùng và ảnh đại diện vào Firestore và Firebase Storage
      if (FirebaseAuth.instance.currentUser != null) {
        await addUser(
          FirebaseAuth.instance.currentUser!,
          phone: phone,
          address: address,
          username: username,
          isAdmin: isAdmin,
          avatarFile: avatarFile, // Truyền ảnh đại diện vào hàm addUser
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

  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  
  Future<List<String>> getUserInfo() async {
    try {
      if (_currentUid != null) {
        // Kiểm tra _currentUid có null hay không
        DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
            .collection('USERS')
            .doc(_currentUid!)
            .get();

        if (userSnapshot.exists) {
          String username = userSnapshot.get('username') ?? '';
          String address = userSnapshot.get('address') ?? '';
          String phone = userSnapshot.get('phone') ?? '';
          String userId = _currentUid!;
          String? lastImageURL = await getLatestImageURL(userId);

          return [username, address, phone, lastImageURL ?? ''];
        }
      }
      return ['', '', '', ''];
    } catch (error) {
      print('Error getting user data: $error');
      return ['', '', '', ''];
    }
  }
//   Future<String?> getLatestImageURL(String userId) async {
//   try {
//     // Tạo tham chiếu tới thư mục 'users/$userId'
//     Reference ref = FirebaseStorage.instance.ref('users/$userId');

//     // Lấy danh sách các tệp tin trong thư mục và sắp xếp theo thời gian tải lên
//     ListResult result = await ref.listAll();
//     List<Reference> items = result.items;
//     items.sort((a, b) => b.fullPath.compareTo(a.fullPath)); // sắp xếp theo thời gian tải lên

//     // Nếu có ít nhất một tệp tin trong thư mục
//     if (items.isNotEmpty) {
//       // Lấy tham chiếu tới tệp tin gần nhất
//       Reference latestItem = items.first;

//       // Lấy đường dẫn đến ảnh từ Firebase Storage
//       String imageUrl = await latestItem.getDownloadURL();
//             String imageName = latestItem.name;
//       print('Latest image name: $imageName');

//       // Trả về đường dẫn đến ảnh
      
//       return imageUrl;
//     } else {
//       // Trường hợp không có ảnh trong thư mục, trả về null
//       return null;
//     }
//   } catch (error) {
//     // Xử lý lỗi nếu có
//     print('Error getting latest avatar image URL: $error');
//     return null;
//   }
// }
//here

Future<String?> getLatestImageURL(String userId) async {
  try {
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref('users/$userId');
    
    // Lấy danh sách các items trong thư mục
    firebase_storage.ListResult result = await ref.listAll();
    
    // Sắp xếp danh sách các items theo thứ tự số trong tên file
    List<firebase_storage.Reference> sortedItems = result.items.toList()
      ..sort((a, b) {
        // Lấy số từ tên file
        int numberA = int.parse(a.name.split('.').first);
        int numberB = int.parse(b.name.split('.').first);
        // Sắp xếp tăng dần theo số
        return numberA.compareTo(numberB);
      });
    
    if (sortedItems.isNotEmpty) {
      // Lấy URL của ảnh gần nhất (tức là tệp có số lớn nhất)
      String imageUrl = await sortedItems.last.getDownloadURL();
      // In ra tên của ảnh gần nhất
      String latestImageName = sortedItems.last.name;
      print('Tên của ảnh gần nhất: $latestImageName');
      return imageUrl;
    } else {
      // Trường hợp không có ảnh trong thư mục, trả về null
      return null;
    }
  } catch (error) {
    // Xử lý lỗi nếu có
    print('Error getting latest image URL: $error');
    return null;
  }
}




  
  
  String? getCurrentUserID() {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      return currentUser.uid;
    } else {
      return null;
    }
  }
  Future<bool> signInWithGoogle() async {
    try {
      userMode = 2; // Đánh dấu người dùng đăng nhập bằng Google
     
      // Lấy URL của ảnh đại diện sau khi tải lên
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

  Future<bool> addUserByGoogleSignIn(
      {required String phone,
      required String address,
      required String username,
      required bool isAdmin,
      required File avatarFile}) async {
    try {
      String? userId =getCurrentUserID(); 
      String fileName = '1.jpg'; // Đặt tên cho file ảnh đại diện
      String userFolder = 'users/$userId'; // Đường dẫn của thư mục người dùng
      Reference storageRef =
          FirebaseStorage.instance.ref().child('$userFolder/$fileName');

      // Tải ảnh lên Firebase Storage
      await storageRef.putFile(avatarFile);
      String avatarUrl = '$userFolder/$fileName';

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
            'avatarUrl':avatarUrl,
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
            'avatarUrl':avatarUrl,
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

  Future<String> signInWithPhoneNumber(String phoneNumber) async {
    try {
      String verificationId = '';
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          print('Phone verification failed: $e');
        },
        codeSent: (String verificationIdResult, int? resendToken) {
          print('Code sent to $phoneNumber');
          // Lưu trữ verificationId để sau này sử dụng trong xác thực
          verificationId = verificationIdResult;
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // Thời gian chờ để nhập mã OTP đã hết
          // Có thể xử lý tại đây
        },
        timeout: Duration(seconds: 120), // Thời gian tối đa chờ đợi
      );
      return verificationId; // Trả về verificationId thông qua Future
    } catch (e) {
      print('Error verifying phone number: $e');
      throw e; // Ném ra lỗi nếu có
    }
  }

  // Xác thực mã OTP
  Future<UserCredential> verifyOTP(
      String verificationId, String smsCode) async {
    try {
      // Tạo đối tượng PhoneAuthCredential từ mã OTP và verificationId
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      // Đăng nhập với credential
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      return userCredential;
    } catch (e) {
      print('Error verifying OTP: $e');
      throw e; // Ném ra lỗi nếu có
    }
  }
}
