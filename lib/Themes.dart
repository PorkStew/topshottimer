import 'package:flutter/material.dart';

class Themes {
  //Color background = new Color.fromRGBO(0, 46, 47, 47);
  static const PrimaryColorRed =  Color(0xFFF70000);
  static const PrimaryColorBlue =  Color(0xFF507EFF);
  Themes._();

  static final ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.white,

    //all values need to be defined to workimport 'package:flutter/material.dart';
    //
    // class Themes {
    //   //Color background = new Color.fromRGBO(0, 46, 47, 47);
    //   static const PrimaryColorRed =  Color(0xFFF70000);
    //   static const PrimaryColorBlue =  Color(0xFF507EFF);
    //   Themes._();
    //
    //   static final ThemeData lightTheme = ThemeData(
    //     scaffoldBackgroundColor: Colors.white,
    //
    //     //all values need to be defined to work
    //     primarySwatch: MaterialColor(0xFFF70000, {
    //       50:  Color(0xFFF70000),
    //       100: Color(0xFFF70000),
    //       200: Color(0xFFF70000),
    //       300: Color(0xFFF70000),
    //       400: Color(0xFFF70000),
    //       500: Color(0xFFF70000),
    //       600: Color(0xFFF70000),
    //       700: Color(0xFFF70000),
    //       800: Color(0xFFF70000),
    //       900: Color(0xFFF70000),
    //     }),
    //
    //     appBarTheme: AppBarTheme(
    //       color: PrimaryColorRed,
    //     ),
    //     primaryTextTheme: TextTheme(
    //       headline6: TextStyle(
    //         color: Colors.black,
    //         fontSize: 25,
    //       )
    //     ),
    //     iconTheme: IconThemeData(
    //       color: Colors.black,
    //     ),
    //     //dialogBackgroundColor: new Color(int.parse("0xff404040")),
    //     dividerColor:  Colors.black,
    //     inputDecorationTheme: InputDecorationTheme(
    //       enabledBorder: UnderlineInputBorder(
    //         borderSide: BorderSide(color: Colors.black),
    //       ),
    //       focusedBorder: UnderlineInputBorder(
    //         borderSide: BorderSide(color: Colors.black),
    //       ),
    //       labelStyle: TextStyle(color: Colors.grey),
    //     ),
    //     buttonColor: Colors.black,
    //     dialogBackgroundColor: Colors.white,
    //     //theme colors for text
    //     textTheme: _lightTextTheme,
    //   );
    //
    //   static final ThemeData darkTheme = ThemeData(
    //     scaffoldBackgroundColor: Colors.black,
    //     //all values need to be defined to work
    //     primarySwatch: MaterialColor(0xFFF70000, {
    //       50:  Color(0xFFF70000),
    //       100: Color(0xFFF70000),
    //       200: Color(0xFFF70000),
    //       300: Color(0xFFF70000),
    //       400: Color(0xFFF70000),
    //       500: Color(0xFFF70000),
    //       600: Color(0xFFF70000),
    //       700: Color(0xFFF70000),
    //       800: Color(0xFFF70000),
    //       900: Color(0xFFF70000),
    //     }),
    //
    //     appBarTheme: AppBarTheme(
    //       color: PrimaryColorRed,
    //     ),
    //     // primaryTextTheme: TextTheme(
    //     //   headline6: TextStyle(
    //     //     color: Colors.black,
    //     //     fontSize: 25,
    //     //   )
    //     // ),
    //     iconTheme: IconThemeData(
    //       color: Colors.white,
    //     ),
    //     //dialogBackgroundColor: new Color(int.parse("0xff404040")),
    //     dividerColor:  Colors.white,
    //     inputDecorationTheme: InputDecorationTheme(
    //       enabledBorder: UnderlineInputBorder(
    //         borderSide: BorderSide(color: Colors.white),
    //       ),
    //       focusedBorder: UnderlineInputBorder(
    //         borderSide: BorderSide(color: Colors.white),
    //       ),
    //       labelStyle: TextStyle(color: Colors.grey),
    //     ),
    //     buttonColor: Colors.white,
    //     dialogBackgroundColor: new Color(int.parse("0xff373737")),
    //     //theme colors for text
    //     textTheme: _darkTextTheme,
    //     // Divider(
    //     //   color: Colors.white,
    //     // ),
    //   );
    //
    //   static final TextTheme _lightTextTheme = TextTheme(
    //     //bodyText1: TextStyle(color: Colors.white),
    //     bodyText2: TextStyle(color: Colors.black),
    //     //button: TextStyle(color: Colors.red),
    //     //caption: TextStyle(color: Colors.red),
    //     //for text input color
    //     subtitle1: TextStyle(color: Colors.black), // <-- that's the one
    //     // headline1: TextStyle(color: Colors.red),
    //     // headline2: TextStyle(color: Colors.red),
    //     // headline3: TextStyle(color: Colors.red),
    //     // headline4: TextStyle(color: Colors.red),
    //     // headline5: TextStyle(color: Colors.red),
    //     //for app bar text color
    //     //headline6: TextStyle(color: Colors.red),
    //   );
    //   static final TextTheme _darkTextTheme = TextTheme(
    //
    //     //bodyText1: TextStyle(color: Colors.white),
    //     bodyText2: TextStyle(color: Colors.white),
    //     //button: TextStyle(color: Colors.red),
    //     //caption: TextStyle(color: Colors.red),
    //     //for text input color
    //     subtitle1: TextStyle(color: Colors.white), // <-- that's the one
    //     // headline1: TextStyle(color: Colors.red),
    //     // headline2: TextStyle(color: Colors.red),
    //     // headline3: TextStyle(color: Colors.red),
    //     // headline4: TextStyle(color: Colors.red),
    //     // headline5: TextStyle(color: Colors.red),
    //     //for app bar text color
    //     //headline6: TextStyle(color: Colors.red),
    //   );
    // }
    primarySwatch: MaterialColor(0xFFF70000, {
      50:  Color(0xFFF70000),
      100: Color(0xFFF70000),
      200: Color(0xFFF70000),
      300: Color(0xFFF70000),
      400: Color(0xFFF70000),
      500: Color(0xFFF70000),
      600: Color(0xFFF70000),
      700: Color(0xFFF70000),
      800: Color(0xFFF70000),
      900: Color(0xFFF70000),
    }),

    appBarTheme: AppBarTheme(
      color: PrimaryColorRed,
    ),
    primaryTextTheme: TextTheme(
      headline6: TextStyle(
        color: Colors.black,
        fontSize: 25,
      )
    ),
    iconTheme: IconThemeData(
      color: Colors.black,
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
    buttonColor: Colors.black,
    dialogBackgroundColor: Colors.white,
    //theme colors for text
    textTheme: _lightTextTheme,
  );

  static final ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: Colors.black,

    //all values need to be defined to work
    primarySwatch: MaterialColor(0xFFF70000, {
      50:  Color(0xFFF70000),
      100: Color(0xFFF70000),
      200: Color(0xFFF70000),
      300: Color(0xFFF70000),
      400: Color(0xFFF70000),
      500: Color(0xFFF70000),
      600: Color(0xFFF70000),
      700: Color(0xFFF70000),
      800: Color(0xFFF70000),
      900: Color(0xFFF70000),
    }),

    appBarTheme: AppBarTheme(
      color: PrimaryColorRed,
    ),
    // primaryTextTheme: TextTheme(
    //   headline6: TextStyle(
    //     color: Colors.black,
    //     fontSize: 25,
    //   )
    // ),
    iconTheme: IconThemeData(
      color: Colors.white,
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
    buttonColor: Colors.white,
    dialogBackgroundColor: new Color(int.parse("0xff373737")),
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
    bodyText2: TextStyle(color: Colors.white),
    //button: TextStyle(color: Colors.red),
    //caption: TextStyle(color: Colors.red),
    //for text input color
    subtitle1: TextStyle(color: Colors.white), // <-- that's the one
    // headline1: TextStyle(color: Colors.red),
    // headline2: TextStyle(color: Colors.red),
    // headline3: TextStyle(color: Colors.red),
    // headline4: TextStyle(color: Colors.red),
    // headline5: TextStyle(color: Colors.red),
    //for app bar text color
    //headline6: TextStyle(color: Colors.red),
  );
}