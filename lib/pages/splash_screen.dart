import 'package:flutter/material.dart';
import 'package:flutter_3/controller/dbhelper.dart';
import 'package:flutter_3/pages/add_name.dart';
import 'package:flutter_3/pages/add_transaction.dart';
import 'package:flutter_3/pages/home_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  DbHelper myDb = DbHelper();
  Future<void> getSetting() async {
    String? name = await myDb.getName();
   await Future.delayed(Duration(seconds: 4));
    if (name != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => AddName(),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    getSetting();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //  backgroundColor: Color(0xffe2e7ef),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/bird.png')
          ],
        ),
      ),
    );
  }
}
