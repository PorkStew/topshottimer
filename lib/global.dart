import 'package:get/get.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class Controller extends GetxController{
  //.obs tells the system to observe the variable
  final btnState = true.obs;
  final hasSubscription = false.obs;
  //set global revenueCAT listener
  Future revenueCatSetListener(String _id) async{
    //print("STARTING REVENUECAT: GLOBAL.dart");
    await Purchases.setDebugLogsEnabled(true);
    await Purchases.setup("nCjcXQocpiwSHbFXJKjxASIFgDALbjwA", appUserId: _id);
    PurchaserInfo purchaserInfo = await Purchases.getPurchaserInfo();
    try {
      if (purchaserInfo.entitlements.all["premium_features"].isActive) {
        print("USER IS SUBSCRIBED ******************");
        hasSubscription.value = true;
      } else {
        print("USER IS NOT SUBSCRIBED *****************");
        hasSubscription.value = false;
      }
    } catch (e){
      print(e);
    }
    //an event listener that will auto update depending on the state of the users subscription
    Purchases.addPurchaserInfoUpdateListener((info) async{
      // handle any changes to purchaserInfo
      //print("*******LISTENING TO SUBSCRIPTION CHECKER********");
      //print("REVENUECAT: Loading subscription");
      //print(info.activeSubscriptions);
      //if purchase information chnages at any point then react
      if (purchaserInfo.entitlements.all["premium_features"].isActive) {
        print("***************************************************** ACTIVE SUBSCRIBER");
        hasSubscription.value = true;
      } else {
        print("***************************************************** NOT ACTIVE SUBSCRIBER");
        hasSubscription.value = false;
      }
    });
    //print("REVENUECAT: GLOBAL.dart END");
  }
}
