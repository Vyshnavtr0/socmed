import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Socmed/Screens/Home.dart';
import 'package:Socmed/model/usermodel.dart';

class Email extends StatefulWidget {
  const Email({Key? key}) : super(key: key);

  @override
  _EmailState createState() => _EmailState();
}

class _EmailState extends State<Email> {
  final List<String> titileList = [
    "What’s your email?",
    "What’s your password?",
    "Create a username"
  ];
  int current = 0;
  bool passwordVisible = true;
  String passlen = "";

  final email_controller = TextEditingController();
  final password_controller = TextEditingController();
  final name_controller = TextEditingController();
  final auth = FirebaseAuth.instance;

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
          titileList[current],
          style: TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontFamily: "Rubik",
              fontWeight: FontWeight.w500),
        ),
      ),
      body: SafeArea(
          child: SizedBox(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Center(
                child: current == 0
                    ? DelayedDisplay(child: email(context))
                    : current == 1
                        ? Password(context)
                        : username(context),
              ),
              Spacer(),
              DelayedDisplay(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: Text(" $current of 3",
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: "Rubik",
                              fontWeight: FontWeight.w500,
                              color: Color(0xff6A5AE0),
                            )),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            LinearPercentIndicator(
                              width: MediaQuery.of(context).size.width / 1.2,
                              lineHeight: 10.0,
                              animation: true,
                              restartAnimation: true,
                              animationDuration: 3000,
                              curve: Curves.bounceInOut,
                              percent: current == 0
                                  ? .1
                                  : current == 1
                                      ? .3
                                      : current == 2
                                          ? .6
                                          : 1,
                              backgroundColor: Colors.grey[400],
                              progressColor: Color(0xff6A5AE0),
                            ),
                          ]),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              DelayedDisplay(
                child: TextButton(
                    onPressed: () {
                      if (current == 0) {
                        if (email_controller.text != "") {
                          setState(() {
                            current = 1;
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              duration: Duration(milliseconds: 300),
                              backgroundColor: Colors.red,
                              content: Text("Please Enter your email")));
                        }
                      }
                      if (current == 1) {
                        if (password_controller.text.length > 5) {
                          setState(() {
                            current = 2;
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              duration: Duration(milliseconds: 300),
                              backgroundColor: Colors.red,
                              content: Text(
                                  "Please Enter your password (Min. 6 character)")));
                        }
                      }
                      if (current == 2) {
                        if (name_controller.text != "") {
                          signUp(
                              email_controller.text, password_controller.text);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              duration: Duration(milliseconds: 300),
                              backgroundColor: Colors.red,
                              content: Text("Please Enter your name")));
                        }
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
                        "Next",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      )),
                    )),
              ),
              SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
      )),
    );
  }

  DelayedDisplay username(BuildContext context) {
    return DelayedDisplay(
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            child: Text(
              "Username",
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontFamily: "Rubik",
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 56,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: Center(
              child: TextField(
                controller: name_controller,
                keyboardType: TextInputType.text,
                cursorColor: Color(0xff6A5AE0),
                decoration: InputDecoration(
                  hintText: "Your username",
                  border: InputBorder.none,
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Color(0xff6A5AE0))),
                  prefixIcon: Icon(
                    Icons.person_outline,
                    color: Color(0xff6A5AE0),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container Password(BuildContext context) {
    return Container(
      child: DelayedDisplay(
        child: Column(
          children: [
            Container(
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
            SizedBox(
              height: 10,
            ),
            Container(
              height: 56,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: Center(
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      passlen = value;
                    });
                  },
                  controller: password_controller,
                  obscureText: passwordVisible,
                  keyboardType: TextInputType.visiblePassword,
                  cursorColor: Color(0xff6A5AE0),
                  decoration: InputDecoration(
                    hintText: "Your password",
                    border: InputBorder.none,
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Color(0xff6A5AE0))),
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
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Must be at least 6 characters.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey[500]),
                ),
                Icon(
                  Icons.check_box,
                  color: passlen.length >= 6 ? Colors.green : Colors.grey,
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  DelayedDisplay email(BuildContext context) {
    return DelayedDisplay(
      child: Column(
        children: [
          Container(
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
          SizedBox(
            height: 10,
          ),
          Container(
            height: 56,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: Center(
              child: TextField(
                controller: email_controller,
                keyboardType: TextInputType.emailAddress,
                cursorColor: Color(0xff6A5AE0),
                decoration: InputDecoration(
                  hintText: "Your email address",
                  border: InputBorder.none,
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Color(0xff6A5AE0))),
                  prefixIcon: Icon(
                    Icons.email_outlined,
                    color: Color(0xff6A5AE0),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void signUp(String email, String password) async {
    await auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((uid) => {
              postDetailsToFirestore(),
            })
        .catchError((e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(backgroundColor: Colors.red, content: Text(e!.message)));
    });
  }

  void storeData(String email, String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email);
    await prefs.setString('name', name);
  }

  postDetailsToFirestore() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

    User? user = auth.currentUser;
    usermodel userModel = usermodel();

    userModel.email = user!.email;
    userModel.uid = user.uid;
    userModel.name = name_controller.text;
    storeData(user.email!, name_controller.text);
    await firebaseFirestore
        .collection("Users")
        .doc(userModel.uid)
        .set(userModel.toMap());
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.green,
        content: Text("Account Created Successfully")));
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => Home()));
  }
}
