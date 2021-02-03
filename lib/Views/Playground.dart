import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class PlayGround extends StatefulWidget {
  @override
  _PlayGroundState createState() => _PlayGroundState();
}

class _PlayGroundState extends State<PlayGround> {

  Future sID;

  List<String> arrStringID = List<String>();
  List<String> arrStringName = List<String>();
  List<String> arrTotalShots = List<String>();
  List<String> arrTotalTime = List<String>();




  @override
  void initState() {
    super.initState();

    sID = _getID();





  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: sID,
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
                print('Error Here: ${snapshot.error}');
                return Text('Error Here: ${snapshot.error}');
              } else {
                print("Got into widget");
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







  Future<String> userID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //await prefs.setDouble('userSensitivity', 50.00);
    String sUserID = await prefs.getString('id');

    //print(dSensitivity.toString());
    return sUserID;
  }
  _getID() async{
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


    //sID == await userID();

    return userID();
  }

  Future<String> getData() async{


  }
}




// ListView(
// children: [
// Column(
//
// //mainAxisAlignment: MainAxisAlignment.start,
// crossAxisAlignment: CrossAxisAlignment.start,
// children: <Widget>[
// Container(
// padding: EdgeInsets.only(top: 20,bottom: 0,left: 0, right: 0),
// //child: Text('TopShot Timer', style: TextStyle(fontSize: 40, fontWeight: FontWeight.w600, ))
//
// ),
// Text('First Name: ', style: TextStyle(
// fontSize: 28.0, color: Themes.darkButton2Color),),
// Text(FirstName.toString(), style: TextStyle(
// fontSize: 20.0
// ),),
// Container(
// padding: EdgeInsets.only(top: 15,bottom: 0,left: 0, right: 0),
// //child: Text('TopShot Timer', style: TextStyle(fontSize: 40, fontWeight: FontWeight.w600, ))
//
// ),
// Text('Last Name: ', style: TextStyle(
// fontSize: 28.0, color: Themes.darkButton2Color
// ),),
// Text(LastName.toString(), style: TextStyle(
// fontSize: 20.0
// ),),
// Container(
// padding: EdgeInsets.only(top: 15,bottom: 0,left: 0, right: 0),
// //child: Text('TopShot Timer', style: TextStyle(fontSize: 40, fontWeight: FontWeight.w600, ))
//
// ),
// Text('Email: ', style: TextStyle(
// fontSize: 28.0, color: Themes.darkButton2Color
// ),),
// Text(Email.toString(), style: TextStyle(
// fontSize: 20.0
// ),),
// Container(
// padding: EdgeInsets.only(top: 15,bottom: 0,left: 0, right: 0),
// //child: Text('TopShot Timer', style: TextStyle(fontSize: 40, fontWeight: FontWeight.w600, ))
//
// ),
// Container(
// padding: EdgeInsets.only(top: 10,bottom: 0,left: 0, right: 0),
// //child: Text('TopShot Timer', style: TextStyle(fontSize: 40, fontWeight: FontWeight.w600, ))
//
// ),
// FlatButton(
// color: Themes.darkButton1Color,
// shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0), side: BorderSide(color: Themes.darkButton1Color)),
// height: 50,
// minWidth: 150,
// child: Text("Edit Details",style: TextStyle(fontSize: 20,color: Theme.of(context).buttonColor ),),
// onPressed: () async {
// Navigator.push(context, MaterialPageRoute(builder: (context) => editUserDetails()));
//
// //Navigator.pushReplacementNamed(context, '/editUserDetails');
// print("Going to edit details");
// },
//
//
// ),
// Container(
// padding: EdgeInsets.only(top: 10,bottom: 0,left: 0, right: 0),
// //child: Text('TopShot Timer', style: TextStyle(fontSize: 40, fontWeight: FontWeight.w600, ))
//
// ),
// Text('Timer Sensitivity', style: TextStyle(
// fontSize: 30.0
// ),),
// Slider(
// value: sliderValue1,
// min: 0,
// max: 100,
// activeColor: Color(0xFFA2C11C),
// inactiveColor: Color(0xFF2C5D63),
// divisions: 4,
// label: sliderValue1.toString(),
// onChanged: (double newValue) {
// setState(() {
// sliderValue1 = newValue;
//
// if (newValue == 0.0){
// timerSensitivity = arrSensititvity[0].toString();
// }
// if (newValue == 25.0){
// timerSensitivity = arrSensititvity[1].toString();
// }
// if (newValue == 50.0){
// timerSensitivity = arrSensititvity[2].toString();
// }
// if (newValue == 75.0){
// timerSensitivity = arrSensititvity[3].toString();
// }
// if (newValue == 100.0){
// timerSensitivity = arrSensititvity[4].toString();
// }
// return sliderValue1;
// });
// setDefaultSensitivity(newValue);
// print('Start: ${newValue}');
// },),
// Text('Timer Delay', style: TextStyle(
// fontSize: 30.0
// ),),
//
// Slider(
// value: sliderValue2,
// min: 1,
// max: 5,
// activeColor: Color(0xFFA2C11C),
// inactiveColor: Color(0xFF2C5D63),
// divisions: 4,
// label: sliderValue2.toString(),
// onChanged: (double newValue) {
// setState(() {
// sliderValue2 = newValue;
//
// if (newValue == 1){
// secDelay = '1';
// }
// if (newValue == 2){
// secDelay = '2';
// }
// if (newValue == 3){
// secDelay = '3';
// }
// if (newValue == 4){
// secDelay = '4';
// }
// if (newValue == 5){
// secDelay = '5';
// }
// return sliderValue2;
// });
// setDefaultDelay(newValue);
// print('Start: ${newValue}');
// },),
//
// Text('Timer Tone', style: TextStyle(
// fontSize: 30.0
// ),),
//
// DropdownButton(
// value: dropDownValue,
// dropdownColor: Colors.green,
// items: [
// DropdownMenuItem(
// child: Text("Tone 1"),
// value: 1,
// ),
// DropdownMenuItem(
// child: Text("Tone 2"),
// value: 2,
// ),
// DropdownMenuItem(
// child: Text("Tone 3"),
// value: 3
// ),
// DropdownMenuItem(
// child: Text("Tone 4"),
// value: 4
// ),
// DropdownMenuItem(
// child: Text("Tone 5"),
// value: 5,
// ),
// DropdownMenuItem(
// child: Text("Tone 6"),
// value: 6,
// ),
// DropdownMenuItem(
// child: Text("Tone 7"),
// value: 7
// ),
// DropdownMenuItem(
// child: Text("Tone 8"),
// value: 8
// ),
// DropdownMenuItem(
// child: Text("Tone 9"),
// value: 9,
// ),
// DropdownMenuItem(
// child: Text("Tone 10"),
// value: 10,
// )
// ],
// onChanged: (value) {
// setState(() {
// dropDownValue = value;
// print("Selected dropdown value: " + value.toString());
// String sAudioString;
// if (value == 1){
// sAudioString = "1500";
// } else
// if (value == 2){
// sAudioString = "1700";
// } else
// if (value == 3){
// sAudioString = "1900";
// } else
// if (value == 4){
// sAudioString = "2100";
// } else
// if (value == 5){
// sAudioString = "2300";
// } else
// if (value == 6){
// sAudioString = "2500";
// } else
// if (value == 7){
// sAudioString = "2700";
// } else
// if (value == 8){
// sAudioString = "2900";
// } else
// if (value == 9){
// sAudioString = "3100";
// } else
// if (value == 10){
// sAudioString = "3300";
// }
// player.stop();
// var duration = player.setAsset("assets/audios/"+ sAudioString + ".mp3");
// player.setVolume(1.0);
// player.seek(Duration(milliseconds: 0));
// player.play();
// //player.stop();
//
// // Timer(Duration(milliseconds: 800), () {
// //   //player.pause();
// //     player.stop();
// //     //var duration =  player.load();
// //     // player.dispose();
// // });
// //
// if (Platform.isIOS) {
// _setSession();
// }
//
//
// //audioCache.play(sAudioString+'.mp3');
// setUserTone(sAudioString);
// });
// }),
// Container(
// padding: EdgeInsets.only(top: 15,bottom: 0,left: 0, right: 0),
// //child: Text('TopShot Timer', style: TextStyle(fontSize: 40, fontWeight: FontWeight.w600, ))
//
// ),
// FlatButton(
// color: Themes.darkButton2Color,
// shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0), side: BorderSide(color: Themes.darkButton1Color)),
// height: 50,
// minWidth: 150,
// child: Text("View Privacy Policy",style: TextStyle(fontSize: 20, color: Theme.of(context).buttonColor ),),
// onPressed: () async {
// _launchURL();
// //SharedPreferences preferences = await SharedPreferences.getInstance();
// //await preferences.clear();
// //Navigator.pushReplacementNamed(context, '/LoginSignUp/login');
// //print("Signed Out");
// },
//
//
// ),
// FlatButton(
// color: Themes.darkButton2Color,
// shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0), side: BorderSide(color: Themes.darkButton1Color)),
// height: 50,
// minWidth: 150,
// child: Text("Sign Out",style: TextStyle(fontSize: 20, color: Theme.of(context).buttonColor ),),
// onPressed: () async {
// SharedPreferences preferences = await SharedPreferences.getInstance();
// await preferences.clear();
// Navigator.pushReplacementNamed(context, '/LoginSignUp/login');
// print("Signed Out");
// },
//
//
// ),
//
//
//
//
//
//
//
// ],
// ),
//
// Expanded(child:
// Align(
// alignment: Alignment.bottomCenter,
// child: Text("Hello World"),
// )),
// SizedBox(
// height: 30,
// ),
//
//
//
//
//
// ],
//
// ),

