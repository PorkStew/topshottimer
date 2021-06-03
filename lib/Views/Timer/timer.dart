import 'dart:async';
import 'dart:math';
import 'dart:io' as io;
import 'package:admob_flutter/admob_flutter.dart';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:topshottimer/Views/Subscription/pricing.dart';
import 'package:topshottimer/Views/Timer/splits.dart';
import 'dart:io' show Platform;
import 'package:path_provider/path_provider.dart';
import 'package:file/local.dart';
import '../../Themes.dart';
import '../../global.dart';
const String testDevice = '';
double timerSensitivity;

//User PCM Value
double userPCM = 0;
double PCMchange = 0.01;
double parTime = 0.00;

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

  final _controller = Get.put(Controller());

  bool paidMember = false;
  //Variable declerations for All flags and arrays
  FlutterAudioRecorder _recorder;
  Recording _current;
  RecordingStatus _currentStatus = RecordingStatus.Unset;
  bool bStarted = false;
  bool bCanStart = false;

  bool bTest = true;
  List<String> arrShots = [];
  List<int> arrMinutes = [];
  List<int> arrSeconds = [];
  List<int> arrMilliseconds = [];

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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(content),
        duration: Duration(milliseconds: 1500),
      ),
    );
  }

  void handleEvent(
      AdmobAdEvent event, Map<String, dynamic> args, String adType) {
    switch (event) {
    // case AdmobAdEvent.loaded:
    //   showSnackBar('New Admob $adType Ad loaded!');
    //   break;
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
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
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
    Purchases.getPurchaserInfo();
    paidMember = _controller.hasSubscription.value;
    print("PAID MEMBER STATUS INITSTATE = " + paidMember.toString());
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
        player.setAsset("assets/audios/" + timerTone + ".mp3");
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
        player.stop();

        if(parTime>0.0){
          double parTimeMilliseconds = parTime * 1000;
          int parTimeMillisecondsInt = parTimeMilliseconds.toInt();
          Timer(Duration(milliseconds: parTimeMillisecondsInt), () {
            //print("PAR TIME IN MILLISECONDS AFTER DELAY "+parTimeMillisecondsInt.toString());
            if (Platform.isIOS) {
              _setSession();
            }
            btnColor = Color(0xFFA2C11C);
            buttonText = "Start";

            // ? btnColor = Color(0xFFA2C11C)
            //     : btnColor = Color(0xFF2C5D63);
            // isChanged == true
            // ? buttonText = "Start"
            //     : buttonText = "Stop";
            player.play();
            isChanged = true;
            colorisChanged = true;
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


          });
          //Future.delayed(Duration(milliseconds: parTimeMillisecondsInt));
        }
      });

      //player.dispose();
      iCountStart++;
      bResetOnStart = false;
    } else if (bstop == true) {
      //Displays pricing page if user is not premium
      paidMember = _controller.hasSubscription.value;
      print("PAID MEMBER BEFORE IF STATEMENTS = " + paidMember.toString());

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
        ScaffoldMessenger.of(context).showSnackBar(
            new SnackBar(content: new Text("You must accept permissions")));
      }
    } catch (e) {
      print(e);
    }
  }

  _start() async {
    double dRecordedShot;
    int iShotTime = 100;
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
        const tick = const Duration(milliseconds: 100);
        new Timer.periodic(tick, (Timer t) async {
          if (_currentStatus == RecordingStatus.Stopped) {
            t.cancel();
            return;
          }

          var current = await _recorder.current(channel: 0);
          if (!mounted) return;
          setState(() {
            _current = current;

            _currentStatus = _current.status;

            if (_currentStatus == RecordingStatus.Stopped) {
              t.cancel();
              return;
            }
            //print("****User Par Time- "+ parTime.toString());
            double dLevel1 = _current.metering.peakPower;
            print("PEAK POWER ***: " + (_current.metering.peakPower.toString()));
            double PCM = _current.metering.peakPower;

            // print("ELAPSED TIME IN MS: "+ swatch.elapsed.inMilliseconds.toString());

            //if(1==1){

            // print("CURRENT PCM"+PCM.toString());
            // print("USER PCM"+userPCM.toString());
            if(dRecordedShot != dLevel1 && PCM > userPCM){

                  print("**********GOT INTO 1ST IF STATEMENT**********");
              //counter++;
              if((swatch.elapsed.inMilliseconds - iShotTime)>=80){
                print("Can record 2nd shot");
                iShotTime = swatch.elapsed.inMilliseconds;
                print("****Shot Time: "+iShotTime.toString());
                print("******* Shot Captured " + dLevel1.toString()); // + " @ Time: "+ (_current?.duration).toString());
                print("*****PCM Value: " + (_current.metering.peakPower).toString());
                dRecordedShot = dLevel1;
                //PCM = -2;
                //_recording.metering.peakPower = -50.0;
                dLevel1 = 0;
                print("PEAK POWER AFTER RESET: " + (_current.metering.peakPower.toString()));

                arrShots.add(stoptimetodisplay);
                arrMinutes.add(iMinutes);
                arrSeconds.add(iSeconds);
                arrMilliseconds.add(iMilliseconds);

                print("***********************Gun Shot Captured!!!!!!!!!!!!!!!!" +
                    (pow(10, _current.metering.peakPower / 20) * 120.0)
                        .toString());
                iCountShots++;
                //print(pow(10, _current.metering.peakPower / 20) * 120.0);

                bCanStart = true;

                // if (io.Platform.isIOS) {
                //   _pause();
                //   Future.delayed(const Duration(milliseconds: 5));
                //   _resume();
                // }

                //print("NUMBER OF SHOTS: " + counter.toString());
                if(Platform.isIOS){
                  _pause();
                  _resume();
                }
              }


              //_recorder.stop();
              //_recorder.start();
              //var current = await _recorder.current();
              //_opt();
              //_startRecording();
              //setState(() {
              //_recording = current;
              //});
            }


            // if ((pow(10, _current.metering.peakPower / 20) * 120.0) > 50) {
            //   print("Search");
            //
            //   print("***********************" +
            //       (pow(10, _current.metering.peakPower / 20) * 120.0)
            //           .toString());
            // }


            // if ((pow(10, _current.metering.peakPower / 20) * 120.0) >
            //     timerSensitivity) {
            //   arrShots.add(stoptimetodisplay);
            //   arrMinutes.add(iMinutes);
            //   arrSeconds.add(iSeconds);
            //   arrMilliseconds.add(iMilliseconds);
            //
            //   print("***********************Gun Shot Captured!!!!!!!!!!!!!!!!" +
            //       (pow(10, _current.metering.peakPower / 20) * 120.0)
            //           .toString());
            //   iCountShots++;
            //   //print(pow(10, _current.metering.peakPower / 20) * 120.0);
            //
            //   bCanStart = true;
            //   if (io.Platform.isIOS) {
            //     _pause();
            //     Future.delayed(const Duration(milliseconds: 5));
            //     _resume();
            //   }
            //
            //   return;
            // }
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
            // TextButton(
            //   child: Text(buttonText,
            //       style: TextStyle(fontSize: 80, fontFamily: 'Digital-7')),
            //   onPressed: () {
            //     obtainUserDefaults();
            //     if (bStopable == true) {
            //       if (bResetOnStart == true) {
            //         arrShots.clear();
            //         arrShots.add("00:00:00");
            //         iCountShots = 0;
            //         swatch.reset();
            //         //stoptimer();
            //         //stopRecorder();
            //         //stoptimer();
            //         reset();
            //         //startstopwatch();
            //         didReset = true;
            //       }
            //       if (didReset == true) {
            //         print("Got into pressed method");
            //         if (startispressed == true) {
            //           startstopwatch();
            //           isChanged = !isChanged;
            //           colorisChanged = !colorisChanged;
            //           if (!mounted) return;
            //           setState(() {
            //             colorisChanged == true
            //                 ? btnColor = Color(0xFFA2C11C)
            //                 : btnColor = Color(0xFF2C5D63);
            //             isChanged == true
            //                 ? buttonText = "Start"
            //                 : buttonText = "Stop";
            //           });
            //         }
            //       }
            //       // else
            //       // {
            //       //   Fluttertoast.showToast(
            //       //       msg: "Please reset before starting another string",
            //       //
            //       //       toastLength: Toast.LENGTH_SHORT,
            //       //       gravity: ToastGravity.BOTTOM,
            //       //       timeInSecForIosWeb: 3,
            //       //       backgroundColor: Colors.red,
            //       //
            //       //       textColor: Colors.black,
            //       //       fontSize: 24.0
            //       //   );
            //       //   print("You need to reset");
            //       // }
            //
            //     }
            //
            //     //startispressed ? startstopwatch: null;
            //   },
            //   style: TextButton.styleFrom(
            //     minimumSize: Size(250,250),
            //     shape: CircleBorder(side: BorderSide(color: btnColor, width: 4)),),
            //
            //   ),
            //

            // SizedBox(
            //     width: 250,
            //     height: 250,
            //     child: ElevatedButton(
            //       child: Text(
            //         buttonText,
            //         style: TextStyle(fontSize: 80, fontFamily: 'Digital-7')
            //
            //       ),
            //       onPressed: () {
            //         obtainUserDefaults();
            //         if (bStopable == true) {
            //           if (bResetOnStart == true) {
            //             arrShots.clear();
            //             arrShots.add("00:00:00");
            //             iCountShots = 0;
            //             swatch.reset();
            //             //stoptimer();
            //             //stopRecorder();
            //             //stoptimer();
            //             reset();
            //             //startstopwatch();
            //             didReset = true;
            //           }
            //           if (didReset == true) {
            //             print("Got into pressed method");
            //             if (startispressed == true) {
            //               startstopwatch();
            //               isChanged = !isChanged;
            //               colorisChanged = !colorisChanged;
            //               if (!mounted) return;
            //               setState(() {
            //                 colorisChanged == true
            //                     ? btnColor = Color(0xFFA2C11C)
            //                     : btnColor = Color(0xFF2C5D63);
            //                 isChanged == true
            //                     ? buttonText = "Start"
            //                     : buttonText = "Stop";
            //               });
            //             }
            //           }
            //           // else
            //           // {
            //           //   Fluttertoast.showToast(
            //           //       msg: "Please reset before starting another string",
            //           //
            //           //       toastLength: Toast.LENGTH_SHORT,
            //           //       gravity: ToastGravity.BOTTOM,
            //           //       timeInSecForIosWeb: 3,
            //           //       backgroundColor: Colors.red,
            //           //
            //           //       textColor: Colors.black,
            //           //       fontSize: 24.0
            //           //   );
            //           //   print("You need to reset");
            //           // }
            //
            //         }
            //
            //         //startispressed ? startstopwatch: null;
            //       },
            //       style: ElevatedButton.styleFrom(
            //           //primary: Colors.black.with,
            //           shape: CircleBorder(side: BorderSide(color: btnColor, width: 4)),),
            //     )),
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
            SizedBox(height: 20,),
            Container(
                padding: EdgeInsets.only(top: 10, bottom: 0, left: 0, right: 0),
                child: Text(
                  (iCountShots).toString(),
                  style: TextStyle(
                      fontSize: 80,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Digital-7'),
                )),
            SizedBox(height: 20,),
            Row(children: <Widget>[
              Spacer(),

              SizedBox(
                  width: 200,
                  height: 50,
                  child: ElevatedButton(
                    child: Text(
                      'View String',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                        fontFamily: 'Montserrat-Regular',
                        letterSpacing: 0.2,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      if (arrShots.length <= 1) {
                        print("Should get into alert");
                        errorViewingStringDialog();
                      } else {
                        if(bstop == true){
                          print("Cant view strings as it is still running");
                        }else
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    Splits(arrShots.toString())));
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        primary: Color(0xFF2C5D63),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                  )),
              // FlatButton(
              //     //color: Colors.blue,
              //     minWidth: 200,
              //     height: 50,
              //     color: Color(0xFF2C5D63),
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(10.0),
              //       side: BorderSide(width: 2, color: Color(0xFF2C5D63)),
              //     ),
              //     child: Text("View String",
              //         style: TextStyle(
              //             fontSize: 25, color: Theme.of(context).buttonColor)),
              //     onPressed: () {
              //       if (arrShots.length <= 1) {
              //         print("Should get into alert");
              //         errorViewingStringDialog();
              //       } else
              //         Navigator.push(
              //             context,
              //             MaterialPageRoute(
              //                 builder: (context) => Splits(arrShots.toString())));
              //     }),
              Spacer(),
            ]),
            //Text(sTestingEar),
          ],
        ));
  }

  //No strings shot dialog
  errorViewingStringDialog() {
    Dialog dialog = new Dialog(
        backgroundColor: Themes.darkBackgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Stack(
          clipBehavior: Clip.none,
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
  double dDelay = prefs.getDouble('userDelay');
  bool bRandom = prefs.getBool('randomDelay');
  int iSensitivity = prefs.getInt('userSensitivity');
  String sTone = prefs.getString('userTone');
  double dParTime = prefs.getDouble('parTime');

  print("DEFAULT PAR TIME ON OBTAIN USER DEFAULTS: "+ dParTime.toString());


  if (dParTime == null){
    await prefs.setDouble('parTime', 0.0);
    dParTime = prefs.getDouble('parTime');
    parTime = dParTime;
  }
  if (dDelay == null) {
    await prefs.setDouble('userDelay', 3);
    dDelay = prefs.getDouble('userDelay');
  }

  if (bRandom == null) {
    await prefs.setBool('randomDelay', false);
    bRandom = false;
  }

  if (iSensitivity == null) {
    await prefs.setInt('userSensitivity', 30);
    iSensitivity = prefs.getInt('userSensitivity');
  }

  if (sTone == null) {
    print("*******************************NO TONE SET");
    await prefs.setString('userTone', "2100");
    sTone = prefs.getString('userTone');
  }

    if(Platform.isIOS) {
      switch (iSensitivity) {
        case 100:
          userPCM = -0.50;
          break;
        case 99:
          userPCM = -0.56;
          break;
        case 98:
          userPCM = -0.62;
          break;
        case 97:
          userPCM = -0.68;
          break;
        case 96:
          userPCM = -0.74;
          break;
        case 95:
          userPCM = -0.80;
          break;
        case 94:
          userPCM = -0.86;
          break;
        case 93:
          userPCM = -0.92;
          break;
        case 92:
          userPCM = -0.98;
          break;
        case 91:
          userPCM = -1.04;
          break;
        case 90:
          userPCM = -1.10;
          break;
        case 89:
          userPCM = -1.16;
          break;
        case 88:
          userPCM = -1.22;
          break;
        case 87:
          userPCM = -1.28;
          break;
        case 86:
          userPCM = -1.34;
          break;
        case 85:
          userPCM = -1.4;
          break;
        case 84:
          userPCM = -1.46;
          break;
        case 83:
          userPCM = -1.52;
          break;
        case 82:
          userPCM = -1.58;
          break;
        case 81:
          userPCM = -1.64;
          break;
        case 80:
          userPCM = -1.70;
          break;
        case 79:
          userPCM = -1.76;
          break;
        case 78:
          userPCM = -1.82;
          break;
        case 77:
          userPCM = -1.88;
          break;
        case 76:
          userPCM = -1.94;
          break;
        case 75:
          userPCM = -2.0;
          break;
        case 74:
          userPCM = -2.06;
          break;
        case 73:
          userPCM = -2.12;
          break;
        case 72:
          userPCM = -2.18;
          break;
        case 71:
          userPCM = -2.24;
          break;
        case 70:
          userPCM = -2.30;
          break;
        case 69:
          userPCM = -2.36;
          break;
        case 68:
          userPCM = -2.42;
          break;
        case 67:
          userPCM = -2.48;
          break;
        case 66:
          userPCM = -2.54;
          break;
        case 65:
          userPCM = -2.60;
          break;
        case 64:
          userPCM = -2.66;
          break;
        case 63:
          userPCM = -2.72;
          break;
        case 62:
          userPCM = -2.78;
          break;
        case 61:
          userPCM = -2.84;
          break;
        case 60:
          userPCM = -2.90;
          break;
        case 59:
          userPCM = -2.96;
          break;
        case 58:
          userPCM = -3.02;
          break;
        case 57:
          userPCM = -3.08;
          break;
        case 56:
          userPCM = -3.14;
          break;
        case 55:
          userPCM = -3.20;
          break;
        case 54:
          userPCM = -3.26;
          break;
        case 53:
          userPCM = -3.32;
          break;
        case 52:
          userPCM = -3.38;
          break;
        case 51:
          userPCM = -3.44;
          break;
        case 50:
          userPCM = -3.50;
          break;
        case 49:
          userPCM = -3.56;
          break;
        case 48:
          userPCM = -3.62;
          break;
        case 47:
          userPCM = -3.68;
          break;
        case 46:
          userPCM = -3.74;
          break;
        case 45:
          userPCM = -3.80;
          break;
        case 44:
          userPCM = -3.86;
          break;
        case 43:
          userPCM = -3.92;
          break;
        case 42:
          userPCM = -3.98;
          break;
        case 41:
          userPCM = -4.04;
          break;
        case 40:
          userPCM = -4.10;
          break;
        case 39:
          userPCM = -4.16;
          break;
        case 38:
          userPCM = -4.22;
          break;
        case 37:
          userPCM = -4.28;
          break;
        case 36:
          userPCM = -4.34;
          break;
        case 35:
          userPCM = -4.40;
          break;
        case 34:
          userPCM = -4.46;
          break;
        case 33:
          userPCM = -4.52;
          break;
        case 32:
          userPCM = -4.58;
          break;
        case 31:
          userPCM = -4.64;
          break;
        case 30:
          userPCM = -4.70;
          break;
        case 29:
          userPCM = -4.76;
          break;
        case 28:
          userPCM = -4.82;
          break;
        case 27:
          userPCM = -4.88;
          break;
        case 26:
          userPCM = -4.94;
          break;
        case 25:
          userPCM = -5.00;
          break;
        case 24:
          userPCM = -5.06;
          break;
        case 23:
          userPCM = -5.12;
          break;
        case 22:
          userPCM = -5.18;
          break;
        case 21:
          userPCM = -5.24;
          break;
        case 20:
          userPCM = -5.30;
          break;
        case 19:
          userPCM = -5.36;
          break;
        case 18:
          userPCM = -5.42;
          break;
        case 17:
          userPCM = -5.48;
          break;
        case 16:
          userPCM = -5.54;
          break;
        case 15:
          userPCM = -5.6;
          break;
        case 14:
          userPCM = -5.66;
          break;
        case 13:
          userPCM = -5.72;
          break;
        case 12:
          userPCM = -5.78;
          break;
        case 11:
          userPCM = -5.84;
          break;
        case 10:
          userPCM = -5.90;
          break;
        case 9:
          userPCM = -5.96;
          break;
        case 8:
          userPCM = -6.02;
          break;
        case 7:
          userPCM = -6.08;
          break;
        case 6:
          userPCM = -6.14;
          break;
        case 5:
          userPCM = -6.2;
          break;
        case 4:
          userPCM = -6.26;
          break;
        case 3:
          userPCM = -6.32;
          break;
        case 2:
          userPCM = -6.4;
          break;
        case 1:
          userPCM = -6.46;
          break;
        case 0:
          userPCM = -6.52;
          break;
      //-4.5 is nearly perfect but needs to start at -6.5
      }
    }

  if (Platform.isAndroid) {
    switch (iSensitivity) {
      case 100:
        userPCM = -0.4;
        break;
      case 99:
        userPCM = -0.5;
        break;
      case 98:
        userPCM = -0.6;
        break;
      case 97:
        userPCM = -0.7;
        break;
      case 96:
        userPCM = -0.8;
        break;
      case 95:
        userPCM = -1.0;
        break;
      case 94:
        userPCM = -1.2;
        break;
      case 93:
        userPCM = -1.4;
        break;
      case 92:
        userPCM = -1.6;
        break;
      case 91:
        userPCM = -1.8;
        break;
      case 90:
        userPCM = -2.0;
        break;
      case 89:
        userPCM = -2.2;
        break;
      case 88:
        userPCM = -2.4;
        break;
      case 87:
        userPCM = -2.6;
        break;
      case 86:
        userPCM = -2.8;
        break;
      case 85:
        userPCM = -3.0;
        break;
      case 84:
        userPCM = -3.2;
        break;
      case 83:
        userPCM = -3.4;
        break;
      case 82:
        userPCM = -3.6;
        break;
      case 81:
        userPCM = -3.8;
        break;
      case 80:
        userPCM = -4.0;
        break;
      case 79:
        userPCM = -4.2;
        break;
      case 78:
        userPCM = -4.4;
        break;
      case 77:
        userPCM = -4.6;
        break;
      case 76:
        userPCM = -4.8;
        break;
      case 75:
        userPCM = -5.0;
        break;
      case 74:
        userPCM = -5.2;
        break;
      case 73:
        userPCM = -5.4;
        break;
      case 72:
        userPCM = -5.6;
        break;
      case 71:
        userPCM = -5.8;
        break;
      case 70:
        userPCM = -6.0;
        break;
      case 69:
        userPCM = -6.2;
        break;
      case 68:
        userPCM = -6.4;
        break;
      case 67:
        userPCM = -6.6;
        break;
      case 66:
        userPCM = -6.8;
        break;
      case 65:
        userPCM = -7.0;
        break;
      case 64:
        userPCM = -7.2;
        break;
      case 63:
        userPCM = -7.4;
        break;
      case 62:
        userPCM = -7.6;
        break;
      case 61:
        userPCM = -7.8;
        break;
      case 60:
        userPCM = -8;
        break;
      case 59:
        userPCM = -8.2;
        break;
      case 58:
        userPCM = -8.4;
        break;
      case 57:
        userPCM = -8.6;
        break;
      case 56:
        userPCM = -8.8;
        break;
      case 55:
        userPCM = -9.0;
        break;
      case 54:
        userPCM = -9.2;
        break;
      case 53:
        userPCM = -9.4;
        break;
      case 52:
        userPCM = -9.6;
        break;
      case 51:
        userPCM = -9.8;
        break;
      case 50:
        userPCM = -10.0;
        break;
      case 49:
        userPCM = -10.2;
        break;
      case 48:
        userPCM = -10.4;
        break;
      case 47:
        userPCM = -10.6;
        break;
      case 46:
        userPCM = -10.8;
        break;
      case 45:
        userPCM = -11.0;
        break;
      case 44:
        userPCM = -11.2;
        break;
      case 43:
        userPCM = -11.4;
        break;
      case 42:
        userPCM = -11.6;
        break;
      case 41:
        userPCM = -11.8;
        break;
      case 40:
        userPCM = -12.0;
        break;
      case 39:
        userPCM = -12.2;
        break;
      case 38:
        userPCM = -12.4;
        break;
      case 37:
        userPCM = -12.6;
        break;
      case 36:
        userPCM = -12.8;
        break;
      case 35:
        userPCM = -13.0;
        break;
      case 34:
        userPCM = -13.2;
        break;
      case 33:
        userPCM = -13.4;
        break;
      case 32:
        userPCM = -13.6;
        break;
      case 31:
        userPCM = -13.8;
        break;
      case 30:
        userPCM = -14.0;
        break;
      case 29:
        userPCM = -14.2;
        break;
      case 28:
        userPCM = -14.4;
        break;
      case 27:
        userPCM = -14.6;
        break;
      case 26:
        userPCM = -14.8;
        break;
      case 25:
        userPCM = -15.0;
        break;
      case 24:
        userPCM = -15.2;
        break;
      case 23:
        userPCM = -15.4;
        break;
      case 22:
        userPCM = -15.6;
        break;
      case 21:
        userPCM = -15.8;
        break;
      case 20:
        userPCM = -16;
        break;
      case 19:
        userPCM = -16.2;
        break;
      case 18:
        userPCM = -16.4;
        break;
      case 17:
        userPCM = -16.6;
        break;
      case 16:
        userPCM = -16.8;
        break;
      case 15:
        userPCM = -17;
        break;
      case 14:
        userPCM = -17.2;
        break;
      case 13:
        userPCM = -17.4;
        break;
      case 12:
        userPCM = -17.6;
        break;
      case 11:
        userPCM = -17.8;
        break;
      case 10:
        userPCM = -18.0;
        break;
      case 9:
        userPCM = -18.2;
        break;
      case 8:
        userPCM = -18.4;
        break;
      case 7:
        userPCM = -18.6;
        break;
      case 6:
        userPCM = -18.8;
        break;
      case 5:
        userPCM = -19;
        break;
      case 4:
        userPCM = -19.2;
        break;
      case 3:
        userPCM = -19.4;
        break;
      case 2:
        userPCM = -19.6;
        break;
      case 1:
        userPCM = -19.8;
        break;
      case 0:
        userPCM = -20;
        break;
    //-4.5 is nearly perfect but needs to start at -6.5
    }
  }
  double dTime;
  dTime =  double.parse(dDelay.toStringAsFixed(0));
  timerDelay = dDelay.round();
  timerTone = sTone;
  bRandomDelay = bRandom;
  parTime = dParTime;
}



setCounter() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int getCounter = prefs.getInt('stopCounter');
  await prefs.setInt('stopCounter', getCounter+1);
}