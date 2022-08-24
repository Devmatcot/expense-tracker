import 'package:flutter/material.dart';
import 'package:flutter_3/constatnt.dart';
import 'package:flutter_3/model/myphoto.dart';
import 'package:flutter_3/pages/add_name.dart';
import 'package:flutter_3/pages/biometric_page.dart';
import 'package:flutter_3/pages/home_page.dart';
import 'package:flutter_3/pages/splash_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive/hive.dart';

import 'model/photo.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final document = await getApplicationDocumentsDirectory();
  Hive.init(document.path);
  await Hive.openBox('money');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: myTheme,
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
