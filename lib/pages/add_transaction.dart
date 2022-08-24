import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_3/controller/dbhelper.dart';
import 'package:intl/intl.dart';

import '../constatnt.dart';

class AddTransaction extends StatefulWidget {
  AddTransaction({Key? key}) : super(key: key);

  @override
  State<AddTransaction> createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {
  TextEditingController _amountController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  String description = 'Some Expenses';
  int? amount;
  DateTime selectedDate = DateTime.now();
  String type = 'Income';
  DbHelper dataBase = DbHelper();
  Future<void> pickDate() async {
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2021),
        lastDate: DateTime(2099));
    if (picked == null) {
      return;
    }
    setState(() {
      selectedDate = picked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffe2e7ef),
        appBar: AppBar(
          toolbarHeight: 0,
          elevation: 0,
        ),
        body: ListView(
          padding: EdgeInsets.all(12),
          children: [
            SizedBox(
              height: 12,
            ),
            const Text(
              'Add Transaction',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 20,
            ),
            MyTextField(
                controller: _amountController,
                hintText: '0',
                icon: Icons.attach_money,
                textType: TextInputType.number),
            MyTextField(
                controller: _descriptionController,
                hintText: 'Description',
                icon: Icons.description,
                textType: TextInputType.multiline),
            Row(children: [
               MyIcon(
                icon: Icons.moving,
                IconColor: Colors.white,
              ),
              const SizedBox(
                width: 12,
              ),
              ChoiceChip(
                  label: Text('Income',
                      style: TextStyle(
                          color: type == 'Income' ? Colors.white : Colors.black,
                          fontSize: 16)),
                  selected: type == 'Income' ? true : false,
                  onSelected: (val) {
                    if (val) {
                      setState(() {
                        type = 'Income';
                      });
                    }
                  },
                  selectedColor: PrimaryMaterialColor),
              const SizedBox(
                width: 12,
              ),
              ChoiceChip(
                label: Text('Expenses',
                    style: TextStyle(
                        color: type == 'Expenses' ? Colors.white : Colors.black,
                        fontSize: 16)),
                selected: type == 'Expenses' ? true : false,
                onSelected: (val) {
                  if (val) {
                    setState(() {
                      type = 'Expenses';
                    });
                  }
                },
                selectedColor: PrimaryMaterialColor,
              ),
            ]),
            Row(
              children: [
                MyIcon(icon: Icons.calendar_today,IconColor: Colors.white,),
                const SizedBox(
                  width: 12,
                ),
                TextButton(
                  onPressed: pickDate,
                  child: Text(
                    '${DateFormat.yMMMEd().format(selectedDate)}',
                    style: const TextStyle(fontSize: 25),
                  ),
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.zero)),
                )
              ],
            ),
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  if (_amountController.text.isEmpty ||
                      _descriptionController.text.isEmpty) {
                    return;
                  } else {
                    dataBase.addData(int.parse(_amountController.text),
                        _descriptionController.text, selectedDate, type);
                    print('added');
                    Navigator.pop(context);
                  }
                },
                child: Text(
                  'Add Transaction',
                  style: TextStyle(fontSize: 25),
                ),
              ),
            )
          ],
        ) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}

class MyTextField extends StatelessWidget {
  final IconData icon;
  final String hintText;
  final TextEditingController controller;
  final TextInputType textType;

  const MyTextField(
      {Key? key,
      required this.icon,
      required this.hintText,
      required this.controller,
      required this.textType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        MyIcon(icon: icon,IconColor: Colors.white,),
        Expanded(
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hintText,
                fillColor: Colors.transparent,
                filled: true),
            keyboardType: textType,
            style: TextStyle(fontSize: 24),
          ),
        )
      ],
    );
  }
}

class MyIcon extends StatelessWidget {
   MyIcon({
    Key? key,
    required this.icon,
    this.color = const Color(0xff003399),
   required this.IconColor

  }) : super(key: key);

  final IconData icon;
   Color color;
   Color IconColor;


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: color == null?PrimaryMaterialColor:color,
          ),
          padding: EdgeInsets.all(12),
          child: Icon(icon, color: IconColor),
        ),
        const SizedBox(
          height: 12,
        ),
      ],
    );
  }
}
