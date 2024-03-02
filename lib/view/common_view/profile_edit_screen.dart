import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:three_tapp_app/viewmodel/auth_viewmodel.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  AuthViewModel authViewModel=AuthViewModel();
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController newpasswordController = TextEditingController();

  TextEditingController phoneController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _getUserInfo();
  }

  Future<void> _getUserInfo() async {
    List<String> userInfo = await authViewModel.getUserInfo(); 
    nameController.text = userInfo[0];
    addressController.text = userInfo[1];
    phoneController.text = userInfo[2];
  }

  Future<void> editProfile() async {
    String newName = nameController.text;
    String newAddress = addressController.text;
    String password=passwordController.text;
    String newPassword = newpasswordController.text;
    String newPhone = phoneController.text;
    bool success = await authViewModel.editProfile(newName,newAddress,newPhone,password,newPassword);

  if (success) {
    // Show success message
    Fluttertoast.showToast(
                          msg: "Cập nhật thông tin thành công.",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.black45,
                          textColor: Colors.white,
                          fontSize: 12.0,
                        );
  } else {
    // Show failure message
    Fluttertoast.showToast(
                          msg: "Cập nhật thông tin thât bại.",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.black45,
                          textColor: Colors.white,
                          fontSize: 12.0,
                        );
  }    


    // In thông tin mới
    print('New Name: $newName');
    print('New Address: $newAddress');
    print('Password: $password');
    print('New Password: $newPassword');
    print('New Phone: $newPhone');
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
              // Phần đầu (Avatar)
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.transparent,
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/default-avatar.png',
                    fit: BoxFit.cover, // Đảm bảo ảnh vừa vặn
                    width: 100, // Đặt kích thước ảnh
                    height: 100,
                  ),
                ),
              ),
              SizedBox(height: 13),
              // Phần thân
              // Phần Họ và tên
              _buildTextField('Họ và tên :', nameController, height: 40),
              // Phần address
              _buildTextField('Địa chỉ : ', addressController, height: 40),
              // Phần phone
              _buildTextField('Số điện thoại : ', phoneController, height: 40),
              _buildTextField('Mật khẩu cũ :', passwordController, height: 40,isPassword: true),
              _buildTextField('Mật khẩu mới :', newpasswordController, height: 40,isPassword: true),
              // Phần Password
              //_buildTextField('Password', passwordController, isPassword: true),

              Align(
                alignment: Alignment.center,
                child: Container(
                  width: MediaQuery.of(context).size.width / 2,
                  child: ElevatedButton(
                    onPressed: editProfile,
                    style: ElevatedButton.styleFrom(
                      primary:Colors.green, // Màu nền xanh lá
                      onPrimary: Colors.white, // Màu chữ trắng
                    ),
                    child: Text('Chỉnh sửa'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget tái sử dụng để xây dựng phần nhập liệu
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
          obscureText: isPassword, // Sử dụng trực tiếp giá trị của isPassword
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
                        // Đảo ngược giá trị của isPassword
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
