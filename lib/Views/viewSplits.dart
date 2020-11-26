import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'PageSelector.dart';

String userGetID;

class viewSplits extends StatefulWidget {
  String sStringIDRecieved;
  viewSplits(this.sStringIDRecieved);

  @override
  State<StatefulWidget> createState(){
    return viewSplitsState(this.sStringIDRecieved,);
  }
}


class viewSplitsState extends State<viewSplits> {
  List<String> arrSplits = List<String>();
  String sID;
  Future fUSerID;
  bool bVerfied;

  String sStringID;

  viewSplitsState(this.sStringID);

  @override
  void initState() {
    super.initState();
    fUSerID = _getID();
  }


  _getID() async {
    sID = await userID();
    var url = 'https://www.topshottimer.co.za/viewSplits.php';
    var res = await http.post(
        Uri.encodeFull(url), headers: {"Accept": "application/jason"},
        body: {
          //get this information from user defaults
          "stringId": sStringID,
        }
    );
    //print(json.decode(res.body));


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

  Future<String> userID() async {
    while (bVerfied){

    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //await prefs.setDouble('userSensitivity', 50.00);
    String sUserID = await prefs.getString('id');

    //print(dSensitivity.toString());
    return sUserID;
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
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.red),
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
                    return Column(
                        children: <Widget>[
                          Flexible(
                            child:
                            new ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: arrSplits.length,

                              itemBuilder: (BuildContext context, int index) {
                                return Container(

                                    child: Column(
                                      children: <Widget>[
                                        Card(
                                          child: Row(
                                            //mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                            children: <Widget>[


                                              Text((index + 1).toString(),
                                                style: TextStyle(fontSize: 30,
                                                    color: Colors.black),),
                                              Spacer(),
                                              Text(arrSplits[index],
                                                  style: TextStyle(fontSize: 30,
                                                      color: Colors.black),
                                                  textAlign: TextAlign.right),
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
        ));
    //

  }

}


