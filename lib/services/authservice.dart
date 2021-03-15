import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth;
  AuthService(this._firebaseAuth);

  Stream<User> get authStateChanges => _firebaseAuth.authStateChanges();
  User get currentUser => _firebaseAuth.currentUser;
  Future<String> get userName async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('All Users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get();
    return documentSnapshot.data()['name'];
  }

  Future<String> signIn({String email, String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setStringList('credential', [email, password]);
      return 'Signed In';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        return 'Invalid credentials';
      }
      return e.message;
    }
  }

  Future<String> signUp({String name, String email, String password}) async {
    try {
      await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((user) {
        FirebaseFirestore.instance
            .collection("All Users")
            .doc(user.user.uid)
            .set({
          'name': name,
          'email': email,
          'phone': "",
          'img':
              "https://firebasestorage.googleapis.com/v0/b/biddingapp-d5dec.appspot.com/o/l60Hf.png?alt=media&token=bb39635b-f296-4054-a845-de4dc3418f48",
        });
        FirebaseFirestore.instance.collection("Funds").doc(user.user.uid).set({
          'avaliable': 500,
          'deposit': 500,
          'withdrawal': 0,
        });
      });
      return 'Signed Up';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      }
      return e.message;
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove('email');
  }
}
