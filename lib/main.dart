import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:three_tapp_app/utils/common_func.dart';
import 'package:three_tapp_app/utils/notification_controller.dart';
import 'package:three_tapp_app/view/common_view/language_change.dart';
import 'package:three_tapp_app/view/splash_screen/splash_screen.dart';
import 'package:three_tapp_app/viewmodel/auth_viewmodel.dart';
import 'package:three_tapp_app/viewmodel/order_viewmodel.dart';
import 'package:three_tapp_app/viewmodel/post_viewmodel.dart';
import 'package:three_tapp_app/viewmodel/product_viewmodel.dart';
import 'package:intl/intl.dart';

GlobalKey<NavigatorState> navigationKey = GlobalKey();

final formatCurrency =
    NumberFormat.currency(locale: 'vi', decimalDigits: 0, symbol: 'VNĐ');

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await NotificationController.initializeLocalNotifications(debug: true);
  await NotificationController.initializeRemoteNotifications(debug: true);

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.white, // navigation bar color
    statusBarColor: Colors.white, // status bar color
  ));

  // Lấy ngôn ngữ được lưu từ shared preferences
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? languageCode = prefs.getString('languageCode');
  Locale locale =
      languageCode != null ? Locale(languageCode) : const Locale('vi');

  runApp(MyApp(locale: locale));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key, required this.locale}) : super(key: key);

  static void setLocale(BuildContext context, Locale newLocale) {
    final _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    if (state != null) {
      state.setLocale(newLocale);
    }
  }

  final Locale locale;

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Locale _locale;

  void setLocale(Locale newLocale) {
    setState(() {
      _locale = newLocale;
    });
  }

  @override
  void initState() {
    super.initState();
    _locale = widget.locale;
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => ProductViewModel()),
        ChangeNotifierProvider(create: (_) => PostViewModel()),
        ChangeNotifierProvider(create: (_) => OrderViewModel())
      ],
      child: MaterialApp(
        navigatorKey: navigationKey,
        debugShowCheckedModeBanner: false,
        locale: _locale,
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('en'), // English
          const Locale('hi'), // Hindi
          const Locale('vi')
        ],
        home: SplashScreen(), // SplashScreen là màn hình mặc định
        builder: EasyLoading.init(),
        routes: {
          '/language': (context) => LanguageChangePage(),
        },
      ),
    );
  }
}
