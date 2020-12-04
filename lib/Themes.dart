import 'package:flutter/material.dart';

class Themes {
  //Color background = new Color.fromRGBO(0, 46, 47, 47);
  Themes._();

  static final ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    primarySwatch: Colors.red,
    appBarTheme: AppBarTheme(
      color: Colors.red,
      iconTheme: IconThemeData(
        color: Colors.black,
      ),
    ),
    primaryTextTheme: TextTheme(
        headline6: TextStyle(
          color: Colors.black,
          fontSize: 25,
        )
    ),

    dialogBackgroundColor: Colors.orange,

    inputDecorationTheme: InputDecorationTheme(
      labelStyle: TextStyle(color: Colors.black),
      //hintStyle: TextStyle(color: Colors.red),
      // enabledBorder: UnderlineInputBorder(
      //   borderSide: BorderSide(color: Colors.red),
      // ),
      // focusedBorder: UnderlineInputBorder(
      //   borderSide: BorderSide(color: Colors.red),
      // ),
      // border: UnderlineInputBorder(
      //   borderSide: BorderSide(color: Colors.red),
      // ),
    ),
    textTheme: _darkTextTheme,
  );

  static final ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: new Color(int.parse("0xff404040")),
    primarySwatch: Colors.red,
    appBarTheme: AppBarTheme(
      color: Colors.red,
      iconTheme: IconThemeData(
        color: Colors.black,
      ),
    ),
    primaryTextTheme: TextTheme(
      headline6: TextStyle(
        color: Colors.black,
        fontSize: 25,
      )
    ),
    dialogBackgroundColor: new Color(int.parse("0xff404040")),

    inputDecorationTheme: InputDecorationTheme(
      labelStyle: TextStyle(color: Colors.white),
      //hintStyle: TextStyle(color: Colors.red),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.red),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.red),
      ),
      border: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.red),
      ),
    ),
    textTheme: _lightTextTheme,
    // Divider(
    //   color: Colors.white,
    // ),
  );

  static final TextTheme _lightTextTheme = TextTheme(
    //bodyText1: TextStyle(color: Colors.red),
    bodyText2: TextStyle(color: Colors.white),
    //button: TextStyle(color: Colors.red),
    //caption: TextStyle(color: Colors.red),
    //for text input color
    subtitle1: TextStyle(color: Colors.white), // <-- that's the one
    //headline1: TextStyle(color: Colors.red),
    //headline2: TextStyle(color: Colors.red),
    //headline3: TextStyle(color: Colors.red),
   // headline4: TextStyle(color: Colors.red),
    //headline5: TextStyle(color: Colors.red),
    //for app bar text color
    //headline6: TextStyle(color: Colors.black),
  );
  static final TextTheme _darkTextTheme = TextTheme(
    //bodyText1: TextStyle(color: Colors.red),
    bodyText2: TextStyle(color: Colors.black),
    //button: TextStyle(color: Colors.red),
    //caption: TextStyle(color: Colors.red),
    //for text input color
    subtitle1: TextStyle(color: Colors.black), // <-- that's the one
    //headline1: TextStyle(color: Colors.red),
    //headline2: TextStyle(color: Colors.red),
    //headline3: TextStyle(color: Colors.red),
    // headline4: TextStyle(color: Colors.red),
    //headline5: TextStyle(color: Colors.red),
    //for app bar text color
    //headline6: TextStyle(color: Colors.black),
  );
}