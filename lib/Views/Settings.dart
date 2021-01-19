import 'dart:async';
import 'dart:io';

import 'package:audio_session/audio_session.dart';
import 'package:audioplayers/audio_cache.dart';
//import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:topshottimer/Themes.dart';
import 'package:topshottimer/Views/editUserDetails.dart';
import 'package:topshottimer/main.dart';


class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  Future newSensitivityFuture;
  Future newDelayFuture;
  Future fFirstName;
  Future fLastName;
  Future fEmail;

  AudioPlayer player = AudioPlayer();




  @override
  void initState(){
    super.initState();
    //initPlayer();
    _setSession();
    fFirstName = _getFirstName();
    fLastName = _getLastName();
    fEmail = _getEmail();
    newDelayFuture = _getDelay();
    newSensitivityFuture = _getSensitivity();
  }

  _getFirstName() async{
    FirstName = await userFirstName();
    return userFirstName();
  }

  _getLastName() async{
    LastName = await userLastName();
    return userLastName();
  }

  _getEmail() async {
    Email = await userEmail();
    return userEmail();
  }

  _getDelay() async{
    sliderValue2 = await userDelay();
    if (sliderValue2 == null)
    {
      sliderValue2 = 3;
    }
    return userDelay();
  }

  _getSensitivity() async{
    sliderValue1 = await userSensitivity();
    if (sliderValue1 == null)
    {
      sliderValue1 = 50.0;
    }

    return userSensitivity();
  }

  getDetails() async{

  }
  // Store both of these values in user defaults
  //Stewart Knows How User Defaults Works
  //**********************************************
  double sliderValue1 = 0;
  double sliderValue2 = 1;
  String FirstName = "";
  String LastName = "";
  String Email = "";

  int dropDownValue = 1;
  // AudioPlayer advancedPlayer;
  // AudioCache audioCache;
  String localPathFile;

  //var sHello = await userSensitivity(context);
  //**********************************************

  String secDelay = '3';
  var arrSensititvity = ['Extremely Not Sensitive','Not Sensitive','Normal','Sensitive','Extremely Sensitive'];
  String timerSensitivity = 'Normal';

  _setSession() async {
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration(
      avAudioSessionCategory: AVAudioSessionCategory.playAndRecord,
      avAudioSessionCategoryOptions: AVAudioSessionCategoryOptions.defaultToSpeaker,

    ));

  }

  // void initPlayer(){
  //   advancedPlayer = AudioPlayer();
  //   audioCache = AudioCache(fixedPlayer: advancedPlayer);
  // }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            padding: EdgeInsets.only(top: 35,bottom: 20,left: 20, right: 20),
            child: FutureBuilder(

              future: newSensitivityFuture,
              builder: (context, snapshot )  {

                switch (snapshot.connectionState) {
                  case ConnectionState.active:
                  case ConnectionState.waiting:
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
                    ); //or a placeholder
                  case ConnectionState.done:
                    if (snapshot.hasError) {
                      return Text('Error Here: ${snapshot.error}');
                    } else {
                      print(sliderValue1);
                      print(FirstName);

                      return Column(
                        //mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(top: 20,bottom: 0,left: 0, right: 0),
                            //child: Text('TopShot Timer', style: TextStyle(fontSize: 40, fontWeight: FontWeight.w600, ))

                          ),
                          Text('First Name: ', style: TextStyle(
                              fontSize: 28.0, color: Themes.darkButton2Color),),
                          Text(FirstName.toString(), style: TextStyle(
                              fontSize: 20.0
                          ),),
                          Container(
                            padding: EdgeInsets.only(top: 15,bottom: 0,left: 0, right: 0),
                            //child: Text('TopShot Timer', style: TextStyle(fontSize: 40, fontWeight: FontWeight.w600, ))

                          ),
                          Text('Last Name: ', style: TextStyle(
                              fontSize: 28.0, color: Themes.darkButton2Color
                          ),),
                          Text(LastName.toString(), style: TextStyle(
                              fontSize: 20.0
                          ),),
                          Container(
                            padding: EdgeInsets.only(top: 15,bottom: 0,left: 0, right: 0),
                            //child: Text('TopShot Timer', style: TextStyle(fontSize: 40, fontWeight: FontWeight.w600, ))

                          ),
                          Text('Email: ', style: TextStyle(
                              fontSize: 28.0, color: Themes.darkButton2Color
                          ),),
                          Text(Email.toString(), style: TextStyle(
                              fontSize: 20.0
                          ),),
                          Container(
                            padding: EdgeInsets.only(top: 15,bottom: 0,left: 0, right: 0),
                            //child: Text('TopShot Timer', style: TextStyle(fontSize: 40, fontWeight: FontWeight.w600, ))

                          ),
                          Container(
                            padding: EdgeInsets.only(top: 10,bottom: 0,left: 0, right: 0),
                            //child: Text('TopShot Timer', style: TextStyle(fontSize: 40, fontWeight: FontWeight.w600, ))

                          ),
                          FlatButton(
                            color: Themes.darkButton1Color,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0), side: BorderSide(color: Themes.darkButton1Color)),
                            height: 50,
                            minWidth: 150,
                            child: Text("Edit Details",style: TextStyle(fontSize: 20,color: Theme.of(context).buttonColor ),),
                            onPressed: () async {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => editUserDetails()));

                              //Navigator.pushReplacementNamed(context, '/editUserDetails');
                              print("Going to edit details");
                            },


                          ),
                          Container(
                            padding: EdgeInsets.only(top: 10,bottom: 0,left: 0, right: 0),
                            //child: Text('TopShot Timer', style: TextStyle(fontSize: 40, fontWeight: FontWeight.w600, ))

                          ),
                          Text('Timer Sensitivity', style: TextStyle(
                              fontSize: 30.0
                          ),),
                          Slider(
                            value: sliderValue1,
                            min: 0,
                            max: 100,
                            activeColor: Color(0xFFA2C11C),
                            inactiveColor: Color(0xFF2C5D63),
                            divisions: 4,
                            label: sliderValue1.toString(),
                            onChanged: (double newValue) {
                              setState(() {
                                sliderValue1 = newValue;

                                if (newValue == 0.0){
                                  timerSensitivity = arrSensititvity[0].toString();
                                }
                                if (newValue == 25.0){
                                  timerSensitivity = arrSensititvity[1].toString();
                                }
                                if (newValue == 50.0){
                                  timerSensitivity = arrSensititvity[2].toString();
                                }
                                if (newValue == 75.0){
                                  timerSensitivity = arrSensititvity[3].toString();
                                }
                                if (newValue == 100.0){
                                  timerSensitivity = arrSensititvity[4].toString();
                                }
                                return sliderValue1;
                              });
                              setDefaultSensitivity(newValue);
                              print('Start: ${newValue}');
                            },),
                          Text('Timer Delay', style: TextStyle(
                              fontSize: 30.0
                          ),),

                          Slider(
                            value: sliderValue2,
                            min: 1,
                            max: 5,
                            activeColor: Color(0xFFA2C11C),
                            inactiveColor: Color(0xFF2C5D63),
                            divisions: 4,
                            label: sliderValue2.toString(),
                            onChanged: (double newValue) {
                              setState(() {
                                sliderValue2 = newValue;

                                if (newValue == 1){
                                  secDelay = '1';
                                }
                                if (newValue == 2){
                                  secDelay = '2';
                                }
                                if (newValue == 3){
                                  secDelay = '3';
                                }
                                if (newValue == 4){
                                  secDelay = '4';
                                }
                                if (newValue == 5){
                                  secDelay = '5';
                                }
                                return sliderValue2;
                              });
                              setDefaultDelay(newValue);
                              print('Start: ${newValue}');
                            },),

                          Text('Timer Tone', style: TextStyle(
                              fontSize: 30.0
                          ),),

                          DropdownButton(
                              value: dropDownValue,
                              dropdownColor: Colors.green,
                              items: [
                                DropdownMenuItem(
                                  child: Text("Tone 1"),
                                  value: 1,
                                ),
                                DropdownMenuItem(
                                  child: Text("Tone 2"),
                                  value: 2,
                                ),
                                DropdownMenuItem(
                                    child: Text("Tone 3"),
                                    value: 3
                                ),
                                DropdownMenuItem(
                                    child: Text("Tone 4"),
                                    value: 4
                                ),
                                DropdownMenuItem(
                                  child: Text("Tone 5"),
                                  value: 5,
                                ),
                                DropdownMenuItem(
                                  child: Text("Tone 6"),
                                  value: 6,
                                ),
                                DropdownMenuItem(
                                    child: Text("Tone 7"),
                                    value: 7
                                ),
                                DropdownMenuItem(
                                    child: Text("Tone 8"),
                                    value: 8
                                ),
                                DropdownMenuItem(
                                  child: Text("Tone 9"),
                                  value: 9,
                                ),
                                DropdownMenuItem(
                                  child: Text("Tone 10"),
                                  value: 10,
                                )
                              ],
                              onChanged: (value) {
                                setState(() {
                                  dropDownValue = value;
                                  print("Selected dropdown value: " + value.toString());
                                  String sAudioString;
                                  if (value == 1){
                                    sAudioString = "1500";
                                  } else
                                  if (value == 2){
                                    sAudioString = "1700";
                                  } else
                                  if (value == 3){
                                    sAudioString = "1900";
                                  } else
                                  if (value == 4){
                                    sAudioString = "2100";
                                  } else
                                  if (value == 5){
                                    sAudioString = "2300";
                                  } else
                                  if (value == 6){
                                    sAudioString = "2500";
                                  } else
                                  if (value == 7){
                                    sAudioString = "2700";
                                  } else
                                  if (value == 8){
                                    sAudioString = "2900";
                                  } else
                                  if (value == 9){
                                    sAudioString = "3100";
                                  } else
                                  if (value == 10){
                                    sAudioString = "3300";
                                  }
                                  player.stop();
                                  var duration = player.setAsset("assets/audios/"+ sAudioString + ".mp3");
                                  player.setVolume(1.0);
                                  player.seek(Duration(milliseconds: 0));
                                  player.play();
                                  //player.stop();

                                  // Timer(Duration(milliseconds: 800), () {
                                  //   //player.pause();
                                  //     player.stop();
                                  //     //var duration =  player.load();
                                  //     // player.dispose();
                                  // });
                                  //
                                  if (Platform.isIOS) {
                                    _setSession();
                                  }


                                  //audioCache.play(sAudioString+'.mp3');
                                  setUserTone(sAudioString);
                                });
                              }),
                          Container(
                            padding: EdgeInsets.only(top: 15,bottom: 0,left: 0, right: 0),
                            //child: Text('TopShot Timer', style: TextStyle(fontSize: 40, fontWeight: FontWeight.w600, ))

                          ),
                          FlatButton(
                              color: Themes.darkButton2Color,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0), side: BorderSide(color: Themes.darkButton1Color)),
                              height: 50,
                              minWidth: 150,
                              child: Text("Sign Out",style: TextStyle(fontSize: 20, color: Theme.of(context).buttonColor ),),
                              onPressed: () async {
                                SharedPreferences preferences = await SharedPreferences.getInstance();
                                await preferences.clear();
                                Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp()));
                                print("Signed Out");
                              },


                            ),




                        ],
                      );
                      }
                }
              },

            ),
    ),
    );

  }
}

// doStuff() async{
//   var x = await userSensitivity();
//   return x;
// }

Future <String> userFirstName() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //await prefs.setDouble('userSensitivity', 50.00);
  String sFirstName = await prefs.getString('firstName');

  //print(dSensitivity.toString());
  return sFirstName;

}

Future <String> userLastName() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //await prefs.setDouble('userSensitivity', 50.00);
  String sLastName = await prefs.getString('lastName');

  //print(dSensitivity.toString());
  return sLastName;

}

Future <String> userEmail() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //await prefs.setDouble('userSensitivity', 50.00);
  String sEmail = await prefs.getString('email');

  //print(dSensitivity.toString());
  return sEmail;

}


Future<double> userSensitivity() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //await prefs.setDouble('userSensitivity', 50.00);
  double dSensitivity = await prefs.getDouble('userSensitivity');
  if (dSensitivity == null){
    await prefs.setDouble('userSensitivity', 50.0);
  }
  //print(dSensitivity.toString());
  return dSensitivity;
}

setDefaultSensitivity(double newValue) async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setDouble('userSensitivity', newValue);

}

Future<double> userDelay() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //await prefs.setDouble('userSensitivity', 50.00);
  double dDelay = await prefs.getDouble('userDelay');
  if (dDelay == null){
    await prefs.setDouble('userDelay', 3);
  }
  //print(dSensitivity.toString());
  return dDelay;
}

setDefaultDelay(double newValue) async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setDouble('userDelay', newValue);

}

Future<String> userTone() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //await prefs.setDouble('userSensitivity', 50.00);
  String sTone = await prefs.getString('userTone');
  if (sTone == null){
    await prefs.setString('userTone', "1500");
  }
  //print(dSensitivity.toString());
  return sTone;
}

setUserTone(String newValue) async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('userTone', newValue);
  print("New user tone was set to: "+ newValue);

}
