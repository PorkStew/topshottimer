import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:topshottimer/Views/viewSplits.dart';


class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
    Future fUSerID;
    Future fDataRetrieved;


    String sID;

    List<String> arrStringID = List<String>();
    List<String> arrStringName = List<String>();
    List<String> arrTotalShots = List<String>();
    List<String> arrTotalTime = List<String>();

    @override
    void initState() {
      super.initState();
      fUSerID = _getID();
    }


    Future<String> userID() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      //await prefs.setDouble('userSensitivity', 50.00);
      String sUserID = await prefs.getString('id');

      //print(dSensitivity.toString());
      return sUserID;
    }
    _getID() async{
    sID = await userID();
    var url = 'https://www.topshottimer.co.za/viewStrings.php';
    var res = await http.post(
        Uri.encodeFull(url), headers: {"Accept": "application/jason"},
        body: {
          //get this information from user defaults
          "userID": sID,
        }
    );
    //print(json.decode(res.body));


    print("before res.body");

    List<dynamic> data = json.decode(res.body);
    int iLength = data.length;
    print("Length of list: " + iLength.toString());
    var id = data;
    print(id);
    print(id[0]['userID']);

    for(int iPopulate = 0; iPopulate<=iLength-1; iPopulate++)
    {
      arrStringID.add(id[iPopulate]['stringId']);
      arrStringName.add(id[iPopulate]['stringName']);
      arrTotalShots.add(id[iPopulate]['totalShots']);
      arrTotalTime.add(id[iPopulate]['totalTime']);
    }

    //print(arrStringName[0].toString());
    for(int iPrint = 0; iPrint<=iLength-1; iPrint++)
    {
      //print(arrStringName[iPrint]);
      print("String ID: " + arrStringID[iPrint]+ ", String Name: " + arrStringName[iPrint]+ ", Total Shots: " + arrTotalShots[iPrint].toString() + ", Total Time: " + arrTotalTime[iPrint]);
    }

    return userID();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
      child: FutureBuilder(
        future: fUSerID,
        builder: (context,snapshot){

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
                  valueColor: AlwaysStoppedAnimation<Color> (Color(0xFFA2C11C)),
                  strokeWidth: 5.0,
                ),
              ),
            ),
          ],
        ),
      );
        case ConnectionState.done:
          if (snapshot.hasError) {
            return Text('');
          } else {
            print("Got into widget");
            retrieveData(sID);
            return Column(
                children: <Widget> [
                  Flexible(
                    child:
                    new ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: arrStringID.length,

                      itemBuilder: (BuildContext context, int index){
                        return InkWell(
                            onTap: () {
                              return Navigator.push(context, MaterialPageRoute(builder: (context) => viewSplits(arrStringID[index].toString())));

                              //Go to the next screen with Navigator.push
                            },
                            child:Column(
                              children: <Widget>[
                                Card(

                                  child: Container(
                                    padding: new EdgeInsets.only(left: 10.0),
                                    child: Column(

                                      children: <Widget>[
                                        Row(
                                      children: <Widget>[

                                      Text(arrStringName[index],style: TextStyle(fontSize: 24, color: Color(0xFFA2C11C))),

                                        ]),
                                        Row(

                                            children: <Widget>[

                                              Text("Total Time: " + arrTotalTime[index],style: TextStyle(fontSize: 17)),
                                              Spacer(),

                                            ]),
                                        Row(

                                            children: <Widget>[


                                              Text("Total Shots: " + arrTotalShots[index],style: TextStyle(fontSize: 17)),
                                              Spacer(),
                                            ]),



                                    ],
                                  ),)
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
  }

    Future retrieveData(String sID) async {
      var url = 'https://www.topshottimer.co.za/viewStrings.php';
      var res = await http.post(
          Uri.encodeFull(url), headers: {"Accept": "application/jason"},
          body: {
            //get this information from user defaults
            "userID": sID,
          }
      );
      //print(json.decode(res.body));


      print("before res.body");

      List<dynamic> data = json.decode(res.body);
      int iLength = data.length;
      print("Length of list: " + iLength.toString());
      var id = data;
      print(id);
      print(id[0]['userID']);

      for(int iPopulate = 0; iPopulate<=iLength-1; iPopulate++)
        {
          arrStringID.add(id[iPopulate]['stringId']);
          arrStringName.add(id[iPopulate]['stringName']);
          arrTotalShots.add(id[iPopulate]['totalShots']);
          arrTotalTime.add(id[iPopulate]['totalTime']);
        }

      //print(arrStringName[0].toString());
      for(int iPrint = 0; iPrint<=iLength-1; iPrint++)
      {
        //print(arrStringName[iPrint]);
        print("String ID: " + arrStringID[iPrint]+ ", String Name: " + arrStringName[iPrint]+ ", Total Shots: " + arrTotalShots[iPrint].toString() + ", Total Time: " + arrTotalTime[iPrint]);
      }


    }
}

