import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:noise_meter/noise_meter.dart';
import 'package:fluttertoast/fluttertoast.dart';




class TimerPage extends StatefulWidget {
  @override
  _TimerPageState createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blueGrey,
        //appBar: AppBar(title: Text('Timer Page')),
        body: Center(child: timerArea())
    );
  }}

class timerArea extends StatefulWidget {
  @override
  _timerAreaState createState() => _timerAreaState();
}

class _timerAreaState extends State<timerArea> {

  bool _isRecording = false;
  StreamSubscription<NoiseReading> _noiseSubscription;
  NoiseMeter _noiseMeter = new NoiseMeter();
  List<String> arrShots = List<String>();
  bool bstop = false;
  bool startispressed = true;
  bool stopispressed = true;
  String stoptimetodisplay = "00:00:00";
  var swatch = Stopwatch();
  final dur = const Duration(milliseconds: 1);
  int iCountShots = 0;
  bool isRunning = false;
  bool bClicked = false;
  double dTime = 0.00;
  Duration _duration = Duration();
  Duration _position = Duration();
  AudioPlayer advancedPlayer;
  AudioCache audioCache;
  String localPathFile;
  final startStop = TextEditingController();
  bool didReset = true;
  String buttonText = "Start";
  bool isChanged = true;
  Color btnColor = new Color.fromRGBO(0, 255, 26, 100);
  bool colorisChanged = true;

  void keeprunning(){
    if (swatch.isRunning){
      starttimer();
    }
    setState(() {
      stoptimetodisplay = (swatch.elapsed.inMinutes%60).toString().padLeft(2,"0") + ":" + (swatch.elapsed.inSeconds%60).toString().padLeft(2,"0") + ":" + (swatch.elapsed.inMilliseconds%1000).toString().padLeft(2,"0");
    });
  }

  void starttimer(){
    isRunning = true;
    Timer(dur, keeprunning);
    bstop = true;
  }

  void stoptimer(){
    swatch.stop();
    isRunning = false;
  }





  Future<void> startstopwatch() async {
    setState(() {
      stopispressed = false;
    });
    if (bstop == false){
      bstop = true;
      print("Going to play sound now!!!!");
      await Future.delayed(const Duration(seconds: 2), (){});
      audioCache.play('2100.mp3');
      swatch.start();
      starttimer();
      start();
      //print(bstop.toString() + "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
    }
    else if (bstop == true){
      didReset = false;
      stoptimer();
      stopRecorder();
      //stoptimer();
      reset();
      // iCountShots = 0;
      for (var i = 0; i <= arrShots.length-1; i++) {
        print(arrShots[i]);
      }

      bstop = false;
    }

  }
  void reset() {
    setState(() {
      startispressed = true;
    });

    swatch.reset();
  }
  void start() async {
    try {
      _noiseSubscription = _noiseMeter.noiseStream.listen(onData);
    } on NoiseMeter catch (exception) {
      print(exception);
    }
  }

  void onData(NoiseReading noiseReading) {
    this.setState(() {
      if (!this._isRecording) {
        this._isRecording = true;
      }
    });

    if(noiseReading.maxDecibel>89.8){
      arrShots.add(noiseReading.maxDecibel.toString());
      arrShots.add(stoptimetodisplay);

      print("Gun Shot Captured!!!!!!!!!!!!!!!!" + noiseReading.maxDecibel.toString());
      iCountShots = iCountShots + 1;
    }
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

  @override
  void initState(){
    super.initState();
    initPlayer();
  }
  void initPlayer(){
    arrShots.add("00:00:00");
    advancedPlayer = AudioPlayer();
    audioCache = AudioCache(fixedPlayer: advancedPlayer);

    advancedPlayer.durationHandler = (d) => setState((){
      _duration = d;
    });
    advancedPlayer.positionHandler = (d) => setState((){
      _position = d;
    });
  }


  //Actual Widgets
  @override
  Widget build(BuildContext context) {
    var sliderValue = 0.0;
    return Column(
      children: [
        Container(
            padding: EdgeInsets.only(top: 35,bottom: 0,left: 0, right: 0),
            child: Text('TopShot Timer', style: TextStyle(fontSize: 60, fontWeight: FontWeight.w700, fontFamily: 'Digital-7'))

        ),
        Container(
            padding: EdgeInsets.only(top: 10,bottom: 0,left: 0, right: 0),
            child:
            FlatButton(
                color: Colors.red,
                minWidth: 80,
                height: 80,
                shape: CircleBorder(side: BorderSide(color: Colors.black, width: 4)),
                child: Text("Reset", style: TextStyle(fontSize: 25, fontFamily: 'Digital-7')),
                onPressed: () {
                  if (isRunning == false){
                    arrShots.clear();
                    arrShots.add("00:00:00");
                    iCountShots = 0;
                    swatch.reset();
                    stopRecorder();
                    stoptimer();
                    reset();
                    //startstopwatch();
                    didReset = true;
                  } else{
                    Fluttertoast.showToast(
                        msg: "Please stop the timer before tapping reset",
                        //BoxDecoration(borderRadius: BorderRadius.circular(25.0)),
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 3,
                        backgroundColor: Colors.red,

                        textColor: Colors.black,
                        fontSize: 24.0
                    );
                  }



                }
            )
        ),
        Container(
            padding: EdgeInsets.only(top: 10,bottom: 0,left: 0, right: 0),
            child:
            FlatButton(
              color: btnColor,
              minWidth: 250,
              height: 250,
              shape: CircleBorder(side: BorderSide(color: Colors.black, width: 4)),
              onPressed: () {
                if (didReset == true){
                  print("Got into pressed method");
                  if (startispressed = true){
                    startstopwatch();
                    isChanged = !isChanged;
                    colorisChanged = !colorisChanged;
                    setState(() {
                      colorisChanged == true ? btnColor = new Color.fromRGBO(0, 255, 26, 100) : btnColor = Colors.red;
                      isChanged == true ? buttonText = "Start" : buttonText = "Stop";
                    });
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
              child: Text(buttonText, style: TextStyle(fontSize: 80, fontFamily: 'Digital-7')),
            )
        ),
        Container(
            padding: EdgeInsets.only(top: 10,bottom: 0,left: 0, right: 0),
            child:
            Text(arrShots[arrShots.length-1], style: TextStyle(
                fontSize: 80,
                fontWeight: FontWeight.w700,
                fontFamily: 'Digital-7'
            ),)

        ),
        Container(
            padding: EdgeInsets.only(top: 10,bottom: 0,left: 0, right: 0),
            child:
            Text((iCountShots).toString(), style: TextStyle(
                fontSize: 80,
                fontWeight: FontWeight.w700,
                fontFamily: 'Digital-7'
            ),)

        ),
        Container(
          child: Slider(
            min: 0.0,
            max: 5.0,
            divisions: 5,
            value: sliderValue,
            activeColor: Colors.red,
            inactiveColor: Colors.black,
            onChanged: (newValue){
              sliderValue = newValue;

            },
            label: "$sliderValue",
          ),
        )

      ],
    );
  }

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