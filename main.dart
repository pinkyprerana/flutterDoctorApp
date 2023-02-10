import 'dart:async';
import 'dart:io';

import 'package:doctor_app/provider/auth_provider.dart';
import 'package:doctor_app/provider/data_provider.dart';
import 'package:doctor_app/provider/find_search_provider.dart';
import 'package:doctor_app/provider/health_record_provider.dart';
import 'package:doctor_app/provider/splash_provider.dart';
import 'package:doctor_app/routes_networking/router.dart';
import 'package:doctor_app/view/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'di_container.dart' as di;

main() async {

    // avoiding certificate verification error
    HttpOverrides.global = new MyHttpOverrides();

    // avoiding Binding and ensureInitialized error
    WidgetsFlutterBinding.ensureInitialized();
    // callling init function from di_container for Shared Pref or get as Instance.
    await di.init();

    print("/*****  App Started  *****/");
    runApp(MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => di.sl<SplashProvider>()),
          ChangeNotifierProvider(create: (context) => di.sl<AuthProvider>()),
          ChangeNotifierProvider(create: (context) => di.sl<FindSearchProvider>()),
          ChangeNotifierProvider(create: (context) => di.sl<HealthRecordProvider>()),
          ChangeNotifierProvider(create: (context) => di.sl<DataProvider>()),

        ],
      child: const MyApp(),
    ));
  // runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static final navigatorKey = GlobalKey<NavigatorState>();


  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState(){
    super.initState();
    MyRouter.setupRouter();

    // Provider.of<SplashProvider>(context, listen: false).initSharedData();
    // _route();

  }
  void _route(){
    Provider.of<SplashProvider>(context,listen: false).initConfig(context).then((bool isSuccess){
      if(isSuccess){
        Timer(const Duration(seconds: 1), () async {
          if (Provider.of<AuthProvider>(context, listen: false).isLoggedIn()) {
            // Provider.of<AuthProvider>(context, listen: false).updateToken();
            Navigator.of(context).pushReplacementNamed(MyRouter.home, arguments: HomeScreen());
          } else {
            // Navigator.of(context).pushReplacementNamed(RouteHelper.onBoarding, arguments: OnBoardingScreen());
          }
        });
      }
    });
  }
  @override
  Widget build(BuildContext context){
    return Consumer<SplashProvider>(
        builder: (context, splashProvider, child){
          return MaterialApp(
            title: "titleApp",
            initialRoute: MyRouter.splash,
            onGenerateRoute: MyRouter.router.generator,
            debugShowCheckedModeBanner: false,
            navigatorKey: MyApp.navigatorKey,
            theme: ThemeData(scaffoldBackgroundColor: Colors.white),
          );
        }
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}
