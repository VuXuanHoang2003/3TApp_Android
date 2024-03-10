

// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:three_tapp_app/main.dart';

// class LanguageChangePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Change Language'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             RadioListTile<String>(
//               title: Text('English'),
//               value: 'en',
//               groupValue: _selectedLanguage,
//               onChanged: (value) {
//                 _saveLanguage(value!);
//                 MyApp.setLocale(context, const Locale('en'));
//               },
//             ),
//             RadioListTile<String>(
//               title: Text('Vietnamese'),
//               value: 'vi',
//               groupValue: _selectedLanguage,
//               onChanged: (value) {
//                 _saveLanguage(value!);
//                 MyApp.setLocale(context, const Locale('vi'));
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   String _selectedLanguage = '';

//   Future<void> _saveLanguage(String languageCode) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setString('languageCode', languageCode);
//     _selectedLanguage = languageCode;
//   }
// }

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:three_tapp_app/main.dart';

class LanguageChangePage extends StatefulWidget {
  @override
  _LanguageChangePageState createState() => _LanguageChangePageState();
}

class _LanguageChangePageState extends State<LanguageChangePage> {
  late String _selectedLanguage;

  @override
  void initState() {
    super.initState();
    _loadSelectedLanguage();
  }

  void _loadSelectedLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedLanguage = prefs.getString('languageCode') ?? 'en';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Language'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RadioListTile<String>(
              title: Text('English'),
              value: 'en',
              groupValue: _selectedLanguage,
              onChanged: (value) {
                _saveLanguage(value!);
                MyApp.setLocale(context, const Locale('en'));
                setState(() {
                  _selectedLanguage = value;
                });
              },
              selected: _selectedLanguage == 'en',
            ),
            RadioListTile<String>(
              title: Text('Vietnamese'),
              value: 'vi',
              groupValue: _selectedLanguage,
              onChanged: (value) {
                _saveLanguage(value!);
                MyApp.setLocale(context, const Locale('vi'));
                setState(() {
                  _selectedLanguage = value;
                });
              },
              selected: _selectedLanguage == 'vi',
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveLanguage(String languageCode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', languageCode);
  }
}
