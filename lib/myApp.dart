import 'package:flutter/material.dart';

import 'screens/loginScreen.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fliq Dating',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.pink,
        fontFamily: 'Roboto',
      ),
      home: LoginScreen(),
      // MessagingScreen()
    );
  }
}
