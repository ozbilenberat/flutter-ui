import 'package:firestore_blog/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'formValidator.dart';
import 'package:intl/intl.dart';
import 'package:firestore_blog/formValidator.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({Key? key}) : super(key: key);

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  TextEditingController birtDateText = TextEditingController();
  TextEditingController emailText = TextEditingController();
  String error2 = '';
  String errorMessage = "";
  TextEditingController nameText = TextEditingController();
  TextEditingController nickname = TextEditingController();
  TextEditingController passwordText = TextEditingController();
  TextEditingController surNameText = TextEditingController();

  final GlobalKey<FormState> _key = GlobalKey<FormState>();

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

//ANCHOR: GİRİŞ
  Future<void> login() async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(
            email: emailText.text, password: passwordText.text)
        .then((kullanici) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfileScreen(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
            child: Column(
          children: [
            Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      border: Border(
                          bottom:
                              BorderSide(color: Colors.grey.withOpacity(0.3)))),
                  child: Center(
                      child: Container(
                    padding: const EdgeInsets.all(15.0),
                    height: MediaQuery.of(context).size.height / 10,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                    ),
                    alignment: Alignment.bottomCenter,
                    child: const Text("Create an account",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                            fontFamily: "Helvetica")),
                  )),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(5, 0, 5, 5),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.withOpacity(0.4))),
                  child: Form(
                    key: _key,
                    child: Column(
                      children: [
                        TextFormField(
                          validator: validateName,
                          controller: nameText,
                          decoration: InputDecoration(
                              hintText: "Name",
                              contentPadding: const EdgeInsets.only(left: 10),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .dividerColor
                                          .withOpacity(0.1))),
                              focusedBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              hintStyle: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300,
                                  color: Theme.of(context).hintColor)),
                        ),
                        TextFormField(
                          validator: validateName,
                          controller: surNameText,
                          decoration: InputDecoration(
                              hintText: "Surname",
                              contentPadding: const EdgeInsets.only(left: 10),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .dividerColor
                                          .withOpacity(0.1))),
                              focusedBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              hintStyle: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300,
                                  color: Theme.of(context).hintColor)),
                        ),
                        TextFormField(
                            controller: birtDateText,
                            decoration: InputDecoration(
                                hintText: "Date of birth",
                                contentPadding: const EdgeInsets.only(left: 10),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context)
                                            .dividerColor
                                            .withOpacity(0.1))),
                                focusedBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                hintStyle: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w300,
                                    color: Theme.of(context).hintColor)),
                            onSaved: (value) {},
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter date.';
                              }
                              return null;
                            },
                            onTap: () async {
                              DateTime? date = DateTime(1900);
                              FocusScope.of(context).requestFocus(FocusNode());

                              date = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1900),
                                  lastDate: DateTime(2100));
                              String formattedDate = DateFormat('dd-MM-yyyy')
                                  .format(date!)
                                  .toString();
                              birtDateText.text = formattedDate.toString();
                            }),
                        Center(
                          child: Text(errorMessage),
                        ),
                        TextFormField(
                          validator: validateEmaill,
                          controller: emailText,
                          decoration: InputDecoration(
                              hintText: "E-mail adress",
                              contentPadding: const EdgeInsets.only(left: 10),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .dividerColor
                                          .withOpacity(0.1))),
                              focusedBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              hintStyle: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300,
                                  color: Theme.of(context).hintColor)),
                        ),
                        TextFormField(
                          validator: validateNickname,
                          controller: nickname,
                          decoration: InputDecoration(
                              hintText: "Enter a nickname",
                              contentPadding: const EdgeInsets.only(left: 10),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .dividerColor
                                          .withOpacity(0.1))),
                              focusedBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              hintStyle: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300,
                                  color: Theme.of(context).hintColor)),
                        ),
                        TextFormField(
                          validator: validaPassword,
                          controller: passwordText,
                          decoration: InputDecoration(
                              hintText: "Password",
                              contentPadding: const EdgeInsets.only(left: 10),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .dividerColor
                                          .withOpacity(0.1))),
                              focusedBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              hintStyle: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300,
                                  color: Theme.of(context).hintColor)),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Center(
                child: Text(
              error2,
              style: const TextStyle(color: Colors.red),
            )),
            SizedBox(
              height: 34.0,
            ),
            ElevatedButton(
              child: const Text(
                "Submit",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w300),
              ),
              onPressed: () {
                if (_key.currentState!.validate()) {
                  try {
                    signUp();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileScreen(),
                      ),
                    );
                  } on FirebaseAuthException catch (error) {
                    errorMessage = error.message!;
                  }

                  setState(() {});
                }
              },
            )
          ],
        )));
  }
}
    