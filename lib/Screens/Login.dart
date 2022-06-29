import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:Socmed/Screens/Home.dart';
import 'package:Socmed/Screens/ResetPassword.dart';
import 'package:Socmed/model/usermodel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool passwordVisible = true;
  final email_controller = TextEditingController();
  final password_controller = TextEditingController();
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
          "Login",
          style: TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontFamily: "Rubik",
              fontWeight: FontWeight.w500),
        ),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                height: 30,
              ),
              DelayedDisplay(
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
                          storeData(
                              googleSignInAccount.email,
                              googleSignInAccount.displayName!,
                              googleSignInAccount.photoUrl!);
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
                              "Login with Google",
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
                              "Login with Facebook",
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
              SizedBox(
                height: 10,
              ),
              DelayedDisplay(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      height: 10.0,
                      child: new Center(
                        child: new Container(
                          margin: const EdgeInsetsDirectional.only(
                              start: 1.0, end: 1.0),
                          height: 1.0,
                          width: MediaQuery.of(context).size.width / 3,
                          color: Colors.grey[500],
                        ),
                      ),
                    ),
                    Text(
                      "OR",
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 16,
                        fontFamily: "Rubik",
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                      child: new Center(
                        child: new Container(
                          margin: const EdgeInsetsDirectional.only(
                              start: 1.0, end: 1.0),
                          height: 1.0,
                          width: MediaQuery.of(context).size.width / 3,
                          color: Colors.grey[500],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    DelayedDisplay(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                          "Email Address",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontFamily: "Rubik",
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    DelayedDisplay(
                      child: Container(
                        height: 56,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20)),
                        child: Center(
                          child: TextFormField(
                            controller: email_controller,
                            keyboardType: TextInputType.emailAddress,
                            onSaved: (value) {
                              email_controller.text = value!;
                            },
                            textInputAction: TextInputAction.next,
                            cursorColor: Color(0xff6A5AE0),
                            decoration: InputDecoration(
                              hintText: "Your email address",
                              border: InputBorder.none,
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide:
                                      BorderSide(color: Color(0xff6A5AE0))),
                              prefixIcon: Icon(
                                Icons.email_outlined,
                                color: Color(0xff6A5AE0),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    DelayedDisplay(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                          "Password",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontFamily: "Rubik",
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    DelayedDisplay(
                      child: Container(
                        height: 56,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20)),
                        child: Center(
                          child: TextFormField(
                            controller: password_controller,
                            obscureText: passwordVisible,
                            keyboardType: TextInputType.visiblePassword,
                            onSaved: (value) {
                              password_controller.text = value!;
                            },
                            textInputAction: TextInputAction.done,
                            cursorColor: Color(0xff6A5AE0),
                            decoration: InputDecoration(
                              hintText: "Your password",
                              border: InputBorder.none,
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide:
                                      BorderSide(color: Color(0xff6A5AE0))),
                              prefixIcon: Icon(
                                Icons.lock_outlined,
                                color: Color(0xff6A5AE0),
                              ),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    passwordVisible = !passwordVisible;
                                  });
                                },
                                icon: Icon(
                                  passwordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.grey[500],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    DelayedDisplay(
                      child: TextButton(
                          onPressed: () {
                            if (email_controller.text != "") {
                              if (password_controller.text.length > 5) {
                                signIn(email_controller.text,
                                    password_controller.text);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    duration: Duration(milliseconds: 300),
                                    backgroundColor: Colors.red,
                                    content: Text(
                                        "Please Enter your password (Min. 6 character)")));
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      duration: Duration(milliseconds: 300),
                                      backgroundColor: Colors.red,
                                      content:
                                          Text("Please Enter your email")));
                            }
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 56,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Color(0xff6A5AE0)),
                            child: Center(
                                child: Text(
                              "Login",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            )),
                          )),
                    ),
                    DelayedDisplay(
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ResetPassword()));
                        },
                        child: Text(
                          "Forgot password?",
                          style:
                              TextStyle(fontSize: 16, color: Color(0xFF6A5AE0)),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    DelayedDisplay(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "By continuing, you agree to the ",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 14, color: Colors.grey[500]),
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
                      child: Text(
                        " & Privacy Policy.",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      )),
    );
  }

  void storeData(String email, String name, String photo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email);
    await prefs.setString('name', name);
    await prefs.setString('photo', photo);
  }

  void signIn(String email, String password) async {
    await auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((uid) => {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: Colors.green,
                  content: Text("Login Successful"))),
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => Home()))
            })
        .catchError((e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(backgroundColor: Colors.red, content: Text(e!.message)));
    });
  }
}
