import 'package:Socmed/Screens/payment_fail.dart';
import 'package:Socmed/Screens/payment_success.dart';
import 'package:Socmed/model/ordermodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:regexpattern/regexpattern.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unity_ads_plugin/unity_ads.dart';

class Order extends StatefulWidget {
  final title;
  final details;
  final name;
  final per_price;

  const Order({Key? key, this.title, this.details, this.name, this.per_price})
      : super(
          key: key,
        );

  @override
  _OrderState createState() => _OrderState();
}

class _OrderState extends State<Order> {
  Razorpay _razorpay = Razorpay();
  dynamic quantity = 000;
  String name = "User";
  String email = "";
  String phone = "";
  List<String> orders = [];

  dynamic price = 0;
  final url_controller = TextEditingController();
  final phone_controller = TextEditingController();

  void getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() async {
      name = await prefs.getString('name')!;
      email = await prefs.getString('email')!;
      orders = await prefs.getStringList('orders')!;
      phone = await prefs.getString('phone')!;
    });
  }

  @override
  void initState() {
    super.initState();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    getData();
    UnityAds.init(gameId: "4540281");
    UnityAds.showVideoAd(placementId: "Interstitial_Android");
  }

  void storedata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setStringList('orders', orders);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    final id = new DateTime.now().millisecondsSinceEpoch;
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    ordermodel orderModel = ordermodel();

    orderModel.email = email;
    orderModel.phone = phone_controller.text;
    orderModel.name = name;
    orderModel.order = quantity.toString();
    orderModel.price = price.toString();
    orderModel.item = widget.title;
    orderModel.link = url_controller.text;
    orderModel.status = "Pending";
    await firebaseFirestore
        .collection("Orders")
        .doc(id.toString())
        .set(orderModel.toMap());

    await firebaseFirestore
        .collection(email)
        .doc(id.toString())
        .set(orderModel.toMap());

    if (orders != null) {
      orders.add(id.toString());
      storedata();
    }
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => PaymentSuccess()));
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => PaymentFail()));
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet is selected
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _razorpay.clear();
    UnityAds.showVideoAd(placementId: "Interstitial_Android");
  }

  void openCheckout() {
    var options = {
      'key': 'rzp_live_vxOJlJrIb2fVyI',
      'amount': price * 100, //in the smallest currency sub-unit.
      'name': 'Socmed',
      'description': widget.title,
      'timeout': 120,
      'prefill': {'contact': phone_controller.text, 'email': email},
      'external': {
        'wallets': ['paytm']
      }
    };
    try {
      _razorpay.open(options);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(backgroundColor: Colors.green, content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff6A5AE0),
      appBar: AppBar(
        backgroundColor: Color(0xff6A5AE0),
        elevation: 0,
        centerTitle: true,
        title: Text(
          " Order",
          style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w500,
              fontFamily: "Rubik"),
        ),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.more_horiz))],
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              DelayedDisplay(
                child: Container(
                  height: MediaQuery.of(context).size.height / 3.5,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage(
                          "assets/images/MaskGroup.png",
                        )),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.only(
                                left: 12, right: 12, top: 6, bottom: 6),
                            height: 30,
                            decoration: BoxDecoration(
                                color: Color(0xffFF8FA2),
                                borderRadius: BorderRadius.circular(10)),
                            child: Text(
                              widget.title,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "Rubik"),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 2,
                            child: Text(
                              widget.details,
                              style: TextStyle(
                                  color: Color(0xff660012),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "Rubik"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 1.2,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      DelayedDisplay(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                            "Quantity",
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          DelayedDisplay(
                            child: Container(
                              width: MediaQuery.of(context).size.width / 1.6,
                              height: 56,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border:
                                      Border.all(color: Colors.grey, width: 1)),
                              child: Center(
                                child: Text(
                                  "$quantity ${widget.name}",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 20,
                                      fontFamily: "Rubik",
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border:
                                    Border.all(color: Colors.grey, width: 1)),
                            child: IconButton(
                              onPressed: () {
                                showMaterialModalBottomSheet(
                                    expand: false,
                                    context: context,
                                    backgroundColor: Colors.transparent,
                                    builder: (context) => Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              1.2,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(50),
                                                  topRight: Radius.zero)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(15.0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    quantitySelect(50),
                                                    quantitySelect(100),
                                                    quantitySelect(500)
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    quantitySelect(1000),
                                                    quantitySelect(1500),
                                                    quantitySelect(2000)
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    quantitySelect(3000),
                                                    quantitySelect(5000),
                                                    quantitySelect(7000)
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    SizedBox(
                                                      height: 10.0,
                                                      child: new Center(
                                                        child: new Container(
                                                          margin:
                                                              const EdgeInsetsDirectional
                                                                      .only(
                                                                  start: 1.0,
                                                                  end: 1.0),
                                                          height: 1.0,
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width /
                                                              3,
                                                          color:
                                                              Colors.grey[500],
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
                                                          margin:
                                                              const EdgeInsetsDirectional
                                                                      .only(
                                                                  start: 1.0,
                                                                  end: 1.0),
                                                          height: 1.0,
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width /
                                                              3,
                                                          color:
                                                              Colors.grey[500],
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.of(context).pop();
                                                    UnityAds.showVideoAd(
                                                        placementId:
                                                            "Interstitial_Android");
                                                  },
                                                  child: Container(
                                                    height: 40,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            1.5,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                        border: Border.all(
                                                            color: Colors.grey,
                                                            width: 1)),
                                                    child: Center(
                                                      child: Text(
                                                        "Custom",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            color: Colors.grey,
                                                            fontSize: 20,
                                                            fontFamily: "Rubik",
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ));
                              },
                              icon: Icon(
                                Icons.edit,
                                color: Colors.grey,
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      DelayedDisplay(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 5),
                              height: 40,
                              width: MediaQuery.of(context).size.width / 2,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(7),
                                  border:
                                      Border.all(color: Colors.grey, width: 1)),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "Price :",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 20,
                                          fontFamily: "Rubik",
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      " ₹ ${price.toString()}",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.green,
                                          fontSize: 20,
                                          fontFamily: "Rubik",
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      DelayedDisplay(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                            "Phone number",
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
                          height: 75,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20)),
                          child: Center(
                            child: TextField(
                              controller: phone_controller,
                              maxLength: 10,
                              autofillHints: {phone_controller.text},
                              keyboardType: TextInputType.number,
                              cursorColor: Color(0xff6A5AE0),
                              decoration: InputDecoration(
                                hintText: "Enter your Phone number",
                                border: InputBorder.none,
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(color: Colors.grey)),
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
                      SizedBox(
                        height: 10,
                      ),
                      DelayedDisplay(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                            "Link",
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
                              controller: url_controller,
                              keyboardType: TextInputType.url,
                              cursorColor: Color(0xff6A5AE0),
                              decoration: InputDecoration(
                                hintText: "Enter your URL",
                                border: InputBorder.none,
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(color: Colors.grey)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide:
                                        BorderSide(color: Color(0xff6A5AE0))),
                                prefixIcon: Icon(
                                  Icons.http_outlined,
                                  color: Color(0xff6A5AE0),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      DelayedDisplay(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Make Sure the URL is valid!",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 16, color: Colors.grey[500]),
                            ),
                            Icon(
                              Icons.check_box,
                              color: url_controller.text.isUrl()
                                  ? Colors.green
                                  : Colors.grey,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      DelayedDisplay(
                        child: TextButton(
                            onPressed: () async {
                              if (quantity != 0) {
                                if (phone_controller.text.length == 10) {
                                  if (url_controller.text.isUrl()) {
                                    SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    await prefs.setString(
                                        'phone', phone_controller.text);

                                    openCheckout();
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            duration:
                                                Duration(milliseconds: 300),
                                            backgroundColor: Colors.red,
                                            content: Text(
                                                "Please enter your link or url")));
                                  }
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          duration: Duration(milliseconds: 300),
                                          backgroundColor: Colors.red,
                                          content: Text(
                                              "Please enter your phone number")));
                                }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        duration: Duration(milliseconds: 300),
                                        backgroundColor: Colors.red,
                                        content:
                                            Text("Please select quantity")));
                              }
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width / 1.2,
                              height: 56,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Color(0xff6A5AE0)),
                              child: Center(
                                  child: Text(
                                "Place Order",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              )),
                            )),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }

  GestureDetector quantitySelect(int qy) {
    return GestureDetector(
      onTap: () {
        setState(() {
          quantity = qy;
          price = qy * widget.per_price;
        });
        Navigator.of(context).pop();
      },
      child: Container(
        height: 40,
        width: 100,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey, width: 1)),
        child: Center(
          child: Text(
            qy.toString(),
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.grey,
                fontSize: 20,
                fontFamily: "Rubik",
                fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}
