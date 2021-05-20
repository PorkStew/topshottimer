
import 'package:flutter/material.dart';

class AdvanceCustomAlert extends State {
  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
        ),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            Container(
              //this will affect the height of the dialog
              height: 160,
              child: Padding(
                //play with top padding to make items fit
                padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                    child: Text("Are you sure you would like to delete this string!", style: TextStyle(fontSize: 17),textAlign: TextAlign.center,),
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
                                color: Colors.blueAccent,
                              ),
                              height: 45,
                              child: Center(
                                child: Text("Cancel",
                                    style: TextStyle(fontSize: 20)),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: (){
                              // Navigator.pop(context);
                              //Navigator.push(context,
                              // MaterialPageRoute(builder: (context) => SignUp(_email.text)));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.only(bottomRight: Radius.circular(10)),
                                  //color: Themes.PrimaryColorRed,
                                  color: Colors.amber
                              ),
                              height: 45,
                              child: Center(
                                child: Text("Delete",
                                    style: TextStyle(fontSize: 20)),
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
                    backgroundColor: Colors.redAccent,
                    radius: 40,
                    child: Image.asset("assets/Exclamation@3x.png", height: 53,)
                )
            ),
          ],
        )
    );
  }
}