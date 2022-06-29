import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class PaymentSuccess extends StatelessWidget {
  const PaymentSuccess({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Lottie.asset(
              "assets/images/success.json",
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 3,
            ),
            Column(
              children: [
                Text(
                  " Order Successful",
                  style: TextStyle(
                      color: Color(0xff247509),
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      fontFamily: "Rubik"),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  " You will be recive it with in 3-4 days ",
                  style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      fontFamily: "Rubik"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
