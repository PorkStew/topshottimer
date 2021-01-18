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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //await prefs.setDouble('userSensitivity', 50.00);
    String sUserID = await prefs.getString('id');

    //print(dSensitivity.toString());
    return sUserID;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("View Splits")),
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
                                  Color(0xFFA2C11C)),
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
                                          child: Container(
                                              padding: new EdgeInsets.only(left: 10.0),
                                              child: Column(

                                            //mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                            children: <Widget>[

                                              Row(
                                              children: <Widget>[
                                              Text("Shot: "+(index + 1).toString(), style: TextStyle(fontSize: 24, color: Color(0xFFA2C11C)),),
                                            ]

                                            ),
                                            Row(
                                            children: <Widget>[
                                              Text("Split Time: "+arrSplits[index],style: TextStyle(fontSize: 20,),textAlign: TextAlign.right),
                                            ]
                                            )


                                            ],
                                            )
                                          ),
                                        ),

                                      ],
                                    )


                                );
                              },

                            ),
                          ),
                          FlatButton(
                            child: Text("Delete String", style: TextStyle(color: Color(0xFFA2C11C)),),
                            onPressed: () {
                                showDialog(
                                context: context,
                                builder: (BuildContext context){
                                  return AlertDialog(
                                    title: Text("Delete String and Splits"),
                                    content: Text("Are you sure you would like to delete this string?"),
                                    actions: [
                                      FlatButton(
                                        child: Text("Cancel"),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                      FlatButton(
                                        child: Text("Delete"),
                                        onPressed: () {
                                          deleteStringSplits();
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => pageSelector()));
                                          showDialog(
                                      context: context,
                                      builder: (BuildContext context){
                                        return AlertDialog(
                                          title: Text("String Deleted"),
                                          content: Text("Your string was deleted succesfully"),
                                          actions: [
                                            FlatButton(child: Text("Ok"),
                                              onPressed: () {
                                              Navigator.pop(context);
                                              },
                                            ),
                                          ],
                                        );
                                      });
                                           },
                                      )
                                    ],
                                  );

                                }

                                );

                                    }
                                                )            //deleteStringSplits();




                        ]
                    );
                  }
              }
            },
          ),
        ));
    //

  }

  deleteStringSplits() async{
    var url = 'https://www.topshottimer.co.za/deleteStringSplits.php';
    var res = await http.post(
        Uri.encodeFull(url), headers: {"Accept": "application/jason"},
        body: {
          //get this information from user defaults
          "stringId": sStringID,
        }
    );

  }

}


