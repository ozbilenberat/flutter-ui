import 'package:firestore_blog/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

TextEditingController emailText = TextEditingController();

TextEditingController nickname = TextEditingController();
TextEditingController nameText = TextEditingController();
TextEditingController surNameText = TextEditingController();
TextEditingController birtDateText = TextEditingController();
TextEditingController passwordText = TextEditingController();
String? gender;
final GlobalKey<FormState> _key = GlobalKey<FormState>();
String errorMessage = "";

//ANCHOR: KAYIT
Future<void> signUp() async {
  await FirebaseAuth.instance
      .createUserWithEmailAndPassword(
          email: emailText.text, password: passwordText.text)
      .then((users) {
    FirebaseFirestore.instance.collection("Users").doc(emailText.text).set({
      "User E-mail": emailText.text,
      "UserPassword": passwordText.text,
      "Name": nameText.text,
      "Surname": surNameText.text,
      "Birthdate:": birtDateText.toString(),
      "DisplayName": nickname.text
    });
  });
  await FirebaseAuth.instance.currentUser!.updateDisplayName(nickname.text);
}

Future<void> loginc([BuildContext? context]) async {
  await FirebaseAuth.instance
      .signInWithEmailAndPassword(
          email: emailText.text, password: passwordText.text)
      .then((user) {
    Navigator.push(
      context!,
      MaterialPageRoute(
        builder: (context) => ProfileScreen(),
      ),
    );
  });
}
