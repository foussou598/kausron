import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_chat/model/Firebasehelper.dart';

class ProfileController extends StatefulWidget {
  ProfileControllerState createState() => ProfileControllerState();
}

class ProfileControllerState extends State<ProfileController> {
  User user = FirebaseHelper().auth.currentUser;
  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Profile: ${user.uid} "));
  }
}
