import 'package:delayed_display/delayed_display.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final email_controller = TextEditingController();
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
          "Reset Password",
          style: TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontFamily: "Rubik",
              fontWeight: FontWeight.w500),
        ),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            DelayedDisplay(
              child: Text(
                "Enter your email and we will send you a link to reset your password.",
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
            ),
            SizedBox(
              height: 30,
            ),
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
            ),
            SizedBox(
              height: 30,
            ),
            Spacer(),
            DelayedDisplay(
              child: TextButton(
                  onPressed: () {
                    if (email_controller.text != "") {
                      reset(email_controller.text);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: Colors.red,
                          content: Text("Please Enter your email")));
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
                      "Reset Password",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    )),
                  )),
            ),
          ],
        ),
      )),
    );
  }

  void reset(String email) async {
    await auth
        .sendPasswordResetEmail(email: email)
        .then((uid) => {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: Colors.green,
                  content: Text("Password Reset email send successfully")))
            })
        .catchError((e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(backgroundColor: Colors.red, content: Text(e!.message)));
    });
  }
}
