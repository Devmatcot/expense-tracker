import 'package:flutter/material.dart';
import 'package:flutter_3/controller/dbhelper.dart';
import 'package:flutter_3/pages/home_page.dart';

import '../constatnt.dart';

class AddName extends StatefulWidget {
  AddName({Key? key}) : super(key: key);

  @override
  State<AddName> createState() => _AddNameState();
}

class _AddNameState extends State<AddName> {
  DbHelper myDB = DbHelper();
  TextEditingController nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //  backgroundColor: Color(0xffe2e7ef),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome!, Add Your Name',
              style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: PrimaryMaterialColor),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              padding: EdgeInsets.only(bottom: 12),
              height: 60,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.blue[50]),
              child: TextField(
                controller: nameController,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 12,),
                  // hintMaxLines: 12
                ),
              maxLength: 12,
              ),
            ),
            Row(
              children: [
                Spacer(),
                GestureDetector(
                  onTap: () {
                    if (nameController.text.isEmpty) {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Please Add Name', style: TextStyle( fontWeight:FontWeight.w500)),
                          backgroundColor: Colors.red,
                        ),
                      );
                    } else {
                      myDB.setName(nameController.text);
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: ((context) => HomePage()),
                        ),
                      );
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 20),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(
                            colors: [PrimaryMaterialColor, Colors.blue])),
                    child: Row(
                      children: const [
                        Text(
                          'Next',
                          style: TextStyle(color: Colors.white, fontSize: 24),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                        )
                      ],
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
