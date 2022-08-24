import 'dart:io';

import 'package:hive/hive.dart';

part 'myphoto.g.dart';
@HiveType(typeId: 2)
class MyPhoto{
  @HiveField(0)
  DateTime time;
  @HiveField(1)
  File image;
  MyPhoto({required this.image, required this.time});
  }