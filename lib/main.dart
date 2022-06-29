import 'package:Socmed/Screens/Splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    theme: ThemeData(
      accentColor: Color(0xff6A5AE0),
      cursorColor: Color(0xff6A5AE0),
    ),
    home: Socmed(),
  ));
}

class Socmed extends StatelessWidget {
  const Socmed({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Splash();
  }
}
