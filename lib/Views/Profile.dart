import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


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
    return Container(
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
                  valueColor: AlwaysStoppedAnimation<Color> (Colors.red),
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
            updateData(sID);
            return Column(
                children: <Widget> [
                  Flexible(
                    child:
                    new ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: arrStringID.length,
                      itemBuilder: (BuildContext context, int index){
                        return Container(
                            child:Column(
                              children: <Widget>[
                                Card(
                                  child: Row(
                                     //mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                    children: <Widget>[

                                      Text(arrStringName[index],style: TextStyle(fontSize: 30, color: Colors.black)),
                                      Spacer(),
                                      Text(arrTotalShots[index],style: TextStyle(fontSize: 30)),
                                      Spacer(),
                                      Text(arrTotalTime[index],style: TextStyle(fontSize: 30)),
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
    );
  }

    Future updateData(String sID) async {
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

      return "True";
      //print(id['userID']);

      //   print("failed");
      // }
      //Map<String, dynamic> data = json.decode(res.body);

      // var datas = json.decode(res.body);
      // //print(data);
      // print(datas);
      //   String id = data['id'];
      //   String status = data["status"];
      //   print("ss");
      //   print(id);
      //   print(status);
      //   print("dddd");
      //   //display message because they are not a user
      //   if (status == "notuser") {
      //     //saveUserInformation("1", "donovan@simplx.co.za", "e1a7b8ad45f95c9d0f401381236891d369ca80790393e307805e1dd700f8ecca", "true");
      //     print("we don't have this user");
      //     //Navigator.push(context, MaterialPageRoute(builder: (context) => pageSelector.pageSelector()));
      //     //createError();
      //   }
      //   //is a user but they haven't verified their email address
      //   else if (status == "nonverified" && id != null) {
      //     print("we have this user but they are not verified");
      //     saveUserInformation(id, email, hashedPassword, "false");
      //     Navigator.push(context, MaterialPageRoute(builder: (context) => verify.verifyEmail()));
      //   }
      //   //is a user and is verified email so they can use the app
      //   else if (status == "verified" && id != null) {
      //     print("user details is all in order");
      //     saveUserInformation(id, email, hashedPassword, "true");
      //     Navigator.push(context, MaterialPageRoute(builder: (context) => pageSelector.pageSelector()));
      //   } else{
      //
      //   }
      // }
    }
}



// updateData(String email, String password) async {
//   String hashedPassword = "";
//   var bytes = utf8.encode(password);
//   var digest = sha256.convert(bytes);
//   hashedPassword = digest.toString();
//
//   var url = 'https://www.topshottimer.co.za/login.php';
//   var res = await http.post(
//       Uri.encodeFull(url), headers: {"Accept": "application/jason"},
//       body: {
//         //get this information from user defaults
//         "userID": email,
//         "password": hashedPassword,
//       }
//   );
//   print("before res.body");
//   Map<String, dynamic> data = json.decode(res.body);
//   String id = data['id'];
//   String status = data["status"];
//   print("ss");
//   print(id);
//   print(status);
//   print("dddd");
//   //display message because they are not a user
//   if (status == "notuser") {
//     saveUserInformation("1", "donovan@simplx.co.za", "e1a7b8ad45f95c9d0f401381236891d369ca80790393e307805e1dd700f8ecca", "true");
//     print("we don't have this user");
//     Navigator.push(context, MaterialPageRoute(builder: (context) => pageSelector.pageSelector()));
//     //createError();
//   }
//   //is a user but they haven't verified their email address
//   else if (status == "nonverified" && id != null) {
//     print("we have this user but they are not verified");
//     saveUserInformation(id, email, hashedPassword, "false");
//     Navigator.push(context, MaterialPageRoute(builder: (context) => verify.verifyEmail()));
//   }
//   //is a user and is verified email so they can use the app
//   else if (status == "verified" && id != null) {
//     print("user details is all in order");
//     saveUserInformation(id, email, hashedPassword, "true");
//     Navigator.push(context, MaterialPageRoute(builder: (context) => pageSelector.pageSelector()));
//   } else{
//
//   }
// }



// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
//
//
// class Profile extends StatefulWidget {
//   @override
//   _ProfileState createState() => _ProfileState();
// }
//
// class _ProfileState extends State<Profile> {
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child:
//         Text("Hello World"),
//     );
//   }
//
//
//
// }
//
