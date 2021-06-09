
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Themes {
  Themes._();
  //variable declarations
  static const PrimaryColorRed =  Color(0xFFF70000);
  static const PrimaryColorBlue =  Color(0xFF507EFF);
  static const darkBackgroundColor = const Color(0xFF283739);
  static const darkTextColor = const Color(0xFFFFFFFF);
  static const darkParagraphColor = const Color(0xFF949494);
  static const darkButton1Color = const Color(0xFF2C5D63);
  static const darkButton2Color = const Color(0xFFA2C11C);
  static const darkUnselectedIconColor = const Color(0xFFA2C11C);
  static const darkSelectedIconColor = const Color(0xFFFFFFFF);

  static final ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    brightness: Brightness.light,
      primarySwatch: MaterialColor(0xFFA2C11C, {
      50:  darkButton2Color,
      100: darkButton2Color,
      200: darkButton2Color,
      300: darkButton2Color,
      400: darkButton2Color,
      500: darkButton2Color,
      600: darkButton2Color,
      700: darkButton2Color,
      800: darkButton2Color,
      900: darkButton2Color,
    }),
    appBarTheme: AppBarTheme(
      color: darkButton1Color,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      unselectedItemColor: darkUnselectedIconColor,
      selectedItemColor: darkButton1Color,

    ),
    cardTheme: CardTheme(
      color: Colors.white,
    ),
    iconTheme: IconThemeData(
      color: darkButton2Color,
    ),
    dividerColor:  Colors.black,
    inputDecorationTheme: InputDecorationTheme(
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.black),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.black),
      ),
      labelStyle: TextStyle(color: Colors.grey),
    ),
    buttonColor: Colors.white,
    dialogBackgroundColor: darkButton1Color,

    //theme colors for text
    textTheme: _lightTextTheme,

  );

  static final ThemeData darkTheme = ThemeData(

      // Text color
        // ),


    canvasColor: const Color(0xFF283739),
    scaffoldBackgroundColor: darkBackgroundColor,
    //all values need to be defined to work
    primarySwatch: MaterialColor(0xFFA2C11C, {
      50:  darkButton2Color,
      100: darkButton2Color,
      200: darkButton2Color,
      300: darkButton2Color,
      400: darkButton2Color,
      500: darkButton2Color,
      600: darkButton2Color,
      700: darkButton2Color,
      800: darkButton2Color,
      900: darkButton2Color,
    }),
    appBarTheme: AppBarTheme(
      color: darkButton1Color,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: darkBackgroundColor,
      unselectedItemColor: darkUnselectedIconColor,
      selectedItemColor: darkSelectedIconColor,
    ),
    //changes selection color for highlighting text
    cupertinoOverrideTheme: CupertinoThemeData(
      primaryColor: Colors.grey,
    ),
    cardTheme: CardTheme(
      color: darkBackgroundColor,
    ),
    iconTheme: IconThemeData(
      color: darkButton2Color,
    ),
    dividerColor:  Colors.white,
    inputDecorationTheme: InputDecorationTheme(
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
      ),
      labelStyle: TextStyle(color: Colors.grey),
    ),

    //changes selection color for highlighting text
    //textSelectionColor: Colors.grey, //DEPRECATED USE BELLOW
    textSelectionTheme: TextSelectionThemeData(
      selectionColor: Colors.grey
    ),
    buttonColor: Colors.white,
    dialogBackgroundColor: darkBackgroundColor,
    //theme colors for text
    textTheme: _darkTextTheme,
  );
  static final TextTheme _lightTextTheme = TextTheme(
    bodyText2: TextStyle(color: Colors.black),
    //for text input color
    subtitle1: TextStyle(color: Colors.black), // <-- that's the one
  );
  static final TextTheme _darkTextTheme = TextTheme(
    bodyText2: TextStyle(color: Colors.white),
    //for text input color
    subtitle1: TextStyle(color: darkTextColor), // <-- that's the one
  );
}
