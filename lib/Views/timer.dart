import 'dart:async';
import 'dart:isolate';
import 'package:audio_session/audio_session.dart';
//import 'package:dartins/dartins.dart';
//import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/material.dart';
//import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:noise_meter/noise_meter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:topshottimer/Views/splits.dart';
import 'dart:io' show Platform;

import '../Themes.dart';

//import 'package:isolate/isolate.dart';
//Pushing to Merge

const String testDevice = '';


double timerSensitivity;
int timerDelay;
String timerTone;

class TimerPage extends StatefulWidget {
  @override
  _TimerPageState createState() => _TimerPageState();

}

class _TimerPageState extends State<TimerPage> {



  @override
  void initState(){
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: timerArea())
    );
  }}

class timerArea extends StatefulWidget {
  @override
  _timerAreaState createState() => _timerAreaState();

}

class _timerAreaState extends State<timerArea> {


  bool _isRecording = false;

  List<String> arrShots = List<String>();
  List<int> arrMinutes = List<int>();
  List<int> arrSeconds = List<int>();
  List<int> arrMilliseconds = List<int>();

  bool bResetOnStart = false;
  bool bstop = false;
  bool startispressed = true;
  bool stopispressed = true;
  String stoptimetodisplay = "00:00:00";
  int iMinutes;
  int iSeconds;
  int iMilliseconds;

  var swatch = Stopwatch();
  final dur = const Duration(milliseconds: 1);
  int iCountShots = 0;
  bool isRunning = false;
  bool bClicked = false;
  double dTime = 0.00;
  // Duration _duration = Duration();
  // Duration _position = Duration();
  // AudioPlayer audioPlayer = AudioPlayer();
  // AudioPlayer advancedPlayer;
  // AudioCache audioCache;
  String localPathFile;
  final startStop = TextEditingController();
  bool didReset = true;
  String buttonText = "Start";
  bool isChanged = true;
  Color btnColor = new Color(0xFFA2C11C);
  bool colorisChanged = true;

  //Future playSoundFuture;
  AudioPlayer player = AudioPlayer();





  //final player = AudioCache();

  StreamSubscription<NoiseReading> _noiseSubscription;
  NoiseMeter _noiseMeter;


  Future permissions() async{
    Map<Permission, PermissionStatus> statuses = await [
      Permission.microphone,
    ].request();
    print(statuses[Permission.microphone]);

  }
  @override
  void initState(){
    super.initState();
    arrShots.add("00:00:00");

    obtainUserDefaults();
    permissions();
    _noiseMeter = new NoiseMeter(onError);
    //playSoundFuture = _playSound();
    if (Platform.isIOS) {
      _setSession();
    }
    //start();
    // stopRecorder();
    //initPlayer();
  }


  // void initPlayer(){
  //   advancedPlayer = AudioPlayer();
  //   audioCache = AudioCache(fixedPlayer: advancedPlayer);
  //
  //   advancedPlayer.durationHandler = (d) => setState((){
  //     _duration = d;
  //   });
  //   advancedPlayer.positionHandler = (d) => setState((){
  //     _position = d;
  //   });
  // }


  void keeprunning(){
    if (swatch.isRunning){
      starttimer();
    }
    setState(() {
      stoptimetodisplay = (swatch.elapsed.inMinutes%60).toString().padLeft(2,"0") + ":" + (swatch.elapsed.inSeconds%60).toString().padLeft(2,"0") + ":" + (swatch.elapsed.inMilliseconds%1000).toString().padLeft(2,"0");
      iMinutes = swatch.elapsed.inMinutes%60;
      iSeconds = swatch.elapsed.inSeconds%60;
      iMilliseconds = swatch.elapsed.inMilliseconds%1000;

      // print("In Minutes: " + iMinutes.toString());
      // print("In Seconds: "+ iSeconds.toString());
      // print("In Milliseconds: " + iMilliseconds.toString());
      // print("-------------------------");


    });
  }

  void starttimer(){
    Timer(dur, keeprunning);
    bstop = true;
  }

  void stoptimer(){
    swatch.stop();
  }

  _setSession() async {
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration(
      avAudioSessionCategory: AVAudioSessionCategory.playAndRecord,
      avAudioSessionCategoryOptions: AVAudioSessionCategoryOptions.defaultToSpeaker,

    ));

  }

  // _playSound() async{
  //
  //   return "true";
  // }
  //
  // triggerSound() async{
  //   playSoundFuture = _playSound();
  // }

  Future<void> startstopwatch() async {
    setState(() {
      stopispressed = false;
    });
    if (bstop == false){
      bstop = true;
      isRunning = true;
      print("Going to play sound now!!!!");
      print("Before seconds duration");

      var duration = await player.setAsset("assets/audios/"+ timerTone + ".mp3");

      print(timerDelay);
      if (timerDelay == 1){
        await Future.delayed(const Duration(seconds: 1));
      }else
      if (timerDelay == 2){
        await Future.delayed(const Duration(seconds: 2));
      }else
      if (timerDelay == 3){
        await Future.delayed(const Duration(seconds: 3));
      }else
      if (timerDelay == 4){
        await Future.delayed(const Duration(seconds: 4));
      }else
      if (timerDelay == 5){
        await Future.delayed(const Duration(seconds: 5));
      }
      print("Before Play");
      player.setVolume(1.0);
      player.seek(Duration(milliseconds: 0));
      player.play();
      // player.play();
      //await player.seek(Duration(milliseconds: 445));
      // await Future.delayed(const Duration(milliseconds: 1000));
      // start();

      Timer(Duration(milliseconds: 600), () {
        //player.pause();
        start();
      });
      //print(timerDelay.toString());
      //start();
      //print(bstop.toString() + "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
      bResetOnStart = false;
    }
    else if (bstop == true){
      //playSoundFuture = null;
      //player.pause();
      //player.stop();
      //player.pause();
      //player.dispose();

      startispressed = true;
      isRunning = false;
      didReset = false;
      stoptimer();
      stopRecorder();
      reset();
      bResetOnStart = true;
      if (Platform.isIOS) {
        _setSession();
      }
      // print("Total Minutes: "+arrMinutes[arrMinutes.length-1].toString());
      // print("Total Seconds: "+arrSeconds[arrSeconds.length-1].toString());
      // print("Total Milliseconds: "+arrMilliseconds[arrMilliseconds.length-1].toString());
      // print(arrMinutes[arrMinutes.length-1].toString() + ":" + arrSeconds[arrSeconds.length-1].toString()+ ":" + arrMilliseconds[arrMilliseconds.length-1].toString());
      // for (var i = 0; i <= arrShots.length-1; i++) {
      //   print(arrShots[i]);
      // }
      print("*********************"+ arrShots[arrShots.length-1]);
      bstop = false;
    }

  }
  void reset() {
    setState(() {
      startispressed = true;
    });

    swatch.reset();
  }


  //////////////////////////NOISE METER START
  void start() async {
    print("Got into start method");
    starttimer();
    swatch.start();
    try {
      _noiseSubscription = _noiseMeter.noiseStream.listen(onData);

    } on NoiseMeter catch (exception) {
      print("Start Exception: " + exception.toString());
    }

  }

  void onData(NoiseReading noiseReading) {
    print("Got into data method");
    //audioCache.play('2100.mp3');
    this.setState(() {
      if (!this._isRecording) {
        this._isRecording = true;
      }
    });
    //print("Got to on Data method");
    //print(noiseReading.toString());

    if(noiseReading.maxDecibel>timerSensitivity){
      //arrShots.add(noiseReading.maxDecibel.toString());
      arrShots.add(stoptimetodisplay);
      arrMinutes.add(iMinutes);
      arrSeconds.add(iSeconds);
      arrMilliseconds.add(iMilliseconds);

      print("Gun Shot Captured!!!!!!!!!!!!!!!!" + noiseReading.maxDecibel.toString());
      iCountShots++;
    }
  }

  void onError(PlatformException e) {
    print(e.toString());
    _isRecording = false;
  }

  void stopRecorder() async {
    try {
      if (_noiseSubscription != null) {
        _noiseSubscription.cancel();
        _noiseSubscription = null;
      }
      this.setState(() {
        this._isRecording = false;
      });
    } catch (err) {
      print('stopRecorder error: $err');
    }
  }

  /////////////////////////////NOISE METER END



  //Actual Widgets
  @override
  Widget build(BuildContext context) {
    var sliderValue = 0.0;

    return Scaffold(
        body: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 35,bottom: 15,left: 0, right: 0),
              //child: Text('TopShot Timer', style: TextStyle(fontSize: 40, fontWeight: FontWeight.w600, ))

            ),

            Container(
                padding: EdgeInsets.only(top: 10,bottom: 0,left: 0, right: 0),
                child:
                FlatButton(
                  //color: btnColor,
                  minWidth: 250,
                  height: 250,
                  shape: CircleBorder(side: BorderSide(color: btnColor, width: 4)),
                  onPressed: () {
                    obtainUserDefaults();
                    if(bResetOnStart == true){
                      arrShots.clear();
                      arrShots.add("00:00:00");
                      iCountShots = 0;
                      swatch.reset();
                      stopRecorder();
                      stoptimer();
                      reset();
                      //startstopwatch();
                      didReset = true;

                    }

                    if (didReset == true){


                      print("Got into pressed method");
                      if (startispressed == true) {
                        //audioCache.play("2100.mp3");
                        //playSoundFuture = _playSound();
                        //triggerSound();
                        startstopwatch();
                        isChanged = !isChanged;
                        colorisChanged = !colorisChanged;
                        setState(() {
                          colorisChanged == true ? btnColor = Color(0xFFA2C11C) : btnColor = Color(0xFF2C5D63);
                          isChanged == true ? buttonText = "Start" : buttonText = "Stop";
                        });
                        //Future.delayed(const Duration(seconds: 2));
                      }
                    }
                    else
                    {
                      Fluttertoast.showToast(
                          msg: "Please reset before starting another string",

                          //BoxDecoration(borderRadius: BorderRadius.circular(25.0)),
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 3,
                          backgroundColor: Colors.red,

                          textColor: Colors.black,
                          fontSize: 24.0
                      );
                      print("You need to reset");
                    }

                    //startispressed ? startstopwatch: null;
                  },
                  child: Text(buttonText, style: TextStyle(fontSize: 80, fontFamily: 'Digital-7', color: Theme.of(context).buttonColor)),
                )
            ),
            Container(
                padding: EdgeInsets.only(top: 20,bottom: 0,left: 0, right: 0),
                child:
                Text(arrShots[arrShots.length-1] , style: TextStyle(
                    fontSize: 80,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Digital-7'
                ),)

              //arrShots.length == -1 ? "00:00:00" : arrShots[arrShots.length-1]
              // isChanged == true ? buttonText = "Start" : buttonText =
              // "Stop";
            ),
            Container(
                padding: EdgeInsets.only(top: 10,bottom: 30,left: 0, right: 0),
                child:
                Text((iCountShots).toString(), style: TextStyle(
                    fontSize: 80,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Digital-7'
                ),)

            ),

            Row(

                children: <Widget>[
                  Spacer(),

                  // FlatButton(
                  //   //color: Colors.red,
                  //     minWidth: 170,
                  //     height: 50,
                  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0), side: BorderSide(width: 2, color: Colors.black),),
                  //     child: Text("Reset", style: TextStyle(fontSize: 25)),
                  //
                  //     onPressed: () {
                  //       if (isRunning == false){
                  //         arrShots.clear();
                  //         arrShots.add("00:00:00");
                  //         iCountShots = 0;
                  //         swatch.reset();
                  //         stopRecorder();
                  //         stoptimer();
                  //         reset();
                  //         //startstopwatch();
                  //         didReset = true;
                  //       } else{
                  //         Fluttertoast.showToast(
                  //             msg: "Please stop the timer before tapping reset",
                  //             //BoxDecoration(borderRadius: BorderRadius.circular(25.0)),
                  //             toastLength: Toast.LENGTH_SHORT,
                  //             gravity: ToastGravity.BOTTOM,
                  //             timeInSecForIosWeb: 3,
                  //             backgroundColor: Colors.red,
                  //
                  //             textColor: Colors.black,
                  //             fontSize: 24.0
                  //         );
                  //       }
                  //
                  //
                  //
                  //     }
                  // ),
                  // Spacer(),
                  FlatButton(
                    //color: Colors.blue,
                      minWidth: 200,
                      height: 50,
                      color: Color(0xFF2C5D63),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0), side: BorderSide(width: 2, color: Color(0xFF2C5D63)),),
                      child: Text("View String", style: TextStyle(fontSize: 25, color: Theme.of(context).buttonColor )),
                      onPressed: () {
                        if(arrShots.length <= 1 ){
                          print("Should get into alert");
                          errorViewingStringDialog();

                          // AlertDialog alert = AlertDialog(
                          //   title: Text("Warning!"),
                          //   content: Text("No shots registered. Please shoot a string of shots before viewing the string."),
                          //   actions: [
                          //     FlatButton(child: Text("Ok"),
                          //       onPressed: () {
                          //         Navigator.pop(context);
                          //       },),                        ],
                          // );
                          //
                          // return showDialog(
                          //     context: context,
                          //     builder: (BuildContext context){
                          //       return alert;
                          //     }
                          // );

                        }
                        else
                          Navigator.push(context, MaterialPageRoute(builder: (context) => Splits(arrShots.toString())));
                      }
                  ),
                  Spacer(),

                ]

            ),


          ],
        )
    );

  }
  errorViewingStringDialog(){

    Dialog dialog = new Dialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
        ),
        child: Stack(
          overflow: Overflow.visible,
          alignment: Alignment.topCenter,
          children: [
            Container(
              //this will affect the height of the dialog
              height: 140,
              child: Padding(
                //play with top padding to make items fit
                padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("Please shoot a string before viewing.", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                    SizedBox(height: 20,),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Expanded(
                          child: InkWell(
                            onTap: (){
                              Navigator.pop(context);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                                color: Colors.blueAccent,
                              ),
                              height: 45,
                              child: Center(
                                child: Text("TRY AGAIN",
                                    style: TextStyle(fontSize: 20)),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
                top: -40,
                child: CircleAvatar(
                    backgroundColor: Colors.redAccent,
                    radius: 40,
                    child: Image.asset("assets/Exclamation@3x.png", height: 53,)
                )
            ),
          ],
        )
    );
    showDialog(context: context, builder: (context) => dialog);
  }

}

obtainUserDefaults() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  double dDelay = await prefs.getDouble('userDelay');
  double dSensitivity = await prefs.getDouble('userSensitivity');
  String sTone = await prefs.getString('userTone');

  if (dDelay == null)
  {
    await prefs.setDouble('userDelay',3);
    dDelay = await prefs.getDouble('userDelay');
  }

  if (dSensitivity == null)
  {
    await prefs.setDouble('userSensitivity',50.0);
    dSensitivity = await prefs.getDouble('userSensitivity');
  }

  if (sTone == null){
    print("*******************************NO TONE SET");
    await prefs.setString('userTone',"2100");
    sTone = await prefs.getString('userTone');

  }

  if (dSensitivity == 0.0){
    timerSensitivity = 89.4;
  } else
  if (dSensitivity == 25.0){
    timerSensitivity = 80.0;
  } else
  if (dSensitivity == 50.0){
    timerSensitivity = 70.0;
  } else
  if (dSensitivity == 75.0){
    timerSensitivity = 60.0;
  } else
  if (dSensitivity == 100.0){
    timerSensitivity = 50.0;
  }
  else {
    print("No User Defaults set");
  }
  double dTime;
  dTime = await double.parse(dDelay.toStringAsFixed(0));
  timerDelay = dDelay.round();
  timerTone = sTone;

  // print("Default Delay: " + dDelay.toString());
  // print("Default Sensitivity: " + dSensitivity.toString());
  // print("Default Tone: " + sTone.toString());
  //
  // print("USER DEFAULTS: SENSITIVITY- " + timerSensitivity.toString());
  // print("USER DEFAULTS: DELAY- " + timerDelay.toString());
  // print("USER DEFAULTS: TONE- " + sTone);

}





//
// s.start();
// sleep(new Duration(seconds: 2));
// print(s.isRunning); // true
// print(s.elapsedMilliseconds); // around 2000ms
//
// sleep(new Duration(seconds: 1));
// s.stop();
// print(s.elapsedMilliseconds); // around 3000ms
// print(s.isRunning); // false
//
// sleep(new Duration(seconds: 1));
// print(s.elapsedMilliseconds); // around 3000ms
//
// s.reset();
// print(s.elapsedMilliseconds); // 0