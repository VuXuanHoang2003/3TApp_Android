import 'package:flutter/material.dart';
import 'package:three_tapp_app/viewmodel/auth_viewmodel.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChangePasswordPage extends StatefulWidget {
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  TextEditingController _oldPasswordController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${AppLocalizations.of(context)?.passwordChange}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            TextFormField(
              controller: _oldPasswordController,
              obscureText: _obscureText,
              decoration: InputDecoration(
                labelText: "${AppLocalizations.of(context)?.oldPassword}",
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _newPasswordController,
              obscureText: _obscureText,
              decoration: InputDecoration(
                labelText: "${AppLocalizations.of(context)?.newPassword}",
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _confirmPasswordController,
              obscureText: _obscureText,
              decoration: InputDecoration(
                labelText: "${AppLocalizations.of(context)?.reenterPassword}",

                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                _changePassword();
              },
              child: Text("${AppLocalizations.of(context)?.passwordChange}"),
            ),
          ],
        ),
      ),
    );
  }

  void _changePassword() {
    // Kiểm tra xem mật khẩu mới và nhập lại mật khẩu mới có trùng khớp không
    if (_newPasswordController.text != _confirmPasswordController.text) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("${AppLocalizations.of(context)?.error}"),
            content: Text('${AppLocalizations.of(context)?.newPassword} ${AppLocalizations.of(context)?.noMatch}'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    AuthViewModel().changePassword(_newPasswordController.text);
  }
}
