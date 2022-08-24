import 'dart:io';

import 'package:flutter_3/model/myphoto.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/photo.dart';

class DbHelper {
  Box myBox = Hive.box('money');
  // Box<MyPhoto> photoBox = Hive.box<MyPhoto>('myPhoto');
  // Box myPic = Hive.box('myPic');
  SharedPreferences? myPrefrence;

//add data to database
  addData(int amount, String note, DateTime date, String type) {
    var value = {'amount': amount, 'note': note, 'date': date, 'type': type};
    myBox.add(value);
  }

  //fectch data from database
  Future<Map> fetchData() {
    if (myBox.values.isEmpty) {
      return Future.value({});
    } else {
      return Future.value(myBox.toMap());
    }
  }

  setName(String name) async {
    myPrefrence = await SharedPreferences.getInstance();
    myPrefrence!.setString('name', name);
  }

  Future<String?> getName() async {
    myPrefrence = await SharedPreferences.getInstance();
    final result = myPrefrence!.getString('name');
    return result;
  }

  cleanData() async {
    myPrefrence = await SharedPreferences.getInstance();
    await myPrefrence!.clear();
    myBox.clear();
  }

  Future<bool> getLocalAuth() async {
    return true;
  }

  setLocalAuth(bool val) {
    val = !val;
  }

 Future<File?> addPhoto() async {
    try {
      ImagePicker pickImage = ImagePicker();
      final selectedImage =
          await pickImage.pickImage(source: ImageSource.gallery);
      if (selectedImage != null) {
        return File(selectedImage.path);
      }else{
        return null;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  // setImage(File image) async {
  //   var photo = {'photo': image};
  //  await myPic.add(photo);
  // }

  // Future getImage() async {
  //  print(myPic.isOpen);
  //  print(myPic.isEmpty);
  // }
}
