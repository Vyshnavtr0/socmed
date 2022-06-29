import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:unity_ads_plugin/ad/unity_banner_ad.dart';
import 'package:unity_ads_plugin/unity_ads.dart';

class PaymentFail extends StatefulWidget {
  const PaymentFail({Key? key}) : super(key: key);

  @override
  State<PaymentFail> createState() => _PaymentFailState();
}

class _PaymentFailState extends State<PaymentFail> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    UnityAds.init(gameId: "4540281");

    UnityAds.showVideoAd(placementId: "Interstitial_Android");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            Lottie.asset(
              "assets/images/fail.json",
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 3,
            ),
            SizedBox(
              height: 10,
            ),
            Column(
              children: [
                Text(
                  " Payment Failed",
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      fontFamily: "Rubik"),
                ),
              ],
            ),
            Spacer(),
            UnityBannerAd(placementId: "Banner_Android")
          ],
        ),
      ),
    );
  }
}
