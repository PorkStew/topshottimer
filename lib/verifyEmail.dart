import 'package:flutter/material.dart';

class verifyEmail extends StatefulWidget {
  @override
  _verifyEmailState createState() => _verifyEmailState();
}

class _verifyEmailState extends State<verifyEmail> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: RaisedButton(
          onPressed: (){
            print("s");
          },
          child: Text('Enabled Button', style: TextStyle(fontSize: 20)),
        ),
      )
    );
  }
}

