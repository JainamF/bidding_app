import 'package:bidding_app/utilites/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController amountController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    List<String> items = [];
    for (var i = 0; i < 18; i++) {
      if (i.isEven) {
        items.add("Red");
      } else {
        items.add("Green");
      }
    }
    int selected = 0;
    return Container(
      height: 500.0,
      child: Column(
        children: [
          Container(
            height: 400.0,
            child: Center(
              child: FortuneWheel(
                duration: Duration(seconds: 30),
                items: [for (var i in items) FortuneItem(child: Text(i))],
                onFling: () => selected = 1,
                selected: selected,
              ),
            ),
          ),
          Container(
            height: 100.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text("Red"),
                  ),
                ),
                SizedBox(
                  width: 5.0,
                ),
                _buildAmountTF(),
                // Container(
                //   // width: 100.0,
                //   // height: 50.0,
                //   // child: TextField(
                //   //   decoration: InputDecoration(
                //   //       border: InputBorder.none, hintText: 'Enter Amount'),
                //   // ),
                // ),
                SizedBox(
                  width: 5.0,
                ),
                Container(
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text("Green"),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
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
          contentPadding: EdgeInsets.only(top: 14.0),
          hintText: 'Enter Amount',
          hintStyle: kHintTextStyle,
        ),
      ),
    );
  }
}
