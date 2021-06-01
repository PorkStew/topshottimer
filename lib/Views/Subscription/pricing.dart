import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:topshottimer/Views/PageSelector.dart';
import 'package:topshottimer/Views/Subscription/success.dart';
import '../../loading.dart';
import 'package:get/get.dart';
import 'package:topshottimer/global.dart';
import 'package:topshottimer/Themes.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
class pricing extends StatefulWidget {
  @override
  _pricingState createState() => _pricingState();
}

class _pricingState extends State<pricing>{
  bool _loading = false;
  final _controller = Get.put(Controller());
  //iniState is used to get the price of the subscription on the start of the page in connection with setState
  @override
  void initState() {
    getPrice();
  }
  String price = "";
  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    bool pop = arguments['pop'];
    print("after POP");
    print(pop);
    return _loading
        ? Loading() : Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20,),
            Align(
              //alignment: Alignment.centerLeft,
              child: Column(
                //left aligns the text
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Unlock",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 30,
                        fontFamily: 'Montserrat-Regular',
                        letterSpacing: 0.2),
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    "Unlimited Features",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 30,
                        fontFamily: 'Montserrat-Regular',
                        letterSpacing: 0.2),
                  ),
                  Text(
                    "to Record, Track and Improve",
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 17,
                        fontFamily: 'Montserrat-Regular',
                        letterSpacing: 0.2,
                        color: Colors.grey),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Icon(Icons.check, color: Themes.darkButton2Color, size: 34,),
                    Text('Customizable Start Tone',
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 17,
                          fontFamily: 'Montserrat-Regular',
                          letterSpacing: 0.2
                      ),),
                  ],
                ),
                // Wrap(
                //   crossAxisAlignment: WrapCrossAlignment.center,
                //   children: [
                //     Icon(Icons.check, color: Themes.darkButton2Color, size: 34,),
                //     Text('Changeable Timer Delay',
                //       style: TextStyle(
                //           fontWeight: FontWeight.w400,
                //           fontSize: 17,
                //           fontFamily: 'Montserrat-Regular',
                //           letterSpacing: 0.2
                //       ),),
                //   ],
                // ),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Icon(Icons.check, color: Themes.darkButton2Color, size: 34,),
                    Text('Random Delay',
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 17,
                          fontFamily: 'Montserrat-Regular',
                          letterSpacing: 0.2
                      ),),
                  ],
                ),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Icon(Icons.check, color: Themes.darkButton2Color, size: 34,),
                    Text('Save Your Strings',
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 17,
                          fontFamily: 'Montserrat-Regular',
                          letterSpacing: 0.2
                      ),),
                  ],
                ),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Icon(Icons.check, color: Themes.darkButton2Color, size: 34,),
                    Text('View Recorded Strings',
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 17,
                          fontFamily: 'Montserrat-Regular',
                          letterSpacing: 0.2
                      ),),
                  ],
                ),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Icon(Icons.check, color: Themes.darkButton2Color, size: 34,),
                    Text('Ad Free',
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 17,
                          fontFamily: 'Montserrat-Regular',
                          letterSpacing: 0.2
                      ),),
                  ],
                )
              ],
            ),
            SizedBox(height: 20,),
            Container(
                width: 268,
                height: 100,
                //margin: const EdgeInsets.all(15.0),
                //padding: const EdgeInsets.all(3.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Themes.darkButton1Color, width: 3),
                  borderRadius: BorderRadius.circular(10),

                ),
                child:
                    Column(children: [
                      Container(
                        width: 268,
                        height: 20,
                        padding: EdgeInsets.only(left: 10, top: 3),
                        child: Text('MONTHLY',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 10,
                              fontFamily: 'Montserrat-Regular',
                              letterSpacing: 0.2,
                              color: Colors.white),
                        ),
                        decoration: BoxDecoration(
                          color: Themes.darkButton1Color
                        ),
                      ),
                      SizedBox(height: 5,),
                        Padding(
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: Column(
                            children: [
                              Text(price + ' / Month',
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 17,
                                    fontFamily: 'Montserrat-Regular',
                                    letterSpacing: 0.2
                                ),),
                              Text(price + ' billed monthly as a recurring payment',
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12,
                                    fontFamily: 'Montserrat-Regular',
                                    letterSpacing: 0.2,
                                    color: Colors.grey
                                ), textAlign: TextAlign.center,),
                            ],
                          ),
                        ),
                    ],)
            ),
            SizedBox(height: 20,),
            SizedBox(
                width: 268,
                height: 60,
                child: Obx(() => ElevatedButton(
                  onPressed: _controller.btnState.value
                      ? () => subscriptionProcess(pop) //process when button is clicked here!
                      : null,
                  child: Text(
                    'Go Premium',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                        fontFamily: 'Montserrat-Regular',
                        letterSpacing: 0.2,
                        color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                      primary: Themes.darkButton2Color,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(10))),
                ))),
            SizedBox(height: 20,),
            RichText(
              text: TextSpan(
                  text: "No Thanks",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                      fontFamily: 'Montserrat-Regular',
                      letterSpacing: 0.2,
                      color: Colors.grey),
                  recognizer: new TapGestureRecognizer()
                    ..onTap = () {
                      print(pop);
                      if(pop == true) {
                        Get.back();
                      } else if(pop == false) {
                        Get.off(() => pageSelector());
                      }
                    }
              ),
            ),
          ],
        ),
      ),
    );
  }
  //When clicking GO PREMIUM button this will start the proccess for subscribing
subscriptionProcess(bool pop) async {
  try {
    Offerings offerings = await Purchases.getOfferings();
    setState(() => _loading = true);
    if (offerings.current != null) {
      // Display current offering with offerings.current
      Package package = offerings.current.monthly;

      try {
        PurchaserInfo purchaserInfo = await Purchases.purchasePackage(package);
        var isPro = purchaserInfo.entitlements.all["premium_features"].isActive;
        if (isPro) {
          //get user data from user preferences
          SharedPreferences prefs = await SharedPreferences.getInstance();
          String _email = prefs.getString('email');
          String _lastName = prefs.getString('lastName');
          String _firstName = prefs.getString('firstName');
          Purchases.setAttributes({
            "\$email": _email,
            "\$displayName": _lastName + " " + _firstName
          });
          // Unlock that great "pro" content
          print("REVENUCAT: user is now subscribed");
          //When Success button is clicked depending on where the user came from. go to page selector or pop view
          _controller.hasSubscription.value = true;
          if(pop == true) {
           Get.back();
           Get.to(() => Success(), arguments: {'pop': true, 'price': price});
          } else if(pop == false) {
            Get.off(() => Success(), arguments: {'pop': false, 'price': price});
          }
        }
      } on PlatformException catch (error) {
        setState(() => _loading = false);
        var errorCode = PurchasesErrorHelper.getErrorCode(error);
        print("REVENUCAT: PLATFORM ERROR - $error");
        if (errorCode != PurchasesErrorCode.purchaseCancelledError) {
          //showError(e);
          setState(() => _loading = false);
          print("REVENUCAT: PURCHASE ERROR - $error");
        }
      }
    }
  } on PlatformException catch (e) {
    print(e);
    setState(() => _loading = false);
  }
}
//setState is used to update the view which uses the variable price
getPrice() async {
  Offerings offerings = await Purchases.getOfferings();
  Package package = offerings.current.monthly;
  setState(() {
    price = package.product.priceString;
    return;
  });
}
}


