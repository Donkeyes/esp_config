
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:esp_config/pages/login/login_page.dart';
import 'package:esp_config/pages/devices/device_page.dart';
import 'package:esp_config/pages/home/home_page.dart';
import 'package:esp_config/pages/network/network_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:esp_config/common/localization/esp_config_localizations_delegate.dart';
import 'package:esp_config/models/devices.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // In this sample app, CatalogModel never changes, so a simple Provider
        // is sufficient.
        //Provider(create: (context) => DevicesModel()),
        // CartModel is implemented as a ChangeNotifier, which calls for the use
        // of ChangeNotifierProvider. Moreover, CartModel depends
        // on CatalogModel, so a ProxyProvider is needed.
        ChangeNotifierProvider(create: (_) => DevicesModel(),)
      ],
      child: MyHomePage()
      ,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Widget build(BuildContext context) {
    // Using MultiProvider is convenient when providing multiple objects.
    return MaterialApp(
      title: 'Esp Config',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',

      ///多语言代理
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        EspConfigLocalizationsDelegate.delegate
      ],
      supportedLocales: [
        //此处
        const Locale('zh', 'CH'),
        const Locale('en', 'US'),
      ],
      routes: {
        '/': (context) => LoginPage(),
        '/home': (context) => HomePage(),
        '/device': (context) => DevicePage(),
      },
    );
  }
}
