import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../Themes.dart';
import '../PageSelector.dart';

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
                                child: Text("Delete String",style: TextStyle(fontSize: 20, color: Theme.of(context).buttonColor),),
                                onPressed: () {
                                  deleteStringConfirmationDialog();
                                  // showDialog(
                                  //     context: context,
                                  //     builder: (BuildContext context){
                                  //       return AlertDialog(
                                  //         title: Text("Delete String and Splits", style: TextStyle(color: Themes.darkTextColor)),
                                  //         content: Text("Are you sure you would like to delete this string?"),
                                  //         actions: [
                                  //           FlatButton(
                                  //             child: Text("Cancel"),
                                  //             onPressed: () {
                                  //               Navigator.pop(context);
                                  //             },
                                  //           ),
                                  //           FlatButton(
                                  //             child: Text("Delete"),
                                  //             onPressed: () {
                                  //               //deleteStringSplits();
                                  //               deleteStringConfirmationDialog();
                                  //               // Navigator.push(context, MaterialPageRoute(builder: (context) => pageSelector()));
                                  //               // showDialog(
                                  //               //     context: context,
                                  //               //     builder: (BuildContext context){
                                  //               //       return AlertDialog(
                                  //               //         title: Text("String Deleted", style: TextStyle(color: Themes.darkTextColor),),
                                  //               //         content: Text("Your string was deleted succesfully"),
                                  //               //         actions: [
                                  //               //           FlatButton(child: Text("Ok"),
                                  //               //             onPressed: () {
                                  //               //               Navigator.pop(context);
                                  //               //             },
                                  //               //           ),
                                  //               //         ],
                                  //               //       );
                                  //               //     });
                                  //             },
                                  //           )
                                  //         ],
                                  //       );
                                  //
                                  //     }
                                  //
                                  // );

                                },


                              ),
                              Spacer(),
                            ],

                          ),
                          // FlatButton(
                          //   child: Text("Delete String", style: TextStyle(color: Color(0xFFA2C11C)),),
                          //   onPressed: () {
                          //       showDialog(
                          //       context: context,
                          //       builder: (BuildContext context){
                          //         return AlertDialog(
                          //           title: Text("Delete String and Splits"),
                          //           content: Text("Are you sure you would like to delete this string?"),
                          //           actions: [
                          //             FlatButton(
                          //               child: Text("Cancel"),
                          //               onPressed: () {
                          //                 Navigator.pop(context);
                          //               },
                          //             ),
                          //             FlatButton(
                          //               child: Text("Delete"),
                          //               onPressed: () {
                          //                 deleteStringSplits();
                          //                 Navigator.push(context, MaterialPageRoute(builder: (context) => pageSelector()));
                          //                 showDialog(
                          //             context: context,
                          //             builder: (BuildContext context){
                          //               return AlertDialog(
                          //                 title: Text("String Deleted"),
                          //                 content: Text("Your string was deleted succesfully"),
                          //                 actions: [
                          //                   FlatButton(child: Text("Ok"),
                          //                     onPressed: () {
                          //                     Navigator.pop(context);
                          //                     },
                          //                   ),
                          //                 ],
                          //               );
                          //             });
                          //                  },
                          //             )
                          //           ],
                          //         );
                          //
                          //       }
                          //
                          //       );
                          //
                          //           }
                          //                       )            //deleteStringSplits();




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

  deleteStringConfirmationDialog(){
    Dialog dialog = new Dialog(
      backgroundColor: Themes.darkBackgoundColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
        ),
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
                    Text("Are you sure about this?", style: TextStyle(color: Colors.white, fontSize: 20),),
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
                                    style: TextStyle(fontSize: 20,color: Colors.white)),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: (){
                              print("Delete Clicked");
                              deleteStringConfirmationDialog();
                              deleteStringSplits();
                              Navigator.pushReplacementNamed(context, '/PageSelector');
                              // Navigator.pop(context);
                              //Navigator.push(context,
                              // MaterialPageRoute(builder: (context) => SignUp(_email.text)));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.only(bottomRight: Radius.circular(10)),
                                  //color: Themes.PrimaryColorRed,
                                  color: Themes.darkButton2Color,
                              ),
                              height: 45,
                              child: Center(
                                child: Text("Delete String",
                                    style: TextStyle(fontSize: 20,color: Colors.white)),
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
                    child: Image.asset("assets/Exclamation@3x.png", height: 53,)
                )
            ),
          ],
        )
    );
    showDialog(context: context, builder: (context) => dialog);

  }

}




