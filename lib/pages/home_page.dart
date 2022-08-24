import 'package:flutter/material.dart';
import 'package:flutter_3/controller/dbhelper.dart';
import 'package:flutter_3/model.dart';
import 'package:flutter_3/pages/add_transaction.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import '../constatnt.dart';
import 'setting_page.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    fetchItem();
    getUserName();
  }

  getUserName() async {
    String? data = await dataBase.getName();
    setState(() {
      userName = data;
    });
  }

  DbHelper dataBase = DbHelper();
  int totalBalance = 0;
  int totalIcome = 0;
  int totalExpense = 0;
  String? userName;
  DateTime today = DateTime.now();
  List<FlSpot> spot = [];
  Box dataBox = Hive.box('money');

  //fetch Data
  Future<List<TransactionModel>> fetchItem() async {
    if (dataBox.isEmpty) {
      return Future.value([]);
    } else {
      List<TransactionModel> item = [];
      dataBox.toMap().values.forEach((element) {
        // print(element);
        item.add(
          TransactionModel(
              Amount: element['amount'] as int,
              date: element['date'] as DateTime,
              type: element['type'],
              note: element['note']),
        );
      });

      return item;
    }
  }

  getMyData(List<TransactionModel> allData) {
    totalBalance = 0;
    totalIcome = 0;
    totalExpense = 0;
    for (TransactionModel data in allData) {
      // if (data.date.month == today.month) {
      if (data.type == 'Income') {
        totalBalance += data.Amount;
        totalIcome += data.Amount;
      } else {
        totalBalance -= data.Amount;
        totalExpense += data.Amount;
      }
    }
  }

  List<FlSpot> getSpot(List<TransactionModel> mySpot) {
    spot = [];
    for (TransactionModel data in mySpot) {
      if (data.type == 'Expenses' && data.date.month == today.month) {
        spot.add(FlSpot(data.date.day.toDouble(), data.Amount.toDouble()));
      }
    }
    return spot;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        elevation: 0,
      ),
      backgroundColor: Color(0xffe2e7ef),
      body: FutureBuilder<List<TransactionModel>>(
          future: fetchItem(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text('Unexpected Error Occur!'),
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.data!.isEmpty) {
              return const Center(
                child: Text('No Data To Fectch'),
              );
            }
            getMyData(snapshot.data!);
            getSpot(snapshot.data!);
            return ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 25,
                            backgroundImage: AssetImage('assets/bird.png'),
                          ),

                          const SizedBox(
                            width: 10,
                          ),
                          // Text('Welcome Matcot', style: Theme.of(context).textTheme.headline5),
                          RichText(
                              text: TextSpan(children: [
                            TextSpan(
                                text: 'Welcome ',
                                style: Theme.of(context).textTheme.headline5),
                            TextSpan(
                                text: userName,
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 20,
                                    color: PrimaryMaterialColor))
                          ]))
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: ((context) => Settings()),
                            ),
                          ).whenComplete(() {
                            getUserName();
                          });
                        },
                        child: MyIcon(
                            icon: Icons.settings,
                            color: Colors.white,
                            IconColor: Colors.black),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(12),
                  child: Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [PrimaryMaterialColor, Colors.blueAccent],
                            begin: Alignment.centerLeft,
                            end: Alignment.bottomRight),
                        borderRadius: BorderRadius.circular(15)),
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Total Balance:',
                          style: TextStyle(color: Colors.white, fontSize: 25),
                        ),
                        Text(
                          '₦$totalBalance',
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 36,
                              color: Colors.white,
                              fontFamily: GoogleFonts.roboto().fontFamily),
                        ),
                        const Padding(padding: EdgeInsets.all(12)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            myTransction(
                                'Income', totalIcome, Icons.arrow_upward),
                            myTransction('Expense', totalExpense,
                                Icons.arrow_downward, Colors.red),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Expenese',
                    style: TextStyle(fontSize: 35, fontWeight: FontWeight.w700),
                  ),
                ),
                spot.length < 2
                    ? Container(
                        height: 100,
                        margin: EdgeInsets.symmetric(horizontal: 12),
                        alignment: Alignment.center,
                        child: Text(
                          'No Enough Data To Plot The Graph',
                          style: Theme.of(context).textTheme.headline5,
                        ),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 6,
                                color: Colors.black.withOpacity(0.3),
                                offset: Offset(0, 6),
                              )
                            ]))
                    : Container(
                        margin: EdgeInsets.symmetric(horizontal: 12),
                        padding: EdgeInsets.all(15),
                        height: 400,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 6,
                                color: Colors.black.withOpacity(0.3),
                                offset: Offset(0, 6),
                              )
                            ]),
                        child: LineChart(LineChartData(
                          borderData: FlBorderData(show: false),
                          lineBarsData: [
                            LineChartBarData(
                                isCurved: true,
                                spots: getSpot(
                                  snapshot.data!,
                                ),
                                color: PrimaryMaterialColor)
                          ],
                        )),
                      ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Recent Transactions',
                    style: TextStyle(fontSize: 35, fontWeight: FontWeight.w700),
                  ),
                ),
                ListView.builder(
                  itemCount: snapshot.data!.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: ((context, index) {
                    final indexData = snapshot.data![index];
                    return transactType(indexData.Amount, indexData.type,
                        indexData.note, indexData.date, index);
                    // return Text(indexData.toString());
                  }),
                )
              ],
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddTransaction(),
            ),
          ).whenComplete(() {
            setState(() {});
          });
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
        backgroundColor: PrimaryMaterialColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation
          .centerFloat, // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget myTransction(String type, int amount, IconData icon,
      [Color color = Colors.green]) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: [
          // Padding(padding: EdgeInsets.symmetric(horizontal: 20)),
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.white,
            child: Icon(
              icon,
              color: color,
            ),
          ),
          Padding(padding: EdgeInsets.only(left: 12)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                type,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              Text(
                'N$amount',
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                    color: Colors.white,
                    fontFamily: GoogleFonts.openSans().fontFamily),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget transactType(
      int value, String type, String note, DateTime date, int index) {
    return GestureDetector(
      onLongPress: () {
        showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                content: const Text('Do You want to delete this transaction',
                    style: TextStyle(
                      fontSize: 22,
                    )),
                title: const Text('Warning!',
                    style: TextStyle(fontSize: 28, color: Colors.red)),
                actions: [
                  TextButton(
                      onPressed: () async {
                        dataBase.myBox.deleteAt(index);
                        setState(() {
                          fetchItem();
                        });
                        Navigator.pop(context);
                      },
                      child: const Text('Yes',
                          style: TextStyle(fontSize: 18, color: Colors.green))),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('No',
                          style: TextStyle(fontSize: 18, color: Colors.red))),
                ],
              );
            });
      },
      child: Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: Color(0xffced4eb)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      type == 'Expenses'
                          ? Icons.arrow_circle_down
                          : Icons.arrow_circle_up,
                      color: type == 'Expenses' ? Colors.red : Colors.green,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      type == 'Income' ? 'Income' : 'Expenses',
                      style: TextStyle(fontSize: 25),
                    )
                  ],
                ),
                //date
                Text(
                  DateFormat.yMMMd().format(date),
                  style: TextStyle(fontSize: 15, color: Colors.black54),
                )
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  type == 'Expenses' ? '-N$value' : 'N$value',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                Text(
                  note,
                  style: TextStyle(fontSize: 15, color: Colors.black54),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
