import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_3/constatnt.dart';
import 'package:flutter_3/model/photo.dart';
import 'package:flutter_3/pages/add_name.dart';
import 'package:path_provider/path_provider.dart';

import '../confirm_box.dart';
import 'package:path/path.dart' as path;
import '../controller/dbhelper.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  //

  DbHelper dbHelper = DbHelper();
  String? currentUser;

  getUserName() async {
    var data = await dbHelper.getName();
    setState(() {
      currentUser = data;
    });
  }

  //
  @override
  void initState() {
    super.initState();
    getUserName();
    // getUserImage();
  }

  File? pickedPhoto;
  // var currentPhoto;
  bool change = false;


  final TextEditingController _nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: Text(
          "Settings",
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(
          12.0,
        ),
        children: [
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.all(18.0),
              child: Stack(children: [
                CircleAvatar(
                  radius: 70,
                  backgroundColor: Colors.grey,
                  backgroundImage: pickedPhoto != null
                      ? FileImage(pickedPhoto!)
                      : null,
                      child: Text(currentUser == null?'':currentUser!.split('').first, style: TextStyle(fontSize: 60, color: Colors.white),),
                ),
                // Positioned(
                //   bottom: 5,
                //   right: 0,
                //   child: IconButton(
                //     onPressed: () async {
                //       File? result = await dbHelper.addPhoto();
                //       // Photo myPhoto = Photo(photo: result!); 
                //       dbHelper.setImage(result!);
                //       setState(() {
                //         pickedPhoto = result;
                //       });
                //     },
                //     icon: const Icon(
                //       Icons.add_a_photo,
                //       color: Colors.white,
                //       size: 40,
                //     ),
                //   ),
                // )
              ]),
            ),
          ),
          Center(child: Text(currentUser == null?'':currentUser!, style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),)),
          const Text(
            'Other Settings',
            style: TextStyle(fontSize: 20),
          ),
          
          const SizedBox(
            height: 10,
          ),
          ListTile(
            onTap: () async {
              bool answer = await showConfirmDialog(context, "Warning",
                  "This is irreversible. Your entire data will be Lost");
              if (answer) {
                await dbHelper.cleanData();
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => AddName()));
              }
            },
            tileColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 12.0,
              horizontal: 20.0,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                8.0,
              ),
            ),
            title: const Text(
              "Clean Data",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w800,
              ),
            ),
            subtitle: const Text(
              "This is irreversible",
            ),
            trailing: const Icon(
              Icons.delete_forever,
              size: 32.0,
              color: Colors.black87,
            ),
          ),
          //
          const SizedBox(
            height: 20.0,
          ),
          //
          ListTile(
            onTap: () async {
              String? name = await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: Colors.grey[300],
                  title: const Text(
                    "Enter new name",
                  ),
                  content: Container(
                    decoration: BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.circular(
                        12.0,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 16.0,
                    ),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        hintText: "Your Name",
                        border: InputBorder.none,
                      ),
                      style: const TextStyle(
                        fontSize: 20.0,
                      ),
                      maxLength: 12,
                      controller: _nameController,
                    ),
                  ),
                  actions: [
                    ElevatedButton(
                      onPressed: () async {
                        if (_nameController.text.isEmpty) {
                          Navigator.of(context).pop();
                        } else {
                          setState(() {
                            dbHelper.setName(_nameController.text);
                            getUserName();
                            Navigator.of(context).pop();
                          });
                        }
                      },
                      child: const Text(
                        "OK",
                      ),
                    ),
                  ],
                ),
              );
              //
            },
            tileColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 12.0,
              horizontal: 20.0,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                8.0,
              ),
            ),
            title: const Text(
              "Change Name",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w800,
              ),
            ),
            subtitle: Text(
              "Welcome $currentUser",
            ),
            trailing: Icon(
              Icons.change_circle,
              size: 32.0,
              color: Colors.black87,
            ),
          ),
          //
          SizedBox(
            height: 20.0,
          ),
          //
          FutureBuilder<bool>(
            future: dbHelper.getLocalAuth(),
            builder: (context, snapshot) {
              // print(snapshot.data);
              if (snapshot.hasData) {
                return SwitchListTile(
                  onChanged: (val) {
                    change = val;
                    setState(() {
                      // val = !val;
                    });
                  },
                  value: change,
                  tileColor: Colors.white,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 12.0,
                    horizontal: 20.0,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      8.0,
                    ),
                  ),
                  title: Text(
                    "Local Bio Auth",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  subtitle: Text(
                    "Secure This app, Use Fingerprint to unlock the app.",
                  ),
                );
              } else {
                return Container();
              }
            },
          ),
        ],
      ),
    );
  }
}
