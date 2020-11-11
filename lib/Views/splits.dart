import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'PageSelector.dart';

class Splits extends StatefulWidget {
  String sTest;
  Splits(this.sTest);

  @override
  State<StatefulWidget> createState(){
    return SplitsState(this.sTest,);
  }
}


class SplitsState extends State<Splits> {


  String sHelloWorld;
  SplitsState(this.sHelloWorld);
  List<String> strings;
  List<String> arrShots = List<String>();
  @override
  void initState() {
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
    super.initState();


  }
  @override
  Widget build(BuildContext context) {



    return Scaffold(
      backgroundColor: Colors.white,
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
                                Text(index.toString(),style: TextStyle(fontSize: 30),),
                                Spacer(),
                                Text(sShot,style: TextStyle(fontSize: 30)),
                                Spacer(),
                                FlatButton(
                                  //color: Colors.red,
                                  height: 35,
                                  minWidth: 35,
                                  shape: CircleBorder(side: BorderSide(color: Colors.red, width: 2)),
                                  child: Text("X",style: TextStyle(fontSize: 20, color: Colors.red),),
                                  onPressed: () {
                                    setState(() {
                                      arrShots.remove(sShot);
                                      print(arrShots);
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
              FlatButton(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0), side: BorderSide(color: Colors.green)),
                height: 35,
                minWidth: 35,
                child: Text("Save String",style: TextStyle(fontSize: 20, color: Colors.black),),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context){
                        return AlertDialog(
                          title: Text("Please enter a name for this string below:"),
                          content: TextField(
                            decoration: InputDecoration(labelText: 'String Name',),
                          ),
                          actions:[


                            FlatButton(child: Text("Cancel"),
                              onPressed: () {
                                  Navigator.pop(context);
                              },),
                            FlatButton(child: Text("Save"),
                            onPressed: () {

                              Navigator.push(context, MaterialPageRoute(builder: (context) => pageSelector()));
                            },)
                          ],
                        );
                      }
                  );
                },


              )
            ]
        ),




      ),
    );
    // return Container(
    //   child: new ListView.builder(
    //     itemCount: arrShots.length,
    //     itemBuilder: (BuildContext context, int index){
    //       return Container(
    //         child: Card(
    //           child: Column(
    //             children: <Widget>[
    //               Text(index.toString()),
    //               Text(arrShots[index])
    //             ],
    //           ),
    //         ),
    //       );
    //     },
    //   ),
    //
    // );
    // return Scaffold(
    //   backgroundColor: Colors.white,
    //       body: Center(child: Column(
    //         children: [
    //           //Text(strings[1], style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),) ,
    //           new ListView.builder(
    //               itemCount: arrShots.length,
    //               itemBuilder: (BuildContext ctxt, int index) {
    //                 return Container(
    //                   child: Card(
    //                     child: Column(
    //                       children: <Widget>[
    //                         Text(index.toString()),
    //                         // Text(arrShots[index]),
    //
    //                       ],
    //                     ),
    //                   )
    //                 );
    //               }),
    //           // FlatButton(
    //           //     color: Colors.blue,
    //           //     minWidth: 80,
    //           //     height: 80,
    //           //     shape: CircleBorder(side: BorderSide(color: Colors.black, width: 4)),
    //           //     child: Text("Print Array", style: TextStyle(fontSize: 25, fontFamily: 'Digital-7')),
    //           //     onPressed: () {
    //           //
    //           //     }
    //           // )
    //
    //
    //
    //         ],
    //
    //       )
    //       )
    // );

  }
}


