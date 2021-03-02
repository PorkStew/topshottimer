import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Themes {
  Themes._();
  //Color background = new Color.fromRGBO(0, 46, 47, 47);
  static const PrimaryColorRed =  Color(0xFFF70000);
  static const PrimaryColorBlue =  Color(0xFF507EFF);
  static const darkBackgoundColor = const Color(0xFF283739);
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
    //dialogBackgroundColor: new Color(int.parse("0xff404040")),
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
    //theme colors for text
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    //colorScheme: ColorScheme.light(),
    canvasColor: const Color(0xFF283739),

    scaffoldBackgroundColor: darkBackgoundColor,
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
      backgroundColor: darkBackgoundColor,
      unselectedItemColor: darkUnselectedIconColor,
      selectedItemColor: darkSelectedIconColor,

    ),
    //changes selection color for highlighting text
    cupertinoOverrideTheme: CupertinoThemeData(
      primaryColor: Colors.grey,
    ),
    cardTheme: CardTheme(
      color: darkBackgoundColor,


    ),

    iconTheme: IconThemeData(
      color: darkButton2Color,
    ),
    //dialogBackgroundColor: new Color(int.parse("0xff404040")),
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
    textSelectionColor: Colors.grey,
    buttonColor: Colors.white,
    dialogBackgroundColor: darkBackgoundColor,
    //theme colors for text
    textTheme: _darkTextTheme,

    // Divider(
    //   color: Colors.white,
    // ),
  );

  static final TextTheme _lightTextTheme = TextTheme(
    //bodyText1: TextStyle(color: Colors.white),
    bodyText2: TextStyle(color: Colors.black),
    //button: TextStyle(color: Colors.red),
    //caption: TextStyle(color: Colors.red),
    //for text input color
    subtitle1: TextStyle(color: Colors.black), // <-- that's the one
    // headline1: TextStyle(color: Colors.red),
    // headline2: TextStyle(color: Colors.red),
    // headline3: TextStyle(color: Colors.red),
    // headline4: TextStyle(color: Colors.red),
    // headline5: TextStyle(color: Colors.red),
    //for app bar text color
    //headline6: TextStyle(color: Colors.red),
  );
  static final TextTheme _darkTextTheme = TextTheme(

    //bodyText1: TextStyle(color: Colors.white),

    bodyText2: TextStyle(color: darkTextColor),
    //button: TextStyle(color: Colors.red),
    //caption: TextStyle(color: Colors.red),
    //for text input color
    subtitle1: TextStyle(color: darkTextColor), // <-- that's the one
    // headline1: TextStyle(color: Colors.red),
    // headline2: TextStyle(color: Colors.red),
    // headline3: TextStyle(color: Colors.red),
    // headline4: TextStyle(color: Colors.red),
    // headline5: TextStyle(color: Colors.red),
    //for app bar text color
    //headline6: TextStyle(color: Colors.red),
  );
}
