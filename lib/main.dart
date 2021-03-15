import 'package:bidding_app/screens/AdminHome.dart';
import 'package:bidding_app/screens/Auth/loginpage.dart';
import 'package:bidding_app/screens/Auth/register.dart';
import 'package:bidding_app/screens/bottom_navs/editprofilepage.dart';
import 'package:bidding_app/screens/mainpage.dart';
import 'package:bidding_app/services/authservice.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:bidding_app/services/authservice.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
//import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //SystemChrome.setEnabledSystemUIOverlays([]);
  SharedPreferences preferences = await SharedPreferences.getInstance();
  var task = preferences.getStringList('task');
  print(task);
  runApp(MultiProvider(
    providers: [
      Provider<AuthService>(create: (_) => AuthService()),
    ],
    child: MaterialApp(
      theme: ThemeData(
        cardTheme: CardTheme(color: Colors.blue[50]),
        primaryColor: Color(0xFF398AE5),
        accentColor: Color(0xFF73AEF5),
      ),
      debugShowCheckedModeBanner: false,
      home: task == null
          ? LoginPage()
          : task[2] == "true"
              ? AdminHome()
              : MainPage(),
      //home: AuthService().handleAuth(),

      routes: {
        '/login': (context) => LoginPage(),
        '/register': (context) => Register(),
        '/mainpage': (context) => MainPage(),
        '/editprofile': (context) => EditProfilePage(),
      },
    ),
  ));
}

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     SharedPreferences preferences = await SharedPreferences.getInstance();
//     var task = preferences.getStringList('task');
//     return MultiProvider(
//       providers: [
//         Provider<AuthService>(create: (_) => AuthService()),
//       ],
//       child: MaterialApp(
//         theme: ThemeData(
//           cardTheme: CardTheme(color: Colors.blue[50]),
//           primaryColor: Color(0xFF398AE5),
//           accentColor: Color(0xFF73AEF5),
//         ),
//         debugShowCheckedModeBanner: false,
//         home: task == null
//             ? LoginPage()
//             : task[2] == "true"
//                 ? AdminHome()
//                 : MainPage(),
//         //home: AuthService().handleAuth(),

//         routes: {
//           '/login': (context) => LoginPage(),
//           '/register': (context) => Register(),
//           '/mainpage': (context) => MainPage(),
//           '/editprofile': (context) => EditProfilePage(),
//         },
//       ),
//     );
//   }
// }
