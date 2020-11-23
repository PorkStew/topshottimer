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

    String sID;

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
          return Text(''); //or a placeholder
        case ConnectionState.done:
          if (snapshot.hasError) {
            return Text('Error Here: ${snapshot.error}');
          } else {
            updateData(sID);
            return Text(sID, style: TextStyle(fontSize: 35),);
          }
      }
        },
      ),
    );
  }

    updateData(String sID) async {
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
      var id = data;
      print(id);
      print(id[1]['userID']);
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
