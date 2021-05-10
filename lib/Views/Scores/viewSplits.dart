import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Themes.dart';
import '../PageSelector.dart';

String userGetID;

class viewSplits extends StatefulWidget {
  String sStringIDRecieved;

  viewSplits(this.sStringIDRecieved);

  @override
  State<StatefulWidget> createState() {
    return viewSplitsState(
      this.sStringIDRecieved,
    );
  }
}

class viewSplitsState extends State<viewSplits> {
  //Variable decleration
  List<String> arrSplits = List<String>();
  String sID;
  Future fUSerID;
  String sStringID;

  viewSplitsState(this.sStringID);

  @override
  void initState() {
    super.initState();
    fUSerID = _getID();
  }

  //Getting row from database with the string id
  _getID() async {
    sID = await userID();
    var url = 'https://www.topshottimer.co.za/viewSplits.php';
    var res = await post(Uri.parse(url), headers: {
      "Accept": "application/jason"
    }, body: {
      //get this information from user defaults
      "stringId": sStringID,
    });
    //print(json.decode(res.body));

    //Populating splits array with all shots from database
    print("before res.body");
    List<dynamic> data = json.decode(res.body);
    int iLength = data.length;
    print("Length of list: " + iLength.toString());
    var id = data;
    // print(id);
    print(id[0]['stringSplits']);

    for (int iPopulate = 0; iPopulate <= iLength - 1; iPopulate++) {
      arrSplits.add(id[iPopulate]['stringSplits']);
    }

    //print(arrStringName[0].toString());
    for (int iPrint = 0; iPrint <= iLength - 1; iPrint++) {
      //print(arrStringName[iPrint]);
      print("Split: " + arrSplits[iPrint]);
    }

    return userID();
  }

  //Get string ID when they select the string in the scores page
  Future<String> userID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //await prefs.setDouble('userSensitivity', 50.00);
    String sUserID = await prefs.getString('id');

    //print(dSensitivity.toString());
    return sUserID;
  }

  //Future builder to wait for variables to be populated
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: FutureBuilder(
        future: fUSerID,
        builder: (context, snapshot) {
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
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Color(0xFFA2C11C)),
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
                //retrieveData(sID);
                return Column(children: <Widget>[
                  Flexible(
                    child: new ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: arrSplits.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                            child: Column(
                          children: <Widget>[
                            Card(
                              child: Container(
                                  padding: new EdgeInsets.only(left: 10.0),
                                  child: Column(
                                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                    children: <Widget>[
                                      Row(children: <Widget>[
                                        Text(
                                          "Shot: " + (index + 1).toString(),
                                          style: TextStyle(
                                              fontSize: 24,
                                              color: Color(0xFFA2C11C)),
                                        ),
                                      ]),
                                      Row(children: <Widget>[
                                        Text("Shot Time: " + arrSplits[index],
                                            style: TextStyle(
                                              fontSize: 20,
                                            ),
                                            textAlign: TextAlign.right),
                                      ])
                                    ],
                                  )),
                            ),
                          ],
                        ));
                      },
                    ),
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Spacer(),
                      FlatButton(
                        color: Color(0xFF2C5D63),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: BorderSide(color: Color(0xFF2C5D63))),
                        height: 50,
                        minWidth: 35,
                        child: Text(
                          "Close String",
                          style: TextStyle(
                              fontSize: 20,
                              color: Theme.of(context).buttonColor),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      Spacer(),
                      FlatButton(
                        color: Color(0xFFA2C11C),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: BorderSide(color: Color(0xFFA2C11C))),
                        height: 50,
                        minWidth: 35,
                        child: Text(
                          "Delete String",
                          style: TextStyle(
                              fontSize: 20,
                              color: Theme.of(context).buttonColor),
                        ),
                        onPressed: () {
                          deleteStringConfirmationDialog();
                        },
                      ),
                      Spacer(),
                    ],
                  ),
                  Container(
                    padding:
                        EdgeInsets.only(top: 20, bottom: 0, left: 0, right: 0),
                    //child: Text('TopShot Timer', style: TextStyle(fontSize: 40, fontWeight: FontWeight.w600, ))
                  ),
                ]);
              }
          }
        },
      ),
    ));
    //
  }

  //Delete statement if the user chooses to delete a specific string
  deleteStringSplits() async {
    var url = 'https://www.topshottimer.co.za/deleteStringSplits.php';
    var res = await post(Uri.parse(url), headers: {
      "Accept": "application/jason"
    }, body: {
      //get this information from user defaults
      "stringId": sStringID,
    });
  }

  //Delete string confirmation dialog to confirm deleting a string
  deleteStringConfirmationDialog() {
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
                      "Are you sure about this?",
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
                                    bottomLeft: Radius.circular(10)),
                                color: Themes.darkButton1Color,
                              ),
                              height: 45,
                              child: Center(
                                child: Text("Cancel",
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.white)),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              print("Delete Clicked");
                              deleteStringConfirmationDialog();
                              deleteStringSplits();
                              Navigator.pushReplacementNamed(
                                  context, '/PageSelector');
                              // Navigator.pop(context);
                              //Navigator.push(context,
                              // MaterialPageRoute(builder: (context) => SignUp(_email.text)));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(10)),
                                //color: Themes.PrimaryColorRed,
                                color: Themes.darkButton2Color,
                              ),
                              height: 45,
                              child: Center(
                                child: Text("Delete String",
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
