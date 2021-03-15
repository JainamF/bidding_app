import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
    return Container(
      child: Center(
        child: FortuneWheel(
          duration: Duration(seconds: 5),
          items: [
            for (var i in items)
              FortuneItem(
                child: Text(i),
                style: FortuneItemStyle(
                  color:
                      i.contains("Red") ? Color(0xFF8B0000) : Color(0xFF006400),
                ),
              ),
          ],
          //onFling: () => selected = 2,
          selected: selected,
        ),
      ),
    );
  }
}
