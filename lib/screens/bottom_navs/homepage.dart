import 'package:bidding_app/utilites/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _key = GlobalKey<ScaffoldState>();
  bool isEnabled = true;
  final _auth = FirebaseAuth.instance;
  String uid;
  @override
  void initState() {
    super.initState();
    uid = _auth.currentUser.uid;
  }

  Widget _buildAmountTF() {
    return Container(
      width: 150.0,
      alignment: Alignment.center,
      decoration: kBoxDecorationStyle,
      height: 60.0,
      child: TextField(
        controller: amountController,
        keyboardType: TextInputType.number,
        style: TextStyle(
          color: Colors.white,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.only(left: 10.0),
          hintText: 'Enter Amount',
          hintStyle: kHintTextStyle,
        ),
      ),
    );
  }

  TextEditingController amountController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    List<String> items = [];
    for (var i = 0; i < 18; i++) {
      if (i.isEven) {
        items.add("$i Red");
      } else {
        items.add("$i Green");
      }
    }
    int selected = 5;
    return Scaffold(
      key: _key,
      body: Container(
        child: Column(
          children: [
            Container(
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("Funds")
                        .doc(uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return new Center(
                              child: new CircularProgressIndicator());
                        default:
                          DocumentSnapshot funds = snapshot.data;
                          return Center(
                              child: Text("${funds.data()['available']},"));
                      }
                    })),
            Container(
              child: Center(
                child: Container(
                  child: Text("HEllo"),
                ),
                // child: FortuneWheel(
                //   duration: Duration(seconds: 5),
                //   items: [
                //     for (var i in items)
                //       FortuneItem(
                //         child: Text(i),
                //         style: FortuneItemStyle(
                //           color: Colors.red,
                //           // i.contains("Red") ? Color(0xFF8B0000) : Color(0xFF006400),
                //         ),
                //       ),
                //   ],
                //   //onFling: () => selected = 2,
                //   selected: selected,
                // ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    child: Container(
                        child: isEnabled
                            ? ElevatedButton(
                                onPressed: () async {
                                  if (amountController.text.isEmpty) {
                                    _key.currentState.showSnackBar(SnackBar(
                                        content: Text("Enter Amount")));
                                  } else {
                                    int y = await getData();

                                    if (y >= int.parse(amountController.text)) {
                                      int z =
                                          y - int.parse(amountController.text);
                                      await uploadData(z);
                                    } else {
                                      _key.currentState.showSnackBar(SnackBar(
                                          content: Text(
                                              "You dont have enough balance to play")));
                                    }
                                  }
                                  setState(() {
                                    isEnabled = false;
                                  });
                                },
                                child: Text("Red"),
                              )
                            : ElevatedButton(
                                onPressed: null,
                                child: Text("Red"),
                              ))),
                SizedBox(
                  width: 10.0,
                ),
                _buildAmountTF(),
                SizedBox(
                  width: 10.0,
                ),
                Container(
                    child: isEnabled
                        ? ElevatedButton(
                            onPressed: () async {
                              if (amountController.text.isEmpty) {
                                _key.currentState.showSnackBar(
                                    SnackBar(content: Text("Enter Amount")));
                              } else {
                                int y = await getData();

                                if (y > int.parse(amountController.text)) {
                                  int z = y - int.parse(amountController.text);
                                  await uploadData(z);
                                } else {
                                  _key.currentState.showSnackBar(SnackBar(
                                      content: Text(
                                          "You dont have enough balance to play")));
                                }
                              }
                              setState(() {
                                isEnabled = false;
                              });
                            },
                            child: Text("Green"),
                          )
                        : ElevatedButton(
                            onPressed: null,
                            child: Text("Green"),
                          ))
              ],
            )
          ],
        ),
      ),
    );
  }

  uploadData(var val) async {
    await FirebaseFirestore.instance
        .collection("Funds")
        .doc(uid)
        .update({'available': val});
  }

  getData() async {
    var x = await FirebaseFirestore.instance.collection("Funds").doc(uid).get();
    return x.data()['available'];
  }
}
