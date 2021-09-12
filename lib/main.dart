import 'package:flutter/material.dart';
import 'package:super_mario_game/MyHomePage.dart';
import 'package:super_mario_game/SuperMario.dart';

MarioState currentStateOfMario;
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}
