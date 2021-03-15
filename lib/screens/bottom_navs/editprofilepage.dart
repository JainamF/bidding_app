import 'dart:io';
import 'package:bidding_app/services/authservice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../services/authservice.dart';

// import 'package:settings_ui/pages/settings.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  String useruid;
  final _auth = FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
    useruid = _auth.currentUser.uid;
    print(useruid);
  }

  File _image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  final _key = GlobalKey<ScaffoldState>();
  bool showPassword = false;
  String name;
  String email;
  String phone;
  String bio;
  String img;
  @override
  Widget build(BuildContext context) {
    String userUid = context.read<AuthService>().currentUser.uid;
    Future retrieveImage(BuildContext context, String image) async {
      img = await FirebaseStorage.instance.ref().child(image).getDownloadURL();
    }

    Future uploadPic(BuildContext context, String fileUrl) async {
      if (fileUrl ==
          "https://firebasestorage.googleapis.com/v0/b/biddingapp-d5dec.appspot.com/o/l60Hf.png?alt=media&token=bb39635b-f296-4054-a845-de4dc3418f48") {
        String fileName = basename(_image.toString());
        FirebaseStorage storage = FirebaseStorage.instance;
        Reference reference = storage.ref().child('users/$fileName');
        UploadTask uploadTask = reference.putFile(_image);

        // await uploadTask.whenComplete(() => null);
        await uploadTask
            .then((res) => retrieveImage(context, 'users/$fileName'));
        // await retrieveImage(context, 'users/$fileName');
      } else {
        String filePath = fileUrl.replaceAll(
            new RegExp(
                r'https://firebasestorage.googleapis.com/v0/b/biddingapp-d5dec.appspot.com/o/'),
            '');

        filePath = filePath.replaceAll(new RegExp(r'%2F'), "/");

        filePath = filePath.replaceAll(new RegExp(r'(\?alt).*'), '');

        Reference storageReferance = FirebaseStorage.instance.ref();
        print(filePath);

        await storageReferance.child(filePath).delete();

        String fileName = basename(_image.toString());
        Reference firebaseStorageRef =
            FirebaseStorage.instance.ref().child('users/$fileName');
        UploadTask uploadTask = firebaseStorageRef.putFile(_image);
        await uploadTask
            .then((res) => retrieveImage(context, 'users/$fileName'));
        // await uploadTask.whenComplete(() => null);
        // uploadTask.then((res) => res.ref.getDownloadURL());
        // await retrieveImage(context, 'users/$fileName');
      }
    }

    // Future uploadPic(BuildContext context) async {

    //   String fileName = basename(_image.toString());
    //   StorageReference firebaseStorageRef =
    //       FirebaseStorage.instance.ref().child(fileName);
    //   StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
    //   await uploadTask.onComplete;
    //   await retrieveImage(context, fileName);
    // }

    return Scaffold(
        key: _key,
        appBar: AppBar(
          title: Text("Profile"),
          // backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          // elevation: 1,
          // leading: IconButton(
          //   icon: Icon(
          //     Icons.arrow_back,
          //     color: Colors.green,
          //   ),
          //   onPressed: () {},
          // ),
          // actions: [
          //   // IconButton(
          //   //   icon: Icon(
          //   //     Icons.settings,
          //   //     color: Colors.green,
          //   //   ),
          //   //   onPressed: () {
          //   //     // Navigator.of(context).push(MaterialPageRoute(
          //   //     //     builder: (BuildContext context) => SettingsPage()));
          //   //   },
          //   // ),
          // ],
        ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("All Users")
                .doc(useruid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var doc = snapshot.data;
                return Container(
                  padding: EdgeInsets.only(left: 16, top: 25, right: 16),
                  child: GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                    },
                    child: ListView(
                      children: [
                        // Text(
                        //   " Profile",
                        //   style: TextStyle(
                        //       fontSize: 25, fontWeight: FontWeight.w500),
                        // ),
                        // SizedBox(
                        //   height: 15,
                        // ),
                        Center(
                          child: Stack(
                            children: [
                              Container(
                                width: 130,
                                height: 130,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: CircleAvatar(
                                    radius: 65,
                                    backgroundColor: Colors.white,
                                    child: ClipOval(
                                      child: new SizedBox(
                                        width: 180.0,
                                        height: 180.0,
                                        child: (_image == null)
                                            ? Image.network(
                                                doc['img'],
                                                fit: BoxFit.cover,
                                              )
                                            : Image.file(
                                                _image,
                                                fit: BoxFit.cover,
                                              ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        width: 4,
                                        color: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                      ),
                                      color: Colors.green,
                                    ),
                                    child: IconButton(
                                      icon: Icon(Icons.edit),
                                      onPressed: () {
                                        setState(() {
                                          getImage();
                                        });
                                      },
                                    ),
                                    // Icon(
                                    //                               Icons.edit,
                                    //                               color: Colors.white,
                                    //                             ),
                                  )),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 35,
                        ),

                        TextButton(
                            child: Text(
                              "Upload",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: TextButton.styleFrom(
                              primary: Colors.blueAccent,
                              textStyle: TextStyle(color: Colors.white),
                            ),
                            onPressed: () async {
                              await uploadPic(context, doc['img'].toString());
                            }),
                        SizedBox(
                          height: 10.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 35.0),
                          child: TextField(
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(bottom: 3),
                                labelText: "Full Name",
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                hintText: "${doc['name']}",
                                hintStyle: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                )),
                            onChanged: (val) => setState(() => name = val),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 35.0),
                          child: TextField(
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(bottom: 3),
                                labelText: "Email",
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                hintText: "${doc['email']}",
                                hintStyle: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                )),
                            onChanged: (val) => setState(() => email = val),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 35.0),
                          child: TextField(
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(bottom: 3),
                                labelText: "Phone No.",
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                hintText: "${doc['phone']}",
                                hintStyle: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                )),
                            onChanged: (val) => setState(() => phone = val),
                          ),
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.only(bottom: 35.0),
                        //   child: TextField(
                        //     decoration: InputDecoration(
                        //         contentPadding: EdgeInsets.only(bottom: 3),
                        //         labelText: "Bio",
                        //         floatingLabelBehavior:
                        //             FloatingLabelBehavior.always,
                        //         hintText: "${doc['bio']}",
                        //         hintStyle: TextStyle(
                        //           fontSize: 16,
                        //           fontWeight: FontWeight.bold,
                        //           color: Colors.black,
                        //         )),
                        //     onChanged: (val) => setState(() => bio = val),
                        //   ),
                        // ),
                        // buildTextField("Full Name", "${doc['name']}", false),
                        // buildTextField("E-mail", "${doc['email']}", false),
                        // buildTextField("Phone No.", "${doc['phone']}", false),
                        // buildTextField("Bio", "${doc['bio']}", false),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                padding: EdgeInsets.symmetric(horizontal: 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("Back",
                                  style: TextStyle(
                                      fontSize: 14,
                                      letterSpacing: 2.2,
                                      color: Colors.black)),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                if (img == null) {
                                  img = doc['img'];
                                }

                                if (name == null) {
                                  name = doc['name'];
                                }
                                if (phone == null) {
                                  phone = doc['phone'];
                                }
                                if (email == null) {
                                  email = doc['email'];
                                }
                                // if (bio == null) {
                                //   bio = doc['bio'];
                                // }

                                await FirebaseFirestore.instance
                                    .collection("All Users")
                                    .doc(useruid)
                                    .update({
                                  'name': name,
                                  'phone': phone,
                                  'email': email,
                                  'img': img,
                                });
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Colors.green,
                                padding: EdgeInsets.symmetric(horizontal: 50),
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: Text(
                                "SAVE",
                                style: TextStyle(
                                    fontSize: 14,
                                    letterSpacing: 2.2,
                                    color: Colors.white),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                );
              } else {
                return LinearProgressIndicator();
              }
            }));
  }

  // Widget buildTextField(
  //     String labelText, String placeholder, bool isPasswordTextField) {
  //   return Padding(
  //     padding: const EdgeInsets.only(bottom: 35.0),
  //     child: TextField(
  //       obscureText: isPasswordTextField ? showPassword : false,
  //       decoration: InputDecoration(
  //           suffixIcon: isPasswordTextField
  //               ? IconButton(
  //                   onPressed: () {
  //                     setState(() {
  //                       showPassword = !showPassword;
  //                     });
  //                   },
  //                   icon: Icon(
  //                     Icons.remove_red_eye,
  //                     color: Colors.grey,
  //                   ),
  //                 )
  //               : null,
  //           contentPadding: EdgeInsets.only(bottom: 3),
  //           labelText: labelText,
  //           floatingLabelBehavior: FloatingLabelBehavior.always,
  //           hintText: placeholder,
  //           hintStyle: TextStyle(
  //             fontSize: 16,
  //             fontWeight: FontWeight.bold,
  //             color: Colors.black,
  //           )),
  //     ),
  //   );
  // }
}
