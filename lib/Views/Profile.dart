import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
    Future fUSerID;
    Future fDataRetrieved;


    String sID;

    List<String> arrStringID = List<String>();
    List<String> arrStringName = List<String>();
    List<String> arrTotalShots = List<String>();
    List<String> arrTotalTime = List<String>();

    @override
    void initState() {
      super.initState();
      fUSerID = _getID();
    }


    Future<String> userID() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      //await prefs.setDouble('userSensitivity', 50.00);
      String sUserID = await prefs.getString('id');

      //print(dSensitivity.toString());
      return sUserID;
    }
    _getID() async{
    sID = await userID();
    var url = 'https://www.topshottimer.co.za/viewStrings.php';
    var res = await http.post(
        Uri.encodeFull(url), headers: {"Accept": "application/jason"},
        body: {
          //get this information from user defaults
          "userID": sID,
        }
    );
    //print(json.decode(res.body));


    print("before res.body");

    List<dynamic> data = json.decode(res.body);
    int iLength = data.length;
    print("Length of list: " + iLength.toString());
    var id = data;
    print(id);
    print(id[0]['userID']);

    for(int iPopulate = 0; iPopulate<=iLength-1; iPopulate++)
    {
      arrStringID.add(id[iPopulate]['stringId']);
      arrStringName.add(id[iPopulate]['stringName']);
      arrTotalShots.add(id[iPopulate]['totalShots']);
      arrTotalTime.add(id[iPopulate]['totalTime']);
    }

    //print(arrStringName[0].toString());
    for(int iPrint = 0; iPrint<=iLength-1; iPrint++)
    {
      //print(arrStringName[iPrint]);
      print("String ID: " + arrStringID[iPrint]+ ", String Name: " + arrStringName[iPrint]+ ", Total Shots: " + arrTotalShots[iPrint].toString() + ", Total Time: " + arrTotalTime[iPrint]);
    }

    return userID();
  }
//Print

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: fUSerID,
        builder: (context,snapshot){

      switch (snapshot.connectionState) {
        case ConnectionState.active:
        case ConnectionState.waiting:
        //updateData(sID);
        return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: SizedBox(
                height: 100,
                width: 100,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color> (Colors.red),
                  strokeWidth: 5.0,
                ),
              ),
            ),
          ],
        ),
      );
        case ConnectionState.done:
          if (snapshot.hasError) {
            return Text('Error Here: ${snapshot.error}');
          } else {
            print("Got into widget");
            updateData(sID);
            return Column(
                children: <Widget> [
                  Flexible(
                    child:
                    new ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: arrStringID.length,
                      itemBuilder: (BuildContext context, int index){
                        return Container(
                            child:Column(
                              children: <Widget>[
                                Card(
                                  child: Row(
                                     //mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                    children: <Widget>[

                                      Text(arrStringName[index],style: TextStyle(fontSize: 30, color: Colors.black)),
                                      Spacer(),
                                      Text(arrTotalShots[index],style: TextStyle(fontSize: 30)),
                                      Spacer(),
                                      Text(arrTotalTime[index],style: TextStyle(fontSize: 30)),
                                      Spacer(),

                                    ],
                                  ),
                                ),

                              ],
                            )



                        );
                      },
                    ),
                  ),

                ]
            );
          }
      }
        },
      ),
    );
  }

    Future updateData(String sID) async {
      var url = 'https://www.topshottimer.co.za/viewStrings.php';
      var res = await http.post(
          Uri.encodeFull(url), headers: {"Accept": "application/jason"},
          body: {
            //get this information from user defaults
            "userID": sID,
          }
      );
      //print(json.decode(res.body));


      print("before res.body");

      List<dynamic> data = json.decode(res.body);
      int iLength = data.length;
      print("Length of list: " + iLength.toString());
      var id = data;
      print(id);
      print(id[0]['userID']);

      for(int iPopulate = 0; iPopulate<=iLength-1; iPopulate++)
        {
          arrStringID.add(id[iPopulate]['stringId']);
          arrStringName.add(id[iPopulate]['stringName']);
          arrTotalShots.add(id[iPopulate]['totalShots']);
          arrTotalTime.add(id[iPopulate]['totalTime']);
        }

      //print(arrStringName[0].toString());
      for(int iPrint = 0; iPrint<=iLength-1; iPrint++)
      {
        //print(arrStringName[iPrint]);
        print("String ID: " + arrStringID[iPrint]+ ", String Name: " + arrStringName[iPrint]+ ", Total Shots: " + arrTotalShots[iPrint].toString() + ", Total Time: " + arrTotalTime[iPrint]);
      }

      return "True";
      //print(id['userID']);

      //   print("failed");
      // }
      //Map<String, dynamic> data = json.decode(res.body);

      // var datas = json.decode(res.body);
      // //print(data);
      // print(datas);
      //   String id = data['id'];
      //   String status = data["status"];
      //   print("ss");
      //   print(id);
      //   print(status);
      //   print("dddd");
      //   //display message because they are not a user
      //   if (status == "notuser") {
      //     //saveUserInformation("1", "donovan@simplx.co.za", "e1a7b8ad45f95c9d0f401381236891d369ca80790393e307805e1dd700f8ecca", "true");
      //     print("we don't have this user");
      //     //Navigator.push(context, MaterialPageRoute(builder: (context) => pageSelector.pageSelector()));
      //     //createError();
      //   }
      //   //is a user but they haven't verified their email address
      //   else if (status == "nonverified" && id != null) {
      //     print("we have this user but they are not verified");
      //     saveUserInformation(id, email, hashedPassword, "false");
      //     Navigator.push(context, MaterialPageRoute(builder: (context) => verify.verifyEmail()));
      //   }
      //   //is a user and is verified email so they can use the app
      //   else if (status == "verified" && id != null) {
      //     print("user details is all in order");
      //     saveUserInformation(id, email, hashedPassword, "true");
      //     Navigator.push(context, MaterialPageRoute(builder: (context) => pageSelector.pageSelector()));
      //   } else{
      //
      //   }
      // }
    }
}



// updateData(String email, String password) async {
//   String hashedPassword = "";
//   var bytes = utf8.encode(password);
//   var digest = sha256.convert(bytes);
//   hashedPassword = digest.toString();
//
//   var url = 'https://www.topshottimer.co.za/login.php';
//   var res = await http.post(
//       Uri.encodeFull(url), headers: {"Accept": "application/jason"},
//       body: {
//         //get this information from user defaults
//         "userID": email,
//         "password": hashedPassword,
//       }
//   );
//   print("before res.body");
//   Map<String, dynamic> data = json.decode(res.body);
//   String id = data['id'];
//   String status = data["status"];
//   print("ss");
//   print(id);
//   print(status);
//   print("dddd");
//   //display message because they are not a user
//   if (status == "notuser") {
//     saveUserInformation("1", "donovan@simplx.co.za", "e1a7b8ad45f95c9d0f401381236891d369ca80790393e307805e1dd700f8ecca", "true");
//     print("we don't have this user");
//     Navigator.push(context, MaterialPageRoute(builder: (context) => pageSelector.pageSelector()));
//     //createError();
//   }
//   //is a user but they haven't verified their email address
//   else if (status == "nonverified" && id != null) {
//     print("we have this user but they are not verified");
//     saveUserInformation(id, email, hashedPassword, "false");
//     Navigator.push(context, MaterialPageRoute(builder: (context) => verify.verifyEmail()));
//   }
//   //is a user and is verified email so they can use the app
//   else if (status == "verified" && id != null) {
//     print("user details is all in order");
//     saveUserInformation(id, email, hashedPassword, "true");
//     Navigator.push(context, MaterialPageRoute(builder: (context) => pageSelector.pageSelector()));
//   } else{
//
//   }
// }



// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
//
//
// class Profile extends StatefulWidget {
//   @override
//   _ProfileState createState() => _ProfileState();
// }
//
// class _ProfileState extends State<Profile> {
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child:
//         Text("Hello World"),
//     );
//   }
//
//
//
// }
//



























//import 'package:audioplayers/audio_cache.dart';
// // import 'package:audioplayers/audioplayers.dart';
// // import 'package:flutter/material.dart';
// // import 'package:shared_preferences/shared_preferences.dart';
// // import 'package:topshottimer/main.dart';
// //
// //
// // class Settings extends StatefulWidget {
// //   @override
// //   _SettingsState createState() => _SettingsState();
// // }
// //
// // class _SettingsState extends State<Settings> {
// //   Future newSensitivityFuture;
// //   Future newDelayFuture;
// //
// //
// //   @override
// //   void initState(){
// //     super.initState();
// //     initPlayer();
// //     newDelayFuture = _getDelay();
// //     newSensitivityFuture = _getSensitivity();
// //   }
// //
// //   _getDelay() async{
// //     sliderValue2 = await userDelay();
// //     if (sliderValue2 == null)
// //     {
// //       sliderValue2 = 3;
// //     }
// //     return userDelay();
// //   }
// //
// //   _getSensitivity() async{
// //     sliderValue1 = await userSensitivity();
// //     if (sliderValue1 == null)
// //     {
// //       sliderValue1 = 50.0;
// //     }
// //
// //     return userSensitivity();
// //   }
// //   // Store both of these values in user defaults
// //   //Stewart Knows How User Defaults Works
// //   //**********************************************
// //   double sliderValue1 = 0;
// //   double sliderValue2 = 1;
// //   int dropDownValue = 1;
// //   AudioPlayer advancedPlayer;
// //   AudioCache audioCache;
// //   String localPathFile;
// //
// //   //var sHello = await userSensitivity(context);
// //   //**********************************************
// //
// //   String secDelay = '3';
// //   var arrSensititvity = ['Extremely Not Sensitive','Not Sensitive','Normal','Sensitive','Extremely Sensitive'];
// //   String timerSensitivity = 'Normal';
// //
// //
// //   void initPlayer(){
// //     advancedPlayer = AudioPlayer();
// //     audioCache = AudioCache(fixedPlayer: advancedPlayer);
// //   }
// //
// //
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: Container(
//             padding: EdgeInsets.only(top: 35,bottom: 20,left: 20, right: 20),
//             child: Column(
//
//                 children: [
//                   Text('Timer Sensitivity', style: TextStyle(
//                       fontSize: 30.0
//                   ),),
//                   FutureBuilder(
//
//                     future: newSensitivityFuture,
//                     builder: (context, snapshot )  {
//
//                       switch (snapshot.connectionState) {
//                         case ConnectionState.active:
//                         case ConnectionState.waiting:
//                           return Container(
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               children: [
//                                 Center(
//                                   child: SizedBox(
//                                     height: 100,
//                                     width: 100,
//                                     child: CircularProgressIndicator(
//                                       valueColor: AlwaysStoppedAnimation<Color> (Colors.red),
//                                       strokeWidth: 5.0,
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ); //or a placeholder
//                         case ConnectionState.done:
//                           if (snapshot.hasError) {
//                             return Text('Error Here: ${snapshot.error}');
//                           } else {
//                             print(sliderValue1);
//                             return Slider(
//                               value: sliderValue1,
//                               min: 0,
//                               max: 100,
//                               activeColor: Colors.red,
//                               inactiveColor: Colors.black,
//                               divisions: 4,
//                               label: sliderValue1.toString(),
//                               onChanged: (double newValue) {
//                                 setState(() {
//                                   sliderValue1 = newValue;
//
//                                   if (newValue == 0.0){
//                                     timerSensitivity = arrSensititvity[0].toString();
//                                   }
//                                   if (newValue == 25.0){
//                                     timerSensitivity = arrSensititvity[1].toString();
//                                   }
//                                   if (newValue == 50.0){
//                                     timerSensitivity = arrSensititvity[2].toString();
//                                   }
//                                   if (newValue == 75.0){
//                                     timerSensitivity = arrSensititvity[3].toString();
//                                   }
//                                   if (newValue == 100.0){
//                                     timerSensitivity = arrSensititvity[4].toString();
//                                   }
//                                   return sliderValue1;
//                                 });
//                                 setDefaultSensitivity(newValue);
//                                 print('Start: ${newValue}');
//                               },);}
//                       }
//                     },
//
//                   ),
//
//                   SizedBox(height: 10),
//
//                   Text('Timer Delay', style: TextStyle(
//                       fontSize: 30.0
//                   ),),
//                   FutureBuilder(
//                     future: newDelayFuture,
//                     builder: (context, snapshot )  {
//
//                       switch (snapshot.connectionState) {
//                         case ConnectionState.active:
//                         case ConnectionState.waiting:
//                           return Text(''); //or a placeholder
//                         case ConnectionState.done:
//                           if (snapshot.hasError) {
//                             return Text('Error Here: ${snapshot.error}');
//                           } else {
//                             print(sliderValue2);
//                             return Slider(
//                               value: sliderValue2,
//                               min: 1,
//                               max: 5,
//                               activeColor: Colors.red,
//                               inactiveColor: Colors.black,
//                               divisions: 4,
//                               label: sliderValue2.toString(),
//                               onChanged: (double newValue) {
//                                 setState(() {
//                                   sliderValue2 = newValue;
//
//                                   if (newValue == 1){
//                                     secDelay = '1';
//                                   }
//                                   if (newValue == 2){
//                                     secDelay = '2';
//                                   }
//                                   if (newValue == 3){
//                                     secDelay = '3';
//                                   }
//                                   if (newValue == 4){
//                                     secDelay = '4';
//                                   }
//                                   if (newValue == 5){
//                                     secDelay = '5';
//                                   }
//                                   return sliderValue2;
//                                 });
//                                 setDefaultDelay(newValue);
//                                 print('Start: ${newValue}');
//                               },);}
//                       }
//                     },
//
//                   ),
//                   Text('Timer Tone', style: TextStyle(
//                       fontSize: 30.0
//                   ),),
//
//                   FutureBuilder(
//                     future: newDelayFuture,
//                     builder: (context, snapshot )  {
//
//                       switch (snapshot.connectionState) {
//                         case ConnectionState.active:
//                         case ConnectionState.waiting:
//                           return Text(''); //or a placeholder
//                         case ConnectionState.done:
//                           if (snapshot.hasError) {
//                             return Text('Error Here: ${snapshot.error}');
//                           } else {
//                             print(sliderValue2);
//                             return DropdownButton(
//                                 value: dropDownValue,
//                                 items: [
//                                   DropdownMenuItem(
//                                     child: Text("1500Hz"),
//                                     value: 1,
//                                   ),
//                                   DropdownMenuItem(
//                                     child: Text("1700Hz"),
//                                     value: 2,
//                                   ),
//                                   DropdownMenuItem(
//                                       child: Text("1900Hz"),
//                                       value: 3
//                                   ),
//                                   DropdownMenuItem(
//                                       child: Text("2100Hz"),
//                                       value: 4
//                                   ),
//                                   DropdownMenuItem(
//                                     child: Text("2300Hz"),
//                                     value: 5,
//                                   ),
//                                   DropdownMenuItem(
//                                     child: Text("2500Hz"),
//                                     value: 6,
//                                   ),
//                                   DropdownMenuItem(
//                                       child: Text("2700Hz"),
//                                       value: 7
//                                   ),
//                                   DropdownMenuItem(
//                                       child: Text("2900Hz"),
//                                       value: 8
//                                   ),
//                                   DropdownMenuItem(
//                                     child: Text("3100Hz"),
//                                     value: 9,
//                                   ),
//                                   DropdownMenuItem(
//                                     child: Text("3300Hz"),
//                                     value: 10,
//                                   )
//                                 ],
//                                 onChanged: (value) {
//                                   setState(() {
//                                     dropDownValue = value;
//                                     print("Selected dropdown value: " + value.toString());
//                                     String sAudioString;
//                                     if (value == 1){
//                                       sAudioString = "1500";
//                                     } else
//                                     if (value == 2){
//                                       sAudioString = "1700";
//                                     } else
//                                     if (value == 3){
//                                       sAudioString = "1900";
//                                     } else
//                                     if (value == 4){
//                                       sAudioString = "2100";
//                                     } else
//                                     if (value == 5){
//                                       sAudioString = "2300";
//                                     } else
//                                     if (value == 6){
//                                       sAudioString = "2500";
//                                     } else
//                                     if (value == 7){
//                                       sAudioString = "2700";
//                                     } else
//                                     if (value == 8){
//                                       sAudioString = "2900";
//                                     } else
//                                     if (value == 9){
//                                       sAudioString = "3100";
//                                     } else
//                                     if (value == 10){
//                                       sAudioString = "3300";
//                                     }
//                                     audioCache.play(sAudioString+'.mp3');
//                                     setUserTone(sAudioString);
//                                   });
//                                 })
//
//
//
//
//
//                             ;}
//                       }
//                     },
//
//                   ),
//                   Align(
//                     alignment: Alignment.bottomCenter,
//                     child: FlatButton(
//                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0), side: BorderSide(color: Colors.red)),
//                       height: 35,
//                       minWidth: 150,
//                       child: Text("Sign Out",style: TextStyle(fontSize: 20, color: Colors.black),),
//                       onPressed: () async {
//                         SharedPreferences preferences = await SharedPreferences.getInstance();
//                         await preferences.clear();
//                         Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp()));
//                         print("Signed Out");
//                       },
//
//
//                     ),
//                   ),
//
//
//
//
//                 ])
//         ));
//
//   }
// }
//
// // doStuff() async{
// //   var x = await userSensitivity();
// //   return x;
// // }
// Future<double> userSensitivity() async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   //await prefs.setDouble('userSensitivity', 50.00);
//   double dSensitivity = await prefs.getDouble('userSensitivity');
//   if (dSensitivity == null){
//     await prefs.setDouble('userSensitivity', 50.0);
//   }
//   //print(dSensitivity.toString());
//   return dSensitivity;
// }
//
// setDefaultSensitivity(double newValue) async{
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   await prefs.setDouble('userSensitivity', newValue);
//
// }
//
// Future<double> userDelay() async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   //await prefs.setDouble('userSensitivity', 50.00);
//   double dDelay = await prefs.getDouble('userDelay');
//   if (dDelay == null){
//     await prefs.setDouble('userDelay', 3);
//   }
//   //print(dSensitivity.toString());
//   return dDelay;
// }
//
// setDefaultDelay(double newValue) async{
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   await prefs.setDouble('userDelay', newValue);
//
// }
//
// Future<String> userTone() async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   //await prefs.setDouble('userSensitivity', 50.00);
//   String sTone = await prefs.getString('userTone');
//   if (sTone == null){
//     await prefs.setString('userTone', "1500");
//   }
//   //print(dSensitivity.toString());
//   return sTone;
// }
//
// setUserTone(String newValue) async{
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   await prefs.setString('userTone', newValue);
//   print("New user tone was set to: "+ newValue);
//
// }

