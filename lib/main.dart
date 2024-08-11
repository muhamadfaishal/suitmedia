import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suitmedia/model/user_model.dart';
import 'package:suitmedia/pages/FirstScreen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserModel(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Poppins',
      ),
      home: FirstScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
