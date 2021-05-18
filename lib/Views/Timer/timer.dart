import 'dart:async';
import 'dart:isolate';
import 'dart:math';
import 'dart:io' as io;
import 'package:admob_flutter/admob_flutter.dart';
import 'package:audio_session/audio_session.dart';
//import 'package:firebase_admob/firebase_admob.dart';

//import 'package:dartins/dartins.dart';
//import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/material.dart';

//import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

// import 'package:noise_meter/noise_meter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:topshottimer/Views/Subscription/pricing.dart';
import 'package:topshottimer/Views/Timer/splits.dart';
import 'dart:io' show Platform;
import 'package:path_provider/path_provider.dart';
import 'package:file/local.dart';

//import 'package:firebase_admob/firebase_admob.dart';
//import 'package:audioplayers/audioplayers.dart';

import '../../Themes.dart';

//import 'package:isolate/isolate.dart';
//Pushing to Merge

const String testDevice = '';

double timerSensitivity;
int timerDelay;
String timerTone;
bool bRandomDelay;

class TimerPage extends StatefulWidget {
  @override
  _TimerPageState createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white, body: Center(child: timerArea()));
  }
}

class timerArea extends StatefulWidget {
  //File Decleration for audio recorder
  final LocalFileSystem localFileSystem;

  timerArea({localFileSystem})
      : this.localFileSystem = localFileSystem ?? LocalFileSystem();

  @override
  _timerAreaState createState() => _timerAreaState();
}

class _timerAreaState extends State<timerArea> {
  int iCountStart = 0;

  bool paidMember = false;
  //Variable declerations for All flags and arrays
  FlutterAudioRecorder _recorder;
  Recording _current;
  RecordingStatus _currentStatus = RecordingStatus.Unset;
  bool bStarted = false;
  bool bCanStart = false;

  bool bTest = true;
  bool _isRecording = false;

  List<String> arrShots = List<String>();
  List<int> arrMinutes = List<int>();
  List<int> arrSeconds = List<int>();
  List<int> arrMilliseconds = List<int>();

  bool bResetOnStart = false;
  bool bstop = false;
  bool startispressed = true;
  bool stopispressed = true;

  //Initial Time
  String stoptimetodisplay = "00:00:00";
  int iMinutes;
  int iSeconds;
  int iMilliseconds;

  String sTestingEar = "";

  bool bStopable = true;

  //Declaring Stopwatch
  var swatch = Stopwatch();
  final dur = const Duration(milliseconds: 1);
  int iCountShots = 0;

  //Flags for starting and stopping timer
  bool isRunning = false;
  bool bClicked = false;
  double dTime = 0.00;

  String localPathFile;
  final startStop = TextEditingController();
  bool didReset = true;
  String buttonText = "Start";
  bool isChanged = true;
  Color btnColor = new Color(0xFFA2C11C);
  bool colorisChanged = true;

  //Future playSoundFuture;
  AudioPlayer player = AudioPlayer();

  GlobalKey<ScaffoldState> scaffoldState = GlobalKey();
  AdmobBannerSize bannerSize;
  AdmobBanner admobBanner;

  //Getting permissions to record
  Future permissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.microphone,
    ].request();
    print(statuses[Permission.microphone]);
  }

  String getAdmobBannerAdUnitID() {
    if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/2934735716';
      //return 'ca-app-pub-3940256099942544~1458002511';
    } else if (Platform.isAndroid) {
      // return 'ca-app-pub-3940256099942544~3347511713';

      //return 'ca-app-pub-7160847622040015/3865665573';
      return 'ca-app-pub-3940256099942544/6300978111';
    }
    return null;
  }

  void requestTracking() async {
    await Admob.requestTrackingAuthorization();
  }

  void showSnackBar(String content) {
    scaffoldState.currentState.showSnackBar(
      SnackBar(
        content: Text(content),
        duration: Duration(milliseconds: 1500),
      ),
    );
  }

  void handleEvent(
      AdmobAdEvent event, Map<String, dynamic> args, String adType) {
    switch (event) {
      case AdmobAdEvent.loaded:
        showSnackBar('New Admob $adType Ad loaded!');
        break;
      case AdmobAdEvent.opened:
        showSnackBar('Admob $adType Ad opened!');
        break;
      case AdmobAdEvent.closed:
        showSnackBar('Admob $adType Ad closed!');
        break;
      case AdmobAdEvent.failedToLoad:
        showSnackBar('Admob $adType failed to load. :(');
        break;
      case AdmobAdEvent.rewarded:
        showDialog(
          context: scaffoldState.currentContext,
          builder: (BuildContext context) {
            return WillPopScope(
              child: AlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text('Reward callback fired. Thanks Andrew!'),
                    Text('Type: ${args['type']}'),
                    Text('Amount: ${args['amount']}'),
                  ],
                ),
              ),
              onWillPop: () async {
                scaffoldState.currentState.hideCurrentSnackBar();
                return true;
              },
            );
          },
        );
        break;
      default:
    }
  }

  @override
  void initState() {
    Admob.initialize();
    //Admob.initialize(testDeviceIds: ['3A8BB6BBCB816D25C3B3D23225A99ABF']);
    super.initState();
    arrShots.add("00:00:00");
    // requestTracking();
    WidgetsFlutterBinding.ensureInitialized();

    //Calls init for audio player
    _init();
    obtainUserDefaults();
    permissions();
// Run this before displaying any ad.

    bannerSize = AdmobBannerSize.BANNER;

    if (Platform.isIOS) {
      //sets session for ios
      _setSession();
      print("*******************GOT TO IOS INITIALISATION********************");
    }
    if (Platform.isAndroid) {
      _setSession();
      player.setVolume(0.0);
      player.seek(Duration(milliseconds: 0));
      player.play();
    }

    //start();
    // stopRecorder();
    //initPlayer();
  }

  // @override
  // void dispose(){
  //   super.dispose();
  //   swatch.reset();
  //   //stoptimer();
  //   //stopRecorder();
  //   stoptimer();
  //   reset();
  //
  // }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    if (_currentStatus == RecordingStatus.Recording) {
      _recorder.stop();
    }
    // animationController.dispose() instead of your controller.dispose
  }

//Checks if swatch is running and if so starts timer
  void keeprunning() {
    if (swatch.isRunning) {
      starttimer();
    }

    if (!mounted) return;
    setState(() {
      stoptimetodisplay =
          (swatch.elapsed.inMinutes % 60).toString().padLeft(2, "0") +
              ":" +
              (swatch.elapsed.inSeconds % 60).toString().padLeft(2, "0") +
              ":" +
              (swatch.elapsed.inMilliseconds % 1000).toString().padLeft(2, "0");
      iMinutes = swatch.elapsed.inMinutes % 60;
      iSeconds = swatch.elapsed.inSeconds % 60;
      iMilliseconds = swatch.elapsed.inMilliseconds % 1000;
      int iMillisecondsCount = swatch.elapsed.inMilliseconds;
      //print(iMillisecondsCount);
      if (iMillisecondsCount >= 200) {
        bStopable = true;
      }
      // Your state change code goes here
    });

    // setState(() {
    //   //Calculation for total times and seperates the minutes, seconds and milliseconds
    //   stoptimetodisplay = (swatch.elapsed.inMinutes%60).toString().padLeft(2,"0") + ":" + (swatch.elapsed.inSeconds%60).toString().padLeft(2,"0") + ":" + (swatch.elapsed.inMilliseconds%1000).toString().padLeft(2,"0");
    //   iMinutes = swatch.elapsed.inMinutes%60;
    //   iSeconds = swatch.elapsed.inSeconds%60;
    //   iMilliseconds = swatch.elapsed.inMilliseconds%1000;
    //   int iMillisecondsCount = swatch.elapsed.inMilliseconds;
    //   //print(iMillisecondsCount);
    //   if (iMillisecondsCount >= 200){
    //     bStopable = true;
    //   }
    //
    //   // print("In Minutes: " + iMinutes.toString());
    //   // print("In Seconds: "+ iSeconds.toString());
    //   // print("In Milliseconds: " + iMilliseconds.toString());
    //   // print("-------------------------");
    //
    //
    // });
  }

  //Starts the timer
  void starttimer() {
    Timer(dur, keeprunning);
    bstop = true;
  }

  //Stops the timer and reinitialises the player and recorder
  void stoptimer() {
    _stopnow();
    _init();
    swatch.stop();
  }

  //Sets the audio sessions
  _setSession() async {
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration(
      avAudioSessionCategory: AVAudioSessionCategory.playAndRecord,
      avAudioSessionCategoryOptions:
          AVAudioSessionCategoryOptions.defaultToSpeaker,
      // androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
      // androidWillPauseWhenDucked: true,
      androidAudioAttributes: const AndroidAudioAttributes(
        contentType: AndroidAudioContentType.speech,
        flags: AndroidAudioFlags.none,
        //usage: AndroidAudioUsage.voiceCommunication,
      ),
      androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
      androidWillPauseWhenDucked: true,
    ));
    //_handleInterruptions(session);
  }

  void _handleInterruptions(AudioSession audioSession) {
    // just_audio can handle interruptions for us, but we have disabled that in
    // order to demonstrate manual configuration.
    bool playInterrupted = false;
    audioSession.becomingNoisyEventStream.listen((_) {
      print('PAUSE');
      player.pause();
    });
    player.playingStream.listen((playing) {
      playInterrupted = false;
      if (playing) {
        audioSession.setActive(true);
      }
    });
    audioSession.interruptionEventStream.listen((event) {
      print('interruption begin: ${event.begin}');
      print('interruption type: ${event.type}');
      if (event.begin) {
        switch (event.type) {
          case AudioInterruptionType.duck:
            if (audioSession.androidAudioAttributes.usage ==
                AndroidAudioUsage.game) {
              player.setVolume(player.volume / 2);
            }
            playInterrupted = false;
            break;
          case AudioInterruptionType.pause:
          case AudioInterruptionType.unknown:
            if (player.playing) {
              player.pause();
              playInterrupted = true;
            }
            break;
        }
      } else {
        switch (event.type) {
          case AudioInterruptionType.duck:
            player.setVolume(min(1.0, player.volume * 2));
            playInterrupted = false;
            break;
          case AudioInterruptionType.pause:
            if (playInterrupted) player.play();
            playInterrupted = false;
            break;
          case AudioInterruptionType.unknown:
            playInterrupted = false;
            break;
        }
      }
    });
  }

  //Starts stop watch and checks various flags have been reset and stopped

  Future<void> startstopwatch() async {
    if (!mounted) return;
    setState(() {
      stopispressed = false;
    });
    if (bstop == false) {
      bStopable = false;
      bstop = true;
      isRunning = true;
      print("Going to play sound now!!!!");
      print("Before seconds duration");
      print(
          "************************* Before Initilisation of Player***********************");

      player.stop();
      if (iCountStart == 0) {
        if (Platform.isAndroid) {
          print(
              "*************************THIS IS ANDROID***********************");
          //var duration = await player.setAsset("assets/audios/"+ timerTone + ".mp3");
          player.setAsset("assets/audios/" + timerTone + ".mp3");
          // player.setVolume(1.0);
          // player.seek(Duration(milliseconds: 0));
          // player.play();
        }
      }

      if (Platform.isIOS) {
        print("*************************THIS IS IOS***********************");
        var duration =
            await player.setAsset("assets/audios/" + timerTone + ".mp3");
        player.setVolume(1.0);
      }

      //player.pause();

      if (bRandomDelay == false) {
        // int max = 5;
        //
        // int randomNumber = Random().nextInt(max) + 1;
        print("Random Delay is false");
        if (timerDelay == 1) {
          await Future.delayed(const Duration(seconds: 1));
        } else if (timerDelay == 2) {
          await Future.delayed(const Duration(seconds: 2));
        } else if (timerDelay == 3) {
          await Future.delayed(const Duration(seconds: 3));
        } else if (timerDelay == 4) {
          await Future.delayed(const Duration(seconds: 4));
        } else if (timerDelay == 5) {
          await Future.delayed(const Duration(seconds: 5));
        }
        // print("Before Play");
        // player.setVolume(1.0);
        // player.seek(Duration(milliseconds: 0));
        // player.play();
        // player.seek(Duration(milliseconds: 0));
        //
        // print("After Play");
        //player.stop();

      } else {
        int max = 5;
        int randomNumber = Random().nextInt(max) + 1;
        //int iRandomNum = randomNumber;
        print("Random Delay is True: " + randomNumber.toString());
        await Future.delayed(Duration(seconds: randomNumber));
      }
      //player.load();
      //player.stop();

      print("Before Play");
      player.setVolume(1.0);
      //player.setAndroidAudioAttributes();
      player.seek(Duration(milliseconds: 0));
      player.play();
      //player.seek(Duration(milliseconds: 0));

      print("After Play");

      Timer(Duration(milliseconds: 700), () {
        print("About to start recording");
        _start();
      });
      //player.dispose();
      iCountStart++;
      bResetOnStart = false;
    } else if (bstop == true) {
      //Displays pricing page if user is not premium

      if (paidMember == false){
        SharedPreferences prefs = await SharedPreferences.getInstance();
        int getCounter = prefs.getInt('stopCounter');

        if(getCounter<2){
          print("*********Counter not reached 10. Adding 1 to counter");
          print("*********Counter Value is: " + getCounter.toString());
          setCounter();
        }
        else{
          print("*********Will display pricing guide now");
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setInt('stopCounter', 0);
          Get.to(pricing(), arguments: {'pop': true});
        }
      }

      startispressed = true;
      isRunning = false;
      didReset = false;
      stoptimer();
      reset();
      bResetOnStart = true;
      if (Platform.isIOS) {
        _setSession();
      }
      // if (Platform.isAndroid) {
      //   _setSession();
      // }
      print("*********************" + arrShots[arrShots.length - 1]);
      bstop = false;
    }
  }

  //resets timer
  void reset() {
    if (!mounted) return;
    setState(() {
      startispressed = true;
    });

    swatch.reset();
  }

//Performs recorder initialisations
  _init() async {
    try {
      if (await FlutterAudioRecorder.hasPermissions) {
        String customPath = '/flutter_audio_recorder_';
        io.Directory appDocDirectory;
//        io.Directory appDocDirectory = await getApplicationDocumentsDirectory();
        if (io.Platform.isIOS) {
          appDocDirectory = await getApplicationDocumentsDirectory();
        } else {
          appDocDirectory = await getExternalStorageDirectory();
        }

        customPath = appDocDirectory.path +
            customPath +
            DateTime.now().millisecondsSinceEpoch.toString();

        _recorder =
            FlutterAudioRecorder(customPath, audioFormat: AudioFormat.WAV);

        await _recorder.initialized;
        var current = await _recorder.current(channel: 0);

        if (!mounted) return;
        setState(() {
          _current = current;
          _currentStatus = current.status;
        });
      } else {
        Scaffold.of(context).showSnackBar(
            new SnackBar(content: new Text("You must accept permissions")));
      }
    } catch (e) {
      print(e);
    }
  }

  _start() async {
    bTest = false;
    print("Got into start method");
    starttimer();
    swatch.start();

    if (bCanStart = true) {
      bCanStart = false;

      try {
        await _recorder.start();
        var recording = await _recorder.current(channel: 0);
        if (!mounted) return;
        setState(() {
          _current = recording;
        });

        //Sets the tick to pick up and record sounds
        const tick = const Duration(milliseconds: 50);
        new Timer.periodic(tick, (Timer t) async {
          if (_currentStatus == RecordingStatus.Stopped) {
            t.cancel();
          }

          var current = await _recorder.current(channel: 0);
          if (!mounted) return;
          setState(() {
            int iCount = 1;
            _current = current;

            _currentStatus = _current.status;
            if ((pow(10, _current?.metering?.peakPower / 20) * 120.0) > 50) {
              print("Search");
              print("***********************" +
                  (pow(10, _current?.metering?.peakPower / 20) * 120.0)
                      .toString());
            }
            if ((pow(10, _current?.metering?.peakPower / 20) * 120.0) >
                timerSensitivity) {
              arrShots.add(stoptimetodisplay);
              arrMinutes.add(iMinutes);
              arrSeconds.add(iSeconds);
              arrMilliseconds.add(iMilliseconds);

              print("***********************Gun Shot Captured!!!!!!!!!!!!!!!!" +
                  (pow(10, _current?.metering?.peakPower / 20) * 120.0)
                      .toString());
              iCountShots++;
              print(pow(10, _current?.metering?.peakPower / 20) * 120.0);

              bCanStart = true;
              if (io.Platform.isIOS) {
                _pause();
                _resume();
              }

              return;
            }
          });
        });
      } catch (e) {
        print(e);
      }
    }
  }

  //resumes the recorder
  _resume() async {
    await _recorder.resume();
    if (!mounted) return;
    setState(() {});
  }

  _pause() async {
    _recorder.pause();
    if (!mounted) return;
    setState(() {});
  }

  //Stops the recorder
  _stopnow() async {
    print('stopping now*****');
    var result = await _recorder.stop();
    print("Stop recording: ${result.path}");
    print("Stop recording: ${result.duration}");
    if (!mounted) return;
    setState(() {
      _current = result;
      _currentStatus = _current.status;
    });
  }

  //Actual Widgets
  @override
  Widget build(BuildContext context) {
    var sliderValue = 0.0;

    return Scaffold(
        body: Column(
      children: [
        Container(
          padding: EdgeInsets.only(top: 35, bottom: 15, left: 0, right: 0),
        ),
        Container(
          margin: EdgeInsets.only(bottom: 20.0),
          child: AdmobBanner(
            nonPersonalizedAds: true,
            adUnitId: 'ca-app-pub-3940256099942544/2934735716',
            adSize: bannerSize,
            listener: (AdmobAdEvent event, Map<String, dynamic> args) {
              handleEvent(event, args, 'Banner');
            },
            onBannerCreated: (AdmobBannerController controller) {
              // Dispose is called automatically for you when Flutter removes the banner from the widget tree.
              // Normally you don't need to worry about disposing this yourself, it's handled.
              // If you need direct access to dispose, this is your guy!
              // controller.dispose();
            },
          ),
        ),
        Container(
            //padding: EdgeInsets.only(top: 10, bottom: 0, left: 0, right: 0),
            child: FlatButton(
              //color: btnColor,

              minWidth: 250,
              height: 250,
              shape: CircleBorder(side: BorderSide(color: btnColor, width: 4)),
              onPressed: () {
                obtainUserDefaults();
                if (bStopable == true) {
                  if (bResetOnStart == true) {
                    arrShots.clear();
                    arrShots.add("00:00:00");
                    iCountShots = 0;
                    swatch.reset();
                    //stoptimer();
                    //stopRecorder();
                    //stoptimer();
                    reset();
                    //startstopwatch();
                    didReset = true;
                  }
                  if (didReset == true) {
                    print("Got into pressed method");
                    if (startispressed == true) {
                      startstopwatch();
                      isChanged = !isChanged;
                      colorisChanged = !colorisChanged;
                      if (!mounted) return;
                      setState(() {
                        colorisChanged == true
                            ? btnColor = Color(0xFFA2C11C)
                            : btnColor = Color(0xFF2C5D63);
                        isChanged == true
                            ? buttonText = "Start"
                            : buttonText = "Stop";
                      });
                    }
                  }
                  // else
                  // {
                  //   Fluttertoast.showToast(
                  //       msg: "Please reset before starting another string",
                  //
                  //       toastLength: Toast.LENGTH_SHORT,
                  //       gravity: ToastGravity.BOTTOM,
                  //       timeInSecForIosWeb: 3,
                  //       backgroundColor: Colors.red,
                  //
                  //       textColor: Colors.black,
                  //       fontSize: 24.0
                  //   );
                  //   print("You need to reset");
                  // }

                }

                //startispressed ? startstopwatch: null;
              },
              child: Text(buttonText,
                  style: TextStyle(fontSize: 80, fontFamily: 'Digital-7')),
            )),
        Container(
            padding: EdgeInsets.only(top: 20, bottom: 0, left: 0, right: 0),
            child: Text(
              arrShots[arrShots.length - 1],
              style: TextStyle(
                  fontSize: 80,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Digital-7'),
            )),
        Container(
            padding: EdgeInsets.only(top: 10, bottom: 0, left: 0, right: 0),
            child: Text(
              (iCountShots).toString(),
              style: TextStyle(
                  fontSize: 80,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Digital-7'),
            )),
        Row(children: <Widget>[
          Spacer(),
          FlatButton(
              //color: Colors.blue,
              minWidth: 200,
              height: 50,
              color: Color(0xFF2C5D63),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                side: BorderSide(width: 2, color: Color(0xFF2C5D63)),
              ),
              child: Text("View String",
                  style: TextStyle(
                      fontSize: 25, color: Theme.of(context).buttonColor)),
              onPressed: () {
                if (arrShots.length <= 1) {
                  print("Should get into alert");
                  errorViewingStringDialog();
                } else
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Splits(arrShots.toString())));
              }),
          Spacer(),
        ]),
        //Text(sTestingEar),
      ],
    ));
  }

  //No strings shot dialog
  errorViewingStringDialog() {
    Dialog dialog = new Dialog(
        backgroundColor: Themes.darkBackgoundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
                    Text(
                      "You have not shot a string.",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10)),
                                color: Themes.darkButton2Color,
                              ),
                              height: 45,
                              child: Center(
                                child: Text("Shoot String",
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.white)),
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
                    backgroundColor: Themes.darkButton2Color,
                    radius: 40,
                    child: Image.asset(
                      "assets/Exclamation@3x.png",
                      height: 53,
                    ))),
          ],
        ));
    showDialog(context: context, builder: (context) => dialog);
  }
}

//Gets user defaults for saving strings etc
obtainUserDefaults() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  double dDelay = await prefs.getDouble('userDelay');
  bool bRandom = await prefs.getBool('randomDelay');
  double dSensitivity = await prefs.getDouble('userSensitivity');
  String sTone = await prefs.getString('userTone');

  if (dDelay == null) {
    await prefs.setDouble('userDelay', 3);
    dDelay = await prefs.getDouble('userDelay');
  }

  if (bRandom == null) {
    await prefs.setBool('randomDelay', false);
    bRandom = false;
  }

  if (dSensitivity == null) {
    await prefs.setDouble('userSensitivity', 50.0);
    dSensitivity = await prefs.getDouble('userSensitivity');
  }

  if (sTone == null) {
    print("*******************************NO TONE SET");
    await prefs.setString('userTone', "2100");
    sTone = await prefs.getString('userTone');
  }

  if (Platform.isIOS) {
    if (dSensitivity == 0.0) {
      timerSensitivity = 90;
    } else if (dSensitivity == 25.0) {
      timerSensitivity = 85;
    } else if (dSensitivity == 50.0) {
      timerSensitivity = 80;
    } else if (dSensitivity == 75.0) {
      timerSensitivity = 75;
    } else if (dSensitivity == 100.0) {
      timerSensitivity = 70.0;
    } else {
      print("No IOS User Defaults set");
    }
  }
  if (Platform.isAndroid) {
    if (dSensitivity == 0.0) {
      timerSensitivity = 75;
    } else if (dSensitivity == 25.0) {
      timerSensitivity = 70;
    } else if (dSensitivity == 50.0) {
      timerSensitivity = 65;
    } else if (dSensitivity == 75.0) {
      timerSensitivity = 60;
    } else if (dSensitivity == 100.0) {
      timerSensitivity = 55.0;
    } else {
      print("No ANDROID User Defaults set");
    }
  }
  double dTime;
  dTime = await double.parse(dDelay.toStringAsFixed(0));
  timerDelay = dDelay.round();
  timerTone = sTone;
  bRandomDelay = bRandom;
}



setCounter() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int getCounter = prefs.getInt('stopCounter');
  await prefs.setInt('stopCounter', getCounter+1);
}
