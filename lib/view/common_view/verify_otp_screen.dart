import 'package:flutter/material.dart';
import 'package:three_tapp_app/model/roles_type.dart';
import 'package:three_tapp_app/utils/common_func.dart';
import 'package:three_tapp_app/viewmodel/auth_viewmodel.dart';

class VerifyOTPScreen extends StatefulWidget {
  final String verificationId;

  VerifyOTPScreen({required this.verificationId});

  @override
  _VerifyOTPScreenState createState() => _VerifyOTPScreenState();
}

class _VerifyOTPScreenState extends State<VerifyOTPScreen> {
  TextEditingController _otpController = TextEditingController();
  AuthViewModel _authViewModel = AuthViewModel(); // Khởi tạo AuthViewModel

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Xác thực OTP'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nhập mã OTP đã được gửi đến số điện thoại của bạn:',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Nhập mã OTP',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                String otpCode = _otpController.text;
                print(otpCode);
                // Gọi hàm verifyOTP từ authViewModel
                _authViewModel
                    .verifyOTP(widget.verificationId, otpCode)
                    .then((result) {
                  if (result != null && result.user != null) {
                    // Xác thực thành công
                    if (_authViewModel.rolesType == RolesType.seller) {
                      CommonFunc.goToAdminRootScreen();
                    } else {
                      CommonFunc.goToCustomerRootScreen();
                    }
                  } else {
                    // Xác thực không thành công, mã OTP không khớp
                    print('Mã OTP không hợp lệ.');
                    // Thực hiện các xử lý khác, ví dụ: hiển thị thông báo lỗi
                  }
                }).catchError((error) {
                  // Xử lý lỗi nếu có
                  print("Hello from view");
                  print('Error verifying OTP: $error');
                });
              },
              child: Text('Xác nhận OTP'),
            ),
          ],
        ),
      ),
    );
  }
}
