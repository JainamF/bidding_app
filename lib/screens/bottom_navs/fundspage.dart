import 'package:bidding_app/services/authservice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FundsPage extends StatefulWidget {
  @override
  _FundsPageState createState() => _FundsPageState();
}

class _FundsPageState extends State<FundsPage> {
  final _auth = FirebaseAuth.instance;
  String uid;
  @override
  void initState() {
    super.initState();
    uid = _auth.currentUser.uid;
  }

  @override
  Widget build(BuildContext context) {
    // String uid = context.read<AuthService>().currentUser.uid;
    return StreamBuilder(
        stream:
            FirebaseFirestore.instance.collection("Funds").doc(uid).snapshots(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return new Center(child: new CircularProgressIndicator());
            default:
              DocumentSnapshot documentSnapshot = snapshot.data;
              Map<String, dynamic> map = documentSnapshot.data();
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Card(
                      child: Column(
                        children: [
                          ListTile(
                            title: Text("Avaliable Funds"),
                            trailing: Text(map['avaliable'].toString()),
                          ),
                          Divider(),
                          ListTile(
                            title: Text("Deposited Funds"),
                            trailing: Text(map['deposit'].toString()),
                          ),
                          Divider(),
                          ListTile(
                            title: Text("Withdrawal Funds"),
                            trailing: Text(map['withdrawal'].toString()),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      child: Text("Add Funds"),
                    ),
                  ],
                ),
              );
          }
        });
  }
}
