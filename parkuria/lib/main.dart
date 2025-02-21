import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parkuria/screens/homeScreen.dart';

void main() {
  runApp(const Uygulamam()); //Ekranı yatay'a cevirir =>
  SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeRight]);
}

class Uygulamam extends StatelessWidget {
  const Uygulamam({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false, //debug sembolunu kaldirir
      home: Homescreen(),
    );
  }
}
