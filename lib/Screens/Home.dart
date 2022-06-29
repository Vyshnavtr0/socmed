import 'package:Socmed/Screens/Login.dart';
import 'package:Socmed/model/ordermodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Socmed/Screens/Order.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:unity_ads_plugin/ad/unity_banner_ad.dart';
import 'package:unity_ads_plugin/unity_ads.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  final auth = FirebaseAuth.instance;
  int _index = 1;
  double percentage = 0.8;
  String name = "User";
  String email = "";
  String phone = "";
  var lastorder;
  var lastordername = "";
  var lastorderstatus = "";
  String photo =
      "https://res.cloudinary.com/dvhlfyvrr/image/upload/v1638624993/Mask_Group_ajqueh.png";
  List<String> orders = [];

  int i = 0;
  ordermodel orderModel = ordermodel();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getData();
    UnityAds.init(gameId: "4540281");
  }

  void getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() async {
      name = await prefs.getString('name')!;
      email = await prefs.getString('email')!;
      photo = await prefs.getString('photo')!;
      phone = await prefs.getString('phone')!;
      orders = await prefs.getStringList('orders')!;

      lastorder = FirebaseFirestore.instance
          .collection(email)
          .doc(orders.last)
          .get()
          .then((value) {
        setState(() {
          lastordername = "${value['item']} - ${value['order']}";
          lastorderstatus = value['status'];
        });
      });
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
        extendBody: true,
        backgroundColor: Color(0xff6A5AE0),
        body: SafeArea(
            child: Stack(children: [
          _index == 0
              ? history()
              : _index == 1
                  ? home(context)
                  : profile(),
          Positioned(
            left: 0,
            bottom: 0,
            right: 0,
            child: CurvedNavigationBar(
              height: 50,
              index: _index,
              onTap: (index) {
                setState(() {
                  _index = index;
                });
              },
              color: Color(0xff6A5AE0),
              backgroundColor: Colors.transparent,
              items: <Widget>[
                Icon(
                  Icons.history,
                  size: 35,
                  color: Colors.white,
                ),
                Icon(
                  Icons.home,
                  size: 35,
                  color: Colors.white,
                ),
                Icon(
                  Icons.person,
                  size: 35,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ])));
  }

  SingleChildScrollView home(BuildContext context) {
    getData();
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DelayedDisplay(
                      child: Text(
                        name.length >= 12
                            ? "Hai ${name.substring(0, 12)}..👋"
                            : " Hai $name 👋",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                            fontFamily: "Rubik"),
                      ),
                    ),
                    DelayedDisplay(
                      child: AvatarGlow(
                        glowColor: Colors.white,
                        endRadius: 30,
                        animate: true,
                        child: Material(
                          elevation: 1.0,
                          shape: CircleBorder(),
                          child: CircleAvatar(
                            backgroundColor: Colors.transparent,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.network(
                                photo,
                                height: 40,
                                width: 40,
                              ),
                            ),
                            radius: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Visibility(
                  visible: orders.length == 0 ? false : true,
                  child: DelayedDisplay(
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 84,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.fill,
                              image: AssetImage("assets/images/Card.png")),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Order Status  ",
                                      style: TextStyle(
                                          color: Color(0xff660012),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: "Rubik"),
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.timelapse,
                                          size: 16,
                                          color: Color(0xff660012),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          lastordername,
                                          style: TextStyle(
                                              color: Color(0xff660012),
                                              fontSize: 10,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: "Rubik"),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              lastorderstatus == "Pending"
                                  ? CircularPercentIndicator(
                                      restartAnimation: true,
                                      onAnimationEnd: () {
                                        setState(() {
                                          percentage = 0.8;
                                        });
                                      },
                                      curve: Curves.bounceInOut,
                                      radius: 60,
                                      animation: true,
                                      animationDuration: 12000,
                                      lineWidth: 8.0,
                                      percent: percentage,
                                      center: new Text(
                                        lastorderstatus,
                                        style: new TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10.0),
                                      ),
                                      circularStrokeCap: CircularStrokeCap.butt,
                                      backgroundColor: Color(0xffFFB3C0),
                                      progressColor: Color(0xffFF8FA2),
                                    )
                                  : Lottie.asset(
                                      "assets/images/success.json",
                                      width: 80,
                                      height: 80,
                                    ),
                            ],
                          ),
                        )),
                  ),
                ),
                SizedBox(height: 10),
                DelayedDisplay(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 4,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.fill,
                          image: AssetImage(
                            "assets/images/Card1.png",
                          )),
                    ),
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "FEATURED",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: "Rubik"),
                                ),
                                Text(
                                  "Wanna get 1 M followers or subscribers !!!! Let's rock, just one click!!!",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: "Rubik"),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    UnityAds.showVideoAd(
                                        placementId: "Interstitial_Android");
                                  },
                                  child: Container(
                                    height: 40,
                                    width:
                                        MediaQuery.of(context).size.width / 2.5,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.verified_user,
                                          color: Color(0xff6A5AE0),
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          "Get Start",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Color(0xff6A5AE0),
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: "Rubik"),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                            top: 10,
                            left: 10,
                            child: Image.network(
                              "https://res.cloudinary.com/dvhlfyvrr/image/upload/v1638709750/1_zfollz.png",
                              width: 48,
                              height: 48,
                            )),
                        Positioned(
                            right: 10,
                            bottom: 10,
                            child: Image.network(
                              "https://res.cloudinary.com/dvhlfyvrr/image/upload/v1638709722/2_ev5vxb.png",
                              width: 56,
                              height: 56,
                            )),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          DelayedDisplay(
            child: Container(
              width: MediaQuery.of(context).size.width,
              // height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(40)),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Live Boosters",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              fontFamily: "Rubik"),
                        ),
                        TextButton(
                          onPressed: () {
                            UnityAds.showVideoAd(
                                placementId: "Interstitial_Android");
                          },
                          child: Text(
                            "See all",
                            style: TextStyle(
                                color: Color(0xff6A5AE0),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                fontFamily: "Rubik"),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    DelayedDisplay(
                      //slidingBeginOffset: Offset(1, 0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => Order(
                                    title: "Instagram Followers",
                                    details: "0.15 for per follower",
                                    name: "Followers",
                                    per_price: 0.15,
                                  )));
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 80,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.grey)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Image.network(
                                    "https://res.cloudinary.com/dvhlfyvrr/image/upload/v1639238267/instagram_ftvyn5.png"),
                                Container(
                                  width: MediaQuery.of(context).size.width / 2,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Instagram Followers",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: "Rubik"),
                                      ),
                                      Text(
                                        "100 followers 15 RS",
                                        style: TextStyle(
                                            color: Colors.green,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: "Rubik"),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(
                                  Icons.keyboard_arrow_right,
                                  size: 40,
                                  color: Color(0xff6A5AE0),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    DelayedDisplay(
                      // slidingBeginOffset: Offset(1, 0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => Order(
                                    title: "Telegram Channel/Group Members",
                                    details: " 0.20 for per Member",
                                    name: "Members",
                                    per_price: 0.20,
                                  )));
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 80,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.grey)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Image.network(
                                    "https://res.cloudinary.com/dvhlfyvrr/image/upload/v1639237788/telegram_vul95w.png"),
                                Container(
                                  width: MediaQuery.of(context).size.width / 2,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Telegram Channel/Group Members",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: "Rubik"),
                                      ),
                                      Text(
                                        "100 members 20 RS",
                                        style: TextStyle(
                                            color: Colors.green,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: "Rubik"),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(
                                  Icons.keyboard_arrow_right,
                                  size: 40,
                                  color: Color(0xff6A5AE0),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    DelayedDisplay(
                      //slidingBeginOffset: Offset(1, 0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => Order(
                                    title: "Telegram Post Views",
                                    details: "0.1 for per views",
                                    name: "Views",
                                    per_price: 0.1,
                                  )));
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 80,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.grey)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Image.network(
                                    "https://res.cloudinary.com/dvhlfyvrr/image/upload/v1639237788/telegram_vul95w.png"),
                                Container(
                                  width: MediaQuery.of(context).size.width / 2,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Telegram Post Views",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: "Rubik"),
                                      ),
                                      Text(
                                        "100 views 10 RS",
                                        style: TextStyle(
                                            color: Colors.green,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: "Rubik"),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(
                                  Icons.keyboard_arrow_right,
                                  size: 40,
                                  color: Color(0xff6A5AE0),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    DelayedDisplay(
                      //slidingBeginOffset: Offset(1, 0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => Order(
                                    title: "YouTube Views",
                                    details: "0.15 for per views",
                                    name: "Views",
                                    per_price: 0.15,
                                  )));
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 80,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.grey)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Image.network(
                                    "https://res.cloudinary.com/dvhlfyvrr/image/upload/v1639237520/youtube_gslzzn.png"),
                                Container(
                                  width: MediaQuery.of(context).size.width / 2,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "YouTube Views",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: "Rubik"),
                                      ),
                                      Text(
                                        "100 views 15 RS",
                                        style: TextStyle(
                                            color: Colors.green,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: "Rubik"),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(
                                  Icons.keyboard_arrow_right,
                                  size: 40,
                                  color: Color(0xff6A5AE0),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),

                    /* DelayedDisplay(
                      //slidingBeginOffset: Offset(1, 0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => Order(
                                    title: "YouTube-[Watch Time]",
                                    details: "1 RS for 1 hour ",
                                    name: "Hours",
                                    per_price: 1,
                                  )));
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 80,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.grey)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Image.network(
                                    "https://res.cloudinary.com/dvhlfyvrr/image/upload/v1639237520/youtube_gslzzn.png"),
                                Container(
                                  width: MediaQuery.of(context).size.width / 2,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "YouTube-[Watch Time]",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: "Rubik"),
                                      ),
                                      Text(
                                        "100 hours 100 RS",
                                        style: TextStyle(
                                            color: Colors.green,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: "Rubik"),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(
                                  Icons.keyboard_arrow_right,
                                  size: 40,
                                  color: Color(0xff6A5AE0),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),*/
                    DelayedDisplay(
                      //slidingBeginOffset: Offset(1, 0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => Order(
                                    title: "YouTube Subscribers",
                                    details: "4 RS for per subscribers",
                                    name: "Subscriber",
                                    per_price: 4,
                                  )));
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 80,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.grey)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Image.network(
                                    "https://res.cloudinary.com/dvhlfyvrr/image/upload/v1639237520/youtube_gslzzn.png"),
                                Container(
                                  width: MediaQuery.of(context).size.width / 2,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "YouTube Subscribers",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: "Rubik"),
                                      ),
                                      Text(
                                        "100 subscribers 400 RS",
                                        style: TextStyle(
                                            color: Colors.green,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: "Rubik"),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(
                                  Icons.keyboard_arrow_right,
                                  size: 40,
                                  color: Color(0xff6A5AE0),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    DelayedDisplay(
                      //slidingBeginOffset: Offset(1, 0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => Order(
                                    title: "YouTube Likes",
                                    details: "0.20 for per like",
                                    name: "Likes",
                                    per_price: 0.20,
                                  )));
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 80,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.grey)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Image.network(
                                    "https://res.cloudinary.com/dvhlfyvrr/image/upload/v1639237520/youtube_gslzzn.png"),
                                Container(
                                  width: MediaQuery.of(context).size.width / 2,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "YouTube Likes",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: "Rubik"),
                                      ),
                                      Text(
                                        "100 likes 20 RS",
                                        style: TextStyle(
                                            color: Colors.green,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: "Rubik"),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(
                                  Icons.keyboard_arrow_right,
                                  size: 40,
                                  color: Color(0xff6A5AE0),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  SingleChildScrollView profile() {
    getData();
    return SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        auth.signOut();
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        await prefs.clear();
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) => Login()));
                      },
                      child: Icon(
                        Icons.logout,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                DelayedDisplay(
                  child: Text(
                    "My Profile",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Nisebuschgardens',
                        fontSize: 25,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                DelayedDisplay(
                  child: Container(
                      height: MediaQuery.of(context).size.height / 2.5,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            bottom: 0,
                            right: 0,
                            left: 0,
                            child: Container(
                              height: MediaQuery.of(context).size.height / 3,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Stack(children: [
                                  Positioned(
                                      top: 0,
                                      right: 0,
                                      child: Icon(
                                        Icons.settings,
                                        color: Color(0xff6A5AE0),
                                      )),
                                  Positioned(
                                    left: 0,
                                    right: 0,
                                    top: 50,
                                    child: Column(
                                      children: [
                                        Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: Text(
                                            name.length >= 12
                                                ? " ${name.substring(0, 12)}.."
                                                : "  $name ",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Color(0xff6A5AE0),
                                                fontSize: 25,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 25,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Text(
                                                  'Orders',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                Text(
                                                  orders.length.toString(),
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Color(0xff6A5AE0),
                                                      fontSize: 25,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ],
                                            ),
                                            Container(
                                              height: 70,
                                              width: 3,
                                              color: Colors.grey,
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Text(
                                                  'Pending',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                Text(
                                                  '0',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Color(0xff6A5AE0),
                                                      fontSize: 25,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                ]),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey,
                                        spreadRadius: 2,
                                        blurRadius: 15)
                                  ]),
                              child: AvatarGlow(
                                glowColor: Colors.white,
                                endRadius: 50,
                                animate: true,
                                child: Material(
                                  elevation: 1.0,
                                  shape: CircleBorder(),
                                  child: CircleAvatar(
                                    backgroundColor: Colors.transparent,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(70),
                                      child: Image.network(
                                        photo,
                                        height: 100,
                                        width: 100,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    radius: 60,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )),
                ),
                SizedBox(
                  height: 15,
                ),
                DelayedDisplay(
                    child: Container(
                  //height: MediaQuery.of(context).size.height / 2,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
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
                                readOnly: true,
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                cursorColor: Color(0xff6A5AE0),
                                decoration: InputDecoration(
                                  hintText: email,
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
                          height: 20,
                        ),
                        DelayedDisplay(
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            child: Text(
                              "Phone Number",
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
                                readOnly: true,
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                cursorColor: Color(0xff6A5AE0),
                                decoration: InputDecoration(
                                  hintText: phone,
                                  border: InputBorder.none,
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide:
                                          BorderSide(color: Color(0xff6A5AE0))),
                                  prefixIcon: Icon(
                                    Icons.call,
                                    color: Color(0xff6A5AE0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        UnityBannerAd(
                          placementId: "Banner_Android",
                          size: BannerSize.leaderboard,
                        ),
                      ],
                    ),
                  ),
                ))
              ],
            ),
          ),
        ));
  }

  SingleChildScrollView history() {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection(email).snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Center(
                      child: Text(
                    'Something went wrong!',
                    style: TextStyle(color: Colors.white),
                  ));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator(
                    color: Colors.white,
                  );
                }
                if (snapshot.hasData) {
                } else {
                  Center(
                      child: Text(
                    'No Orders \n Make your first order now!',
                    style: TextStyle(color: Colors.white),
                  ));
                }
                return ListView(
                  reverse: false,
                  physics: BouncingScrollPhysics(),
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data()! as Map<String, dynamic>;
                    return DelayedDisplay(
                      child: GestureDetector(
                        onTap: () {
                          UnityAds.showVideoAd(
                              placementId: "Interstitial_Android");
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white),
                          child: ListTile(
                            title: Text(
                              "${data['item']}- ${data['order']}",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "Rubik"),
                            ),
                            subtitle: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "₹ ${data['price']}",
                                  style: TextStyle(
                                      color: Colors.green,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: "Rubik"),
                                ),
                                Text(
                                  " - ${data['status']}",
                                  style: TextStyle(
                                      color: data['status'] == "Pending"
                                          ? Colors.amber
                                          : Colors.green,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: "Rubik"),
                                ),
                              ],
                            ),
                            trailing: data['status'] == "Pending"
                                ? CircularPercentIndicator(
                                    restartAnimation: false,
                                    onAnimationEnd: () {
                                      setState(() {
                                        percentage = 1;
                                      });
                                    },
                                    curve: Curves.bounceInOut,
                                    radius: 40,
                                    animation: true,
                                    animationDuration: 6000,
                                    lineWidth: 8.0,
                                    percent: percentage,
                                    center: new Text(
                                      "",
                                      style: new TextStyle(
                                          color: Colors.yellow,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 10.0),
                                    ),
                                    circularStrokeCap: CircularStrokeCap.butt,
                                    backgroundColor: Color(0xffffe59c),
                                    progressColor: Colors.amber,
                                  )
                                : Lottie.asset(
                                    "assets/images/success.json",
                                    width: 60,
                                    height: 60,
                                  ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          )),
    );
  }
}
