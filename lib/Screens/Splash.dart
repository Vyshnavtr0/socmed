import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:Socmed/Screens/Home.dart';
import 'package:Socmed/Screens/Login.dart';
import 'package:Socmed/Screens/Sign_up.dart';
import 'package:delayed_display/delayed_display.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  final auth = FirebaseAuth.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nextscreen(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
          decoration: BoxDecoration(
              /*  image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(
              "assets/images/bg.png",
            ),
          )*/
              ),
          child: Center(
              child: Image.asset(
            "assets/images/logo.jpeg",
            width: MediaQuery.of(context).size.width / 1.5,
            height: MediaQuery.of(context).size.width / 1.5,
          ))),
    );
  }

  Future<void> nextscreen(ctx) async {
    await Future.delayed(Duration(seconds: 3));
    if (auth.currentUser == null) {
      showMaterialModalBottomSheet(
          bounce: true,
          duration: Duration(milliseconds: 1000),
          isDismissible: false,
          expand: false,
          context: ctx,
          backgroundColor: Colors.transparent,
          builder: (context) => Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width / 1.6,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50), topRight: Radius.zero)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Spacer(),
                      DelayedDisplay(
                        delay: Duration(milliseconds: 500),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                            "   Welcome to Socmed !",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                      Spacer(),
                      DelayedDisplay(
                        delay: Duration(milliseconds: 500),
                        child: TextButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => Sign_Up()));
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width / 1.2,
                              height: 56,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Color(0xff6A5AE0)),
                              child: Center(
                                  child: Text(
                                "Sign Up",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              )),
                            )),
                      ),
                      Spacer(),
                      DelayedDisplay(
                        delay: Duration(milliseconds: 500),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Already have an account ?",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 16, color: Colors.grey[500]),
                            ),
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => Login()));
                                },
                                child: Text(
                                  "login",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 16, color: Color(0xff6A5AE0)),
                                )),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ));
    } else {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => Home()));
    }
  }
}
