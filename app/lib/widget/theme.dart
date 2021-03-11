import 'package:flutter/material.dart';

const yYellow = const Color(0xFFfcd307);
const yPurple = const Color.fromRGBO(123, 75, 227, 1);
const yPink = const Color(0xfff5497b);
const lowPink= const  Color(0xffeb7c9c);
const yBlue =
const Color(0xFF526FD7); // From Figma, FF : alpha value, R:52 G:6F B:D7



const yErrorRed = Colors.red;

const yBackgroundWhite =  Colors.white;
const yBackgroundApp = Colors.white38;
const yWhite = Colors.white;

ThemeData buildTheme() {
  final ThemeData base = ThemeData.light();
  return base.copyWith(
    // CopyWith to create a widget bases on the previous one but change some settings
    accentColor: yPink,
    primaryColor: yBlue,
    buttonTheme: base.buttonTheme.copyWith(
      buttonColor: yPurple,
      splashColor: yWhite,
      shape: RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(5.0),
      ),
      textTheme: ButtonTextTheme.primary,
    ),
    scaffoldBackgroundColor: yBackgroundWhite,

    cardColor: yBackgroundWhite,
    cardTheme: CardTheme(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16.0)),
        //side: BorderSide(color: yBlue900, width: 1.2)
      ),
    ),
    textSelectionColor: yYellow,
    errorColor: yErrorRed,
    textTheme: _buildTextTheme(base.textTheme),
    primaryTextTheme: _buildTextTheme(base.primaryTextTheme),
    accentTextTheme: _buildTextTheme(base.accentTextTheme),
    primaryIconTheme: base.iconTheme.copyWith(
      // Blue buttons
      color: yWhite,
      size: 20,
    ),

    inputDecorationTheme: InputDecorationTheme(
      // Decorate the text inputs
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(7.0)),

      ),
    ),
  );
}

TextTheme _buildTextTheme(TextTheme base) {
  return base
      .copyWith(
    headline: base.headline.copyWith(
      fontWeight: FontWeight.w500,
    ),
    title: base.title.copyWith(fontSize: 15.0),
    caption: base.caption.copyWith(
      fontWeight: FontWeight.w400,
      fontSize: 14.0,
    ),
  )
      .apply(
    fontFamily: 'Raleway',
    displayColor: yWhite,
    bodyColor: Colors.black,
  );
}

