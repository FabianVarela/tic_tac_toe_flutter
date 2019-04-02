import 'package:flutter/material.dart';
import 'package:tic_tac_toe_flutter/ui/main_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainScreen(title: 'Tic tac toe'),
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      title: 'Tic Tac Toe',
    );
  }
}
