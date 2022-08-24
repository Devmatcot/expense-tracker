  import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


      MaterialColor PrimaryMaterialColor = const MaterialColor(
      4278203289,
      <int, Color>{
        50: Color.fromRGBO(
          0,
          51,
          153,
          .1,
        ),
        100: Color.fromRGBO(
          0,
          51,
          153,
          .2,
        ),
        200: Color.fromRGBO(
          0,
          51,
          153,
          .3,
        ),
        300: Color.fromRGBO(
          0,
          51,
          153,
          .4,
        ),
        400: Color.fromRGBO(
          0,
          51,
          153,
          .5,
        ),
        500: Color.fromRGBO(
          0,
          51,
          153,
          .6,
        ),
        600: Color.fromRGBO(
          0,
          51,
          153,
          .7,
        ),
        700: Color.fromRGBO(
          0,
          51,
          153,
          .8,
        ),
        800: Color.fromRGBO(
          0,
          51,
          153,
          .9,
        ),
        900: Color.fromRGBO(
          0,
          51,
          153,
          1,
        ),
      },
    );

    ThemeData myTheme = ThemeData(
      fontFamily: "customFont",
      primaryColor: Color(0xff003399),

      primarySwatch: PrimaryMaterialColor,

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
            Color(0xff003399),
          ),
        ),
      ),
      textTheme: GoogleFonts.jostTextTheme(),
      // iconTheme: IconThemeData().copyWith(color: Colors.white )
    );
  