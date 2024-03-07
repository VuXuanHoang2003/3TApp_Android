import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:three_tapp_app/view/common_view/verify_otp_screen.dart';
import 'package:three_tapp_app/viewmodel/auth_viewmodel.dart';

class PhoneVerificationScreen extends StatefulWidget {
  @override
  _PhoneVerificationScreenState createState() =>
      _PhoneVerificationScreenState();
}

class _PhoneVerificationScreenState extends State<PhoneVerificationScreen> {
  TextEditingController _phoneNumberController = TextEditingController();
  String _selectedCountryCode = '+84'; // Mã quốc gia mặc định
  AuthViewModel _authViewModel = AuthViewModel(); // Khởi tạo AuthViewModel

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nhập số điện thoại'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Chọn mã quốc gia và nhập số điện thoại của bạn:',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 16.0),
            Row(
              children: [
                CountryCodePicker(
                  onChanged: (countryCode) {
                    setState(() {
                      _selectedCountryCode = countryCode.toString();
                    });
                  },
                  initialSelection: 'VN', // Quốc gia mặc định
                  favorite: ['+84', 'VN'], // Danh sách các mã quốc gia ưa thích
                  showCountryOnly: false,
                  showOnlyCountryWhenClosed: false,
                  alignLeft: false,
                ),
                SizedBox(width: 8.0),
                Expanded(
                  child: TextField(
                    controller: _phoneNumberController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      hintText: 'Nhập số điện thoại',
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Xác định số điện thoại hoàn chỉnh
                String fullPhoneNumber =
                    '$_selectedCountryCode${_phoneNumberController.text}';
                // Gọi hàm signInPhone từ authViewModel
                _authViewModel.signInWithPhoneNumber(fullPhoneNumber).then((verificationId) {
                  // Sau khi nhận được mã xác thực, bạn có thể thực hiện các hành động tiếp theo ở đây
                  // Ví dụ: Chuyển sang màn hình nhập mã xác thực
                  
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VerifyOTPScreen(verificationId: verificationId),
                    ),
                  );
                }).catchError((error) {
                  // Xử lý lỗi nếu có
                  print('Error signing in with phone: $error');
                });
              },
              child: Text('Xác nhận'),
            ),
          ],
        ),
      ),
    );
  }
}
