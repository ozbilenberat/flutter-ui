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

String errorMessage = "";

//ANCHOR: KAYIT
Future<void> signUp() async {
  await FirebaseAuth.instance
      .createUserWithEmailAndPassword(
          email: emailText.text, password: passwordText.text)
      .then((users) {
    FirebaseFirestore.instance.collection("Users").doc(emailText.text).set({
      "Email": emailText.text,
      "Password": passwordText.text,
      "Name": nameText.text,
      "Surname": surNameText.text,
      "Birthdate:": birtDateText.toString(),
      "DisplayName": nickname.text
    });
  });
  await FirebaseAuth.instance.currentUser!.updateDisplayName(nickname.text);
}
