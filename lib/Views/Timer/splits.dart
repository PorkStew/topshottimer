
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../Themes.dart';
import '../PageSelector.dart';

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

                                          if (arrShots.length>1)
                                          {
                                            arrShots.remove(sShot);
                                          }
                                          else
                                            Navigator.pop(context);


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
              //Text("Date: "),

              Container(
                padding: EdgeInsets.only(top: 10,bottom: 0,left: 0, right: 0),

              ),
              Row(
                children: [
                  Spacer(),
                  FlatButton(
                    color: Color(0xFF2C5D63),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0), side: BorderSide(color: Color(0xFF2C5D63))),
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
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0), side: BorderSide(color: Color(0xFFA2C11C))),
                    height: 50,
                    minWidth: 35,
                    child: Text("Save String",style: TextStyle(fontSize: 20, color: Theme.of(context).buttonColor),),
                    onPressed: () {
                      stringNameDialog();

                    },


                  ),
                  Spacer(),
                ],

              ),
              Container(
                padding: EdgeInsets.only(top: 20,bottom: 0,left: 0, right: 0),
                //child: Text('TopShot Timer', style: TextStyle(fontSize: 40, fontWeight: FontWeight.w600, ))

              ),

            ]
        ),




      ),
    );
    //

  }
  stringNameDialog(){
    final _StringName = TextEditingController();
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    Dialog dialog = new Dialog(
        shape: RoundedRectangleBorder(

            borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          overflow: Overflow.visible,
          alignment: Alignment.topCenter,
          children: [

        ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Container(
          color: Themes.darkBackgoundColor,
          //this will affect the height of the dialog
          height: 215,
          child: Padding(
            //play with top padding to make items fit
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text("What should we call this string?", style: TextStyle(color: Colors.white, fontSize: 20), textAlign: TextAlign.center,),

                Padding(padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                  child: Form(
                    key: _formKey,
                    child: TextFormField(
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(

                        //labelText: 'Email',
                          labelText: 'String Name'
                      ),
                      controller: _StringName,
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'String Name is required';
                        }
                        return null;
                      },
                      onSaved: (String value) {
                        _StringName.text = value;
                      },

                    ),
                  ),
                ),
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
                            BorderRadius.only(bottomLeft: Radius.circular(10)),
                            color: Themes.darkButton1Color,
                          ),
                          height: 45,
                          child: Center(
                            child: Text("Cancel",
                                style: TextStyle(fontSize: 20, color: Colors.white)),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: (){
                          if (!_formKey.currentState.validate()) {
                            return;
                          }
                          _formKey.currentState.save();
                          print("here is my input from the dialog");
                          print(_StringName.text);
                          sendData(_StringName.text, 10, 10.2);
                          Navigator.pushReplacementNamed(context, '/PageSelector');

                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius:
                            BorderRadius.only(bottomRight: Radius.circular(10)),
                            color: Themes.darkButton2Color,
                          ),
                          height: 45,
                          child: Center(
                            child: Text("Save",
                                style: TextStyle(fontSize: 20, color: Colors.white)),
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
        ),


            Positioned(
                top: -40,
                child: CircleAvatar(
                    backgroundColor: Themes.darkButton2Color,
                    radius: 40,
                    child: Icon(Icons.add, color: Themes.darkBackgoundColor, size: 50, ),
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
  String userIdDefault = await prefs.get('id');

  userGetID = userIdDefault;
}


