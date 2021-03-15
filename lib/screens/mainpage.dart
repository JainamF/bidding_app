import 'package:bidding_app/screens/bottom_navs/accountpage.dart';
import 'package:bidding_app/screens/bottom_navs/fundspage.dart';
import 'package:bidding_app/screens/bottom_navs/homepage.dart';
import 'package:bidding_app/services/authservice.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  List<Widget> _widget = <Widget>[
    HomePage(),
    AccountPage(),
    FundsPage(),
  ];
  void onIndexChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Casino"),
        actions: [
          IconButton(
            onPressed: () async {
              SharedPreferences preferences =
                  await SharedPreferences.getInstance();
              preferences.setStringList('task', null);
              context.read<AuthService>().signOut();
              Navigator.of(context).pushNamedAndRemoveUntil(
                "/login",
                (route) => false,
              );
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: Container(
        child: _widget.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_box_outlined),
            label: "Account",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.money_outlined),
            label: "Funds",
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: onIndexChanged,
      ),
    );
  }
}
