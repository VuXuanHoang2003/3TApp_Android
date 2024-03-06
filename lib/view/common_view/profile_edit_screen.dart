import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:three_tapp_app/viewmodel/auth_viewmodel.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  AuthViewModel authViewModel = AuthViewModel();
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  String? _avatarUrl1; // Đường dẫn của ảnh người dùng
  String? _avatarUrl2; // Đường dẫn của ảnh đại diện mới

  File? _imageFile; // To store the selected image file

  @override
  void initState() {
    _getUserInfo();
    super.initState();
  }
  
  Future<void> _getUserInfo() async {
    List<String> userInfo = await authViewModel.getUserInfo();
    setState(() {
      nameController.text = userInfo[0];
      addressController.text = userInfo[1];
      phoneController.text = userInfo[2];
      _avatarUrl1= userInfo[3]; 
      // Gán đường dẫn của ảnh từ avatarUrl
      print("Ảnh cũ nè");
      print(_avatarUrl1);
    });
  }
  
Future<String?> getAvatarUrl(String userId) async {
    try {
      // Tạo đối tượng Firebase Storage
      firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;

      // Tạo tham chiếu đến thư mục của người dùng
      firebase_storage.Reference userRef = storage.ref().child('user').child(userId);

      // Lấy đường dẫn của ảnh đại diện từ thư mục người dùng
      String url = await userRef.getDownloadURL();

      // Trả về đường dẫn của ảnh đại diện
      return url;
    } catch (e) {
      // Xử lý lỗi nếu có
      print('Error getting avatar URL: $e');
      return null;
    }
  }
  Future<void> editProfile() async {
    print("hàm edit nè");
    String newName = nameController.text;
    String newAddress = addressController.text;
    String newPhone = phoneController.text;
    String? userId = authViewModel.getCurrentUserID();

    // Nếu chọn ảnh mới
    if (_imageFile != null) {
      print("Chọn ảnh đại diện mới rồi");
      // bool success = await authViewModel.uploadAvatar(_imageFile!, userId!);

      // if (success) {
      // //_avatarUrl1 = await getAvatarUrl(userId); // Cập nhật lại đường dẫn ảnh mới
      // } else {
      //   Fluttertoast.showToast(
      //     msg: "An error occurred while uploading the image.",
      //     toastLength: Toast.LENGTH_SHORT,
      //     gravity: ToastGravity.CENTER,
      //     timeInSecForIosWeb: 1,
      //     backgroundColor: Colors.black45,
      //     textColor: Colors.white,
      //     fontSize: 12.0,
      //   );
      //   return;
      // }
    }

    bool success = await authViewModel.editProfile(newName, newAddress, newPhone, _imageFile);

    if (success) {
      Fluttertoast.showToast(
        msg: "Cập nhật hồ sơ thành công.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black45,
        textColor: Colors.white,
        fontSize: 12.0,
      );
    } else {
      Fluttertoast.showToast(
        msg: "Cập nhật thông tin thất bại.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black45,
        textColor: Colors.white,
        fontSize: 12.0,
      );
    }
  }

  Future<void> _pickImage(ImageSource source) async {
  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: source);

  if (pickedFile != null) {
    setState(() {
      _imageFile = File(pickedFile.path);
      _avatarUrl2 = pickedFile.path; // Lưu đường dẫn ảnh đại diện mới
      print("Ảnh đại diện mới nè: $_avatarUrl2");
    });
  }
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chỉnh sửa hồ sơ'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
               CircleAvatar(
              radius: 50,
              backgroundColor: Colors.transparent,
              child: ClipOval(
                child: _avatarUrl2 != null
                    ? Image.file(
                        File(_avatarUrl2!), // Hiển thị ảnh mới nếu có
                        fit: BoxFit.cover,
                        width: 100,
                        height: 100,
                      )
                    : _avatarUrl1 != null
                        ? Image.network(
                            _avatarUrl1!, // Hiển thị ảnh ban đầu nếu không có ảnh mới
                            fit: BoxFit.cover,
                            width: 100,
                            height: 100,
                          )
                        : Image.asset(
                            'assets/images/default-avatar.png',
                            fit: BoxFit.cover,
                            width: 50,
                            height: 50,
                          ),
              ),
            ),
              SizedBox(height: 13),
              ElevatedButton(
                onPressed: () {
                  _pickImage(ImageSource.gallery);
                },
                child: Text('Chọn ảnh đại diện mới'),
              ),
              SizedBox(height: 13),
              _buildTextField('Name:', nameController, height: 40),
              _buildTextField('Address:', addressController, height: 40),
              _buildTextField('Phone:', phoneController, height: 40),
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: MediaQuery.of(context).size.width / 2,
                  child: ElevatedButton(
                    onPressed: editProfile,
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green,
                      onPrimary: Colors.white,
                    ),
                    child: Text('Cập nhật hồ sơ'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {bool isPassword = false, double height = 60}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Container(
          height: height,
          child: TextFormField(
            controller: controller,
            obscureText: isPassword,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(vertical: height / 4),
              suffixIcon: isPassword
                  ? IconButton(
                      icon: Icon(
                        isPassword ? Icons.visibility : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          isPassword = !isPassword;
                        });
                      },
                    )
                  : null,
            ),
          ),
        ),
        SizedBox(height: 13),
      ],
    );
  }
}
