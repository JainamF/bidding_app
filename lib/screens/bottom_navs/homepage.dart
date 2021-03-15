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
        items.add("Red");
      } else {
        items.add("Green");
      }
    }
    int selected = 0;
    return Container(
      child: Center(
        child: FortuneWheel(
          duration: Duration(seconds: 30),
          items: [for (var i in items) FortuneItem(child: Text(i))],
          onFling: () => selected = 1,
          selected: selected,
        ),
      ),
    );
  }
}
