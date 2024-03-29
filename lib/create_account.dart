import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firestore_blog/login_screen.dart';
import 'package:firestore_blog/widgets.dart';
import 'package:flutter/material.dart';
import 'package:colorful_safe_area/colorful_safe_area.dart';

// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

import 'package:firestore_blog/formValidator.dart';
import 'package:firestore_blog/profile_screen.dart';

import 'formValidator.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({Key? key}) : super(key: key);

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  TextEditingController birtDateText = TextEditingController();
  TextEditingController emailText = TextEditingController();

  String errorMessage = "";
  TextEditingController nameText = TextEditingController();
  TextEditingController nickname = TextEditingController();
  TextEditingController passwordText = TextEditingController();
  TextEditingController surNameText = TextEditingController();

  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  //ANCHOR: KAYIT
  Future<void> signUp() async {
    try {
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
    } catch (e) {
      setState(() {
        if (e is FirebaseAuthException) {
          switch (e.message) {
            case 'There is no user record corresponding to this identifier. The user may have been deleted.':
              errorMessage = 'User with this e-mail not found.';
              break;
            case 'The password is invalid or the user does not have a password.':
              errorMessage = 'Invalid password.';
              break;
            case 'A network error (such as timeout, interrupted connection or unreachable host) has occurred.':
              errorMessage = 'No internet connection.';
              break;
            case 'The email address is already in use by another account.':
              errorMessage = 'Email address is already taken.';
              break;
            default:
              errorMessage = e.message.toString();
          }
        } else {
          errorMessage = 'Unknow error occured.';
        }
      });
    }
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
    return GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Scaffold(
          body: ColorfulSafeArea(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Stack(
                children: [
                  Container(
                    height: double.infinity,
                    width: double.infinity,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Hero(
                                tag: "logo",
                                child: Container(
                                  margin: EdgeInsets.only(
                                      top: MediaQuery.of(context).size.height /
                                          10.0),
                                  height:
                                      MediaQuery.of(context).size.height / 4,
                                  child: Image.asset(
                                    "assets/images/logo.png",
                                  ),
                                ),
                              ),
                              Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Colors.grey
                                                  .withOpacity(0.3)))),
                                  child: const Center(
                                    child: Text("Create an account",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 20,
                                            fontFamily: "Helvetica")),
                                  )),
                              Container(
                                margin: const EdgeInsets.fromLTRB(5, 0, 5, 5),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey.withOpacity(0.4))),
                                child: Form(
                                  key: _key,
                                  child: Column(
                                    children: [
                                      TextFormField(
                                        validator: validateName,
                                        controller: nameText,
                                        decoration: InputDecoration(
                                            hintText: "Name",
                                            contentPadding:
                                                const EdgeInsets.only(left: 10),
                                            enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Theme.of(context)
                                                        .dividerColor
                                                        .withOpacity(0.1))),
                                            focusedBorder: InputBorder.none,
                                            errorBorder:
                                                const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.red,
                                                  width: 0.0),
                                            ),
                                            hintStyle: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w300,
                                                color: Theme.of(context)
                                                    .hintColor)),
                                      ),
                                      TextFormField(
                                        validator: validateName,
                                        controller: surNameText,
                                        decoration: InputDecoration(
                                            contentPadding: EdgeInsets.only(
                                                left: 11,
                                                right: 3,
                                                top: 24,
                                                bottom: 10),
                                            errorStyle: TextStyle(
                                                fontSize: 9, height: 0.3),
                                            hintText: "Surname",
                                            enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Theme.of(context)
                                                        .dividerColor
                                                        .withOpacity(0.1))),
                                            focusedBorder: InputBorder.none,
                                            errorBorder:
                                                const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.red,
                                                  width: 0.0),
                                            ),
                                            hintStyle: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w300,
                                                color: Theme.of(context)
                                                    .hintColor)),
                                      ),
                                      TextFormField(
                                          controller: birtDateText,
                                          decoration: InputDecoration(
                                              hintText: "Date of birth",
                                              contentPadding:
                                                  const EdgeInsets.only(
                                                      left: 10),
                                              enabledBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Theme.of(context)
                                                          .dividerColor
                                                          .withOpacity(0.1))),
                                              focusedBorder: InputBorder.none,
                                              errorBorder:
                                                  const OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.red,
                                                    width: 0.0),
                                              ),
                                              hintStyle: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w300,
                                                  color: Theme.of(context)
                                                      .hintColor)),
                                          onSaved: (value) {},
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please enter date.';
                                            }
                                            return null;
                                          },
                                          onTap: () async {
                                            DateTime? date = DateTime(1900);
                                            FocusScope.of(context)
                                                .requestFocus(FocusNode());

                                            date = await showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime(1900),
                                                lastDate: DateTime(2100));
                                            String formattedDate =
                                                DateFormat('dd-MM-yyyy')
                                                    .format(date!)
                                                    .toString();
                                            birtDateText.text =
                                                formattedDate.toString();
                                          }),
                                      TextFormField(
                                        validator: validateEmaill,
                                        controller: emailText,
                                        decoration: InputDecoration(
                                            hintText: "E-mail adress",
                                            contentPadding:
                                                const EdgeInsets.only(left: 10),
                                            enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Theme.of(context)
                                                        .dividerColor
                                                        .withOpacity(0.1))),
                                            focusedBorder: InputBorder.none,
                                            errorBorder:
                                                const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.red,
                                                  width: 0.0),
                                            ),
                                            hintStyle: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w300,
                                                color: Theme.of(context)
                                                    .hintColor)),
                                      ),
                                      Center(
                                        child: errorMessage.isEmpty
                                            ? const SizedBox(
                                                height: 0.0,
                                              )
                                            : Text(errorMessage),
                                      ),
                                      TextFormField(
                                        validator: validateNickname,
                                        controller: nickname,
                                        decoration: InputDecoration(
                                            hintText: "Enter a nickname",
                                            contentPadding:
                                                const EdgeInsets.only(left: 10),
                                            enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Theme.of(context)
                                                        .dividerColor
                                                        .withOpacity(0.1))),
                                            focusedBorder: InputBorder.none,
                                            errorBorder:
                                                const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.red,
                                                  width: 0.0),
                                            ),
                                            hintStyle: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w300,
                                                color: Theme.of(context)
                                                    .hintColor)),
                                      ),
                                      TextFormField(
                                        validator: validaPassword,
                                        controller: passwordText,
                                        decoration: InputDecoration(
                                            hintText: "Password",
                                            contentPadding:
                                                const EdgeInsets.only(left: 10),
                                            enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Theme.of(context)
                                                        .dividerColor
                                                        .withOpacity(0.1))),
                                            focusedBorder: InputBorder.none,
                                            errorBorder:
                                                const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.red,
                                                  width: 0.0),
                                            ),
                                            hintStyle: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w300,
                                                color: Theme.of(context)
                                                    .hintColor)),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
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
                                  signUp().then((kullanici) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ProfileScreen(),
                                      ),
                                    );
                                  });
                                }

                                setState(() {});
                              }),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.height / 50.0,
                    left: 0,
                    right: MediaQuery.of(context).size.width - 70,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back,
                          color: IconTheme.of(context).color),
                      onPressed: () {
                        Navigator.push(
                          context,
                          SlideRightRoute(
                              page: const LoginScreen(),
                              xy: -1.0,
                              xz: 0.0,
                              duration: 100),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
