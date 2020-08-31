import 'package:flutter/material.dart';
import 'package:labors/Screens/clientRequest.dart';
import 'package:labors/Screens/homeScreen.dart';
import 'package:labors/Screens/registration.dart';
import 'package:labors/Screens/showAddress.dart';
import 'package:labors/Screens/sign_In.dart';
import 'package:labors/Screens/splash_Screen.dart';

import 'Screens/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        accentColor: Colors.black,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: <String, WidgetBuilder>{
        '/home': (BuildContext context) => HomeScreen(),
        'Map': (BuildContext context) => CustomMap(),
        'ClientRequest': (BuildContext context) => ClientRequest(),
        '/SignIn': (BuildContext context) => SignIn(),
        '/Registration': (BuildContext context) => Registration(),
        '/UserLocation': (BuildContext context) => UserLocation(),
      },
      home: SplashScreen(),
    );
  }
}
