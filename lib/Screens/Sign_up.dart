import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Socmed/Screens/Home.dart';
import 'package:Socmed/Screens/Login.dart';
import 'package:Socmed/Screens/Sign_up_email.dart';
import 'package:Socmed/model/usermodel.dart';

class Sign_Up extends StatefulWidget {
  const Sign_Up({Key? key}) : super(key: key);

  @override
  _Sign_UpState createState() => _Sign_UpState();
}

class _Sign_UpState extends State<Sign_Up> {
  final auth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  GoogleSignInAccount? googleSignInAccount;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffE5E5E5),
      appBar: AppBar(
        leading: BackButton(
          color: Colors.black,
        ),
        elevation: 0,
        backgroundColor: Color(0xffE5E5E5),
        centerTitle: true,
        title: Text(
          "Sign Up",
          style: TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontFamily: "Rubik",
              fontWeight: FontWeight.w500),
        ),
      ),
      body: SafeArea(
          child: Column(
        children: [
          SizedBox(
            height: 30,
          ),
          DelayedDisplay(
            delay: Duration(milliseconds: 500),
            child: TextButton(
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => Email()));
                },
                child: Container(
                  width: MediaQuery.of(context).size.width / 1.2,
                  height: 56,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Color(0xff6A5AE0)),
                  child: Center(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.email_outlined,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Sign Up with Email",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ],
                  )),
                )),
          ),
          DelayedDisplay(
            delay: Duration(milliseconds: 500),
            child: Center(
              child: TextButton(
                  onPressed: () async {
                    try {
                      final GoogleSignInAccount? googleSignInAccount =
                          await _googleSignIn.signIn();
                      final GoogleSignInAuthentication
                          googleSignInAuthentication =
                          await googleSignInAccount!.authentication;
                      final AuthCredential credential =
                          GoogleAuthProvider.credential(
                        accessToken: googleSignInAuthentication.accessToken,
                        idToken: googleSignInAuthentication.idToken,
                      );
                      await auth.signInWithCredential(credential);
                      FirebaseFirestore firebaseFirestore =
                          FirebaseFirestore.instance;

                      usermodel userModel = usermodel();

                      userModel.email = googleSignInAccount.email;
                      userModel.uid = googleSignInAccount.id;
                      userModel.name = googleSignInAccount.displayName;
                      storeData(googleSignInAccount.email,
                          googleSignInAccount.displayName!);
                      await firebaseFirestore
                          .collection("Users")
                          .doc(googleSignInAccount.id)
                          .set(userModel.toMap());
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: Colors.green,
                          content: Text("Account Created Successfully")));
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => Home()));
                    } on FirebaseAuthException catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: Colors.red,
                          content: Text(e.message!)));
                      print(e.message);
                      throw e;
                    }
                  },
                  child: Container(
                    height: 56,
                    width: MediaQuery.of(context).size.width / 1.2,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.network(
                          "https://res.cloudinary.com/queezy/image/upload/v1638378293/google_gaprlx.png",
                          width: 20,
                          height: 20,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Sign Up with Google",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontFamily: "Rubik",
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  )),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          DelayedDisplay(
            delay: Duration(milliseconds: 500),
            child: Center(
              child: TextButton(
                  onPressed: () {},
                  child: Container(
                    height: 56,
                    width: MediaQuery.of(context).size.width / 1.2,
                    decoration: BoxDecoration(
                        color: Color(0xff0056B2),
                        borderRadius: BorderRadius.circular(20)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.network(
                          "https://res.cloudinary.com/queezy/image/upload/v1638378283/facebook_fabnmu.png",
                          width: 20,
                          height: 20,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Sign Up with Facebook",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: "Rubik",
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  )),
            ),
          ),
          DelayedDisplay(
            delay: Duration(milliseconds: 500),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already have an account ?",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey[500]),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => Login()));
                  },
                  child: Text(
                    "Login",
                    style: TextStyle(fontSize: 16, color: Color(0xFF6A5AE0)),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 30,
          ),
          DelayedDisplay(
            delay: Duration(milliseconds: 500),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "By continuing, you agree to the ",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                ),
                Text(
                  "Terms of Services",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.black),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 5,
          ),
          DelayedDisplay(
            delay: Duration(milliseconds: 500),
            child: Text(
              " & Privacy Policy.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.black),
            ),
          ),
        ],
      )),
    );
  }

  void storeData(String email, String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email);
    await prefs.setString('name', name);
  }
}
