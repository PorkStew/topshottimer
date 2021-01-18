import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'PageSelector.dart';

String userGetID;



class Splits extends StatefulWidget {
  String sTest;
  Splits(this.sTest);

  @override
  State<StatefulWidget> createState(){
    return SplitsState(this.sTest,);
  }
}


class SplitsState extends State<Splits> {

  String sEnteredName;
  String sHelloWorld;
  SplitsState(this.sHelloWorld);
  List<String> strings;
  List<String> arrShots = List<String>();
  final sUserInput = TextEditingController();
  @override
  void initState() {
    obtainUserDefaults();
    // TODO: implement initState
    //var a = '["one", "two", "three", "four"]';
    sHelloWorld.replaceAll(' ', '');
    print(sHelloWorld);
    final removedBrackets = sHelloWorld.substring(1, sHelloWorld.length -1);
    strings = removedBrackets.split(",");
    String sToTruncate;

    for (var i = 0; i <= strings.length-1; i++) {

      sToTruncate = strings[i].trim();
      if (sToTruncate.length > 8){
        sToTruncate = sToTruncate.substring(0,8);
      }
      else sToTruncate = sToTruncate;
      arrShots.add(sToTruncate);
      print(arrShots[i]);
    }
    arrShots.removeAt(0);
    super.initState();


  }

  sendData(String stringName, int totalShots, double totalTime) async {


    //print(userID);
    print(stringName);
    print(totalShots);
    print(totalTime);
    String sArray = arrShots.join(',');
    String sTotalTime = arrShots[arrShots.length - 1].toString();
    print("Total Time Test: " + sTotalTime);
    print("Comma seperated string " + sArray);
    print("Before Try");
    try{
      var url = 'https://www.topshottimer.co.za/insertTimes.php';
      var res = await http.post(
          Uri.encodeFull(url), headers: {"Accept": "application/jason"},
          body: {
            "stringName": stringName,
            "userID": userGetID.toString(),
            "totalShots": arrShots.length.toString(),
            "totalTime": sTotalTime,
             "arrShots": sArray,
          }
      );
      //print("account created");
    }catch (error) {
      print(error.toString());
    }
    print("After Try");
  }

  @override
  Widget build(BuildContext context) {



    return Scaffold(
      //backgroundColor: Colors.white,
      body: Container(

        child: Column(
            children: <Widget> [
              Flexible(
                child:
                new ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: arrShots.length,
                  itemBuilder: (BuildContext context, int index){
                    String sShot = arrShots[index];
                    return Container(
                        child:Column(
                          children: <Widget>[
                            Card(
                              child: Row(
                                //mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                children: <Widget>[
                                  Text((index+1).toString(),style: TextStyle(fontSize: 30),),
                                  Spacer(),
                                  Text(sShot,style: TextStyle(fontSize: 30)),
                                  Spacer(),
                                  FlatButton(
                                    //color: Colors.red,
                                    height: 35,
                                    minWidth: 35,
                                    shape: CircleBorder(side: BorderSide(color: Color(0xFFDE561C), width: 2)),
                                    child: Text("X",style: TextStyle(fontSize: 20, color: Color(0xFFDE561C)),),
                                    onPressed: () {
                                      setState(() {
                                        arrShots.remove(sShot);
                                        print(arrShots);
                                        print("Hello World");
                                      });

                                    },
                                  ),
                                ],
                              ),
                            ),

                          ],
                        )



                    );
                  },
                ),
              ),

              Text("Total Time: "+arrShots[arrShots.length - 1],style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold,),),
              Text("Total Shots: "+(arrShots.length).toString(),style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold,),),

              Container(
                padding: EdgeInsets.only(top: 20,bottom: 15,left: 0, right: 0),
                //child: Text('TopShot Timer', style: TextStyle(fontSize: 40, fontWeight: FontWeight.w600, ))

              ),
              Row(
                children: [
                  Spacer(),
                  FlatButton(
                    color: Color(0xFF2C5D63),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0), side: BorderSide(color: Color(0xFF2C5D63))),
                    height: 50,
                    minWidth: 35,
                    child: Text("Close String",style: TextStyle(fontSize: 20, color: Theme.of(context).buttonColor),),
                    onPressed: () {
                      Navigator.pop(context);
                    },


                  ),
                  Spacer(),
                  FlatButton(
                    color: Color(0xFFA2C11C),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0), side: BorderSide(color: Color(0xFFA2C11C))),
                    height: 50,
                    minWidth: 35,
                    child: Text("Save String",style: TextStyle(fontSize: 20, color: Theme.of(context).buttonColor),),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context){
                            return AlertDialog(
                              title: Text("Please enter a name for this string below:"),
                              content: TextField(
                                controller: sUserInput,
                                decoration: InputDecoration(labelText: 'String Name',),

                              ),
                              actions:[


                                FlatButton(child: Text("Cancel"),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },),
                                FlatButton(child: Text("Save"),
                                  onPressed: () {
                                  print("******************" + sUserInput.text);
                                  sendData(sUserInput.text, 10, 10.2);

                                    Navigator.push(context, MaterialPageRoute(builder: (context) => pageSelector()));
                                  },),
                              ],
                            );
                          }
                      );
                    },


                  ),
                  Spacer(),
                ],

              ),

            ]
        ),




      ),
    );
    //

  }
}
obtainUserDefaults() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String userIdDefault = await prefs.get('id');

  userGetID = userIdDefault;
}


