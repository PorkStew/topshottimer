import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart';
import 'package:topshottimer/Views/Scores/viewSplits.dart';

import '../../Themes.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  //Decleration of future variable values
  Future fUSerID;
  Future fDataRetrieved;
  int iLength;

  String sID;

  //Arrays of strings and shots
  List<String> arrStringID = [];
  List<String> arrStringName = [];
  List<String> arrTotalShots = [];
  List<String> arrTotalTime = [];
  List<String> arrDates = [];

  @override
  void initState() {
    super.initState();
    Purchases.getPurchaserInfo();
    fUSerID = _getID();
  }

  //Get user ID from user Defaults
  Future<String> userID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String sUserID = prefs.getString('id');
    return sUserID;
  }

  //Method to get all values from the database and populate various different arrays
  _getID() async {
    sID = await userID();
    var url = 'https://www.topshottimer.co.za/viewStrings.php';
    var res = await post(Uri.parse(url), headers: {
      "Accept": "application/jason"
    }, body: {
      //get this information from user defaults
      "userID": sID,
    });

    print("before res.body");

    List<dynamic> data = json.decode(res.body);
    iLength = data.length;
    print("Length of list: " + iLength.toString());
    var id = data;
    print(id);
    print(id[0]['userID']);


    //Populate all arrays
    for (int iPopulate = 0; iPopulate <= iLength - 1; iPopulate++) {
      arrStringID.add(id[iPopulate]['stringId']);
      arrStringName.add(id[iPopulate]['stringName']);
      arrTotalShots.add(id[iPopulate]['totalShots']);
      arrTotalTime.add(id[iPopulate]['totalTime']);
      arrDates.add(id[iPopulate]['stringDate']);
    }

    //Print the arrays with various strings
    for (int iPrint = 0; iPrint <= iLength - 1; iPrint++) {
      //print(arrStringName[iPrint]);
      print("String ID: " +
          arrStringID[iPrint] +
          ", String Name: " +
          arrStringName[iPrint] +
          ", Total Shots: " +
          arrTotalShots[iPrint].toString() +
          ", Total Time: " +
          arrTotalTime[iPrint]);
    }

    return userID();
  }

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
                if(iLength == 0){
                  print("*****No records found in the DB");
                }
                return Column(

                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 70, left: 15),
                        child: Column(
                          children: [
                            Text("No strings found." , style: TextStyle(fontSize: 17, color: Themes.darkButton2Color), ),
                          ],
                        ),
                      )

                    ],
                  );

              } else {

                print("Got into widget");
                retrieveData(sID);


                return Column(children: <Widget>[
                  Flexible(
                    child: new ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: arrStringID.length,
                      itemBuilder: (BuildContext context, int index) {

                        return InkWell(
                            onTap: () {
                              return Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => viewSplits(
                                          arrStringID[index].toString())));

                              //Go to the next screen with Navigator.push
                            },
                            child: Column(
                              children: <Widget>[
                                Card(
                                    child: Container(
                                  padding: new EdgeInsets.only(left: 10.0),
                                  child: Column(
                                    children: <Widget>[
                                      Row(children: <Widget>[
                                        Text(arrStringName[index],
                                            style: TextStyle(
                                                fontSize: 24,
                                                color: Color(0xFFA2C11C))),
                                      ]),
                                      Row(children: <Widget>[
                                        Text(
                                            "Total Time: " +
                                                arrTotalTime[index],
                                            style: TextStyle(fontSize: 17)),
                                        Spacer(),
                                      ]),
                                      Row(children: <Widget>[
                                        Text(
                                            "Total Shots: " +
                                                arrTotalShots[index],
                                            style: TextStyle(fontSize: 17)),
                                        Spacer(),
                                      ]),
                                      Row(children: <Widget>[
                                        Text("Date: " + arrDates[index],
                                            style: TextStyle(
                                                fontSize: 17,
                                                color:
                                                    Themes.darkButton2Color)),
                                        Spacer(),
                                      ]),
                                    ],
                                  ),
                                )),
                              ],
                            ));
                      },
                    ),
                  ),
                ]);
              }
              break;
            default:
              return Text("");
          }
        },
      ),
    ));
  }

  //Retrieve data method to retrieve data from the database
  Future retrieveData(String sID) async {
    var url = 'https://www.topshottimer.co.za/viewStrings.php';
    var res = await post(Uri.parse(url), headers: {
      "Accept": "application/jason"
    }, body: {
      //get this information from user defaults
      "userID": sID,
    });
    //print(json.decode(res.body));

    print("before res.body");

    List<dynamic> data = json.decode(res.body);
    int iLength = data.length;
    print("Length of list: " + iLength.toString());
    var id = data;
    print(id);
    print(id[0]['userID']);

    for (int iPopulate = 0; iPopulate <= iLength - 1; iPopulate++) {
      arrStringID.add(id[iPopulate]['stringId']);
      arrStringName.add(id[iPopulate]['stringName']);
      arrTotalShots.add(id[iPopulate]['totalShots']);
      arrTotalTime.add(id[iPopulate]['totalTime']);
      arrDates.add(id[iPopulate]['stringDate']);
    }

    //print(arrStringName[0].toString());
    for (int iPrint = 0; iPrint <= iLength - 1; iPrint++) {
      //print(arrStringName[iPrint]);
      print("String ID: " +
          arrStringID[iPrint] +
          ", String Name: " +
          arrStringName[iPrint] +
          ", Total Shots: " +
          arrTotalShots[iPrint].toString() +
          ", Total Time: " +
          arrTotalTime[iPrint] +
          ", Date: " +
          arrDates[iPrint]);
    }
  }
}
