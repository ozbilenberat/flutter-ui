import 'package:firestore_blog/create_account.dart';
import 'package:firestore_blog/profile_screen.dart';
import 'package:firestore_blog/widgets.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late Box box1;

  bool checker = false;
  TextEditingController emailText = TextEditingController();
  bool isCheck = false;
  bool isDark = darkNotifier.value;
  TextEditingController passwordText = TextEditingController();
  bool isVisiblePass = passValue.value;

  @override
  void dispose() {
    darkNotifier.dispose();
    super.dispose();
  }

  void disposes() {
    passValue.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    createBox();
  }

  void createBox() async {
    box1 = await Hive.openBox("logindata");
    getData();
  }

  void getData() {
    if (box1.get("emailText") != null) {
      emailText.text = box1.get("emailText");
    }
    if (box1.get("passwordText") != null) {
      passwordText.text = box1.get("passwordText");
    }
  }

  void clearEmailTextfield() {
    emailText.clear();
    setState(() {});
  }

//ANCHOR: GİRİŞ
  Future<void> login() async {
    try {
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
      if (isCheck) {
        box1.put("emailText", emailText.text);
        box1.put("passwordText", passwordText.text);
      }
    } on FirebaseAuthException catch (error) {
      setState(() {
        switch (error.code) {
          case "invalid-email":
            errorMessage = "Your email address appears to be malformed.";
            break;
          case "wrong-password":
            errorMessage = "Your password is wrong.";
            break;
          case "user-not-found":
            errorMessage = "User with this email doesn't exist.";
            break;
          case "user-disabled":
            errorMessage = "User with this email has been disabled.";
            break;

          default:
            errorMessage = "An undefined Error happened.";
        }
        showLoginError();
      });
    }
  }

  void showLoginError() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Title"),
            content: Text(errorMessage),
            actions: <Widget>[
              TextButton(
                child: const Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    double genis = MediaQuery.of(context).size.width / 1.3;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 35),
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerRight,
              child: IconButton(
                onPressed: () {
                  setState(() {
                    isDark = !isDark;
                    darkNotifier.value = isDark;
                  });
                },
                tooltip: 'Increment',
                icon:
                    Icon(isDark ? Icons.wb_sunny_outlined : Icons.bubble_chart),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 3,
              child: Image.asset(
                "assets/images/logo.png",
              ),
            ),
            const SizedBox(
              height: 15.0,
            ),
            Form(
              child: Column(
                children: [
                  Container(
                    width: genis,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: TextFormField(
                      textAlign: TextAlign.start,
                      controller: emailText,
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.fromLTRB(genis / 3, 8.0, 0.0, 8.0),
                        hintText: "E-mail adress",
                        hintStyle: const TextStyle(fontWeight: FontWeight.w500),
                        suffixIcon: IconButton(
                          icon: const Icon(
                            Icons.clear,
                          ),
                          onPressed: clearEmailTextfield,
                        ), // Show the clear button if the text field has something
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 2.0),
                    width: MediaQuery.of(context).size.width / 1.3,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: TextFormField(
                      obscureText: isVisiblePass,
                      textAlign: TextAlign.start,
                      controller: passwordText,
                      autofocus: true,
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.fromLTRB(genis / 3, 8.0, 0.0, 8.0),
                        hintText: "  Password",
                        hintStyle: const TextStyle(fontWeight: FontWeight.w500),
                        suffixIcon: IconButton(
                          color: Theme.of(context).highlightColor,
                          onPressed: () {
                            setState(() {
                              isVisiblePass = !isVisiblePass;
                              passValue.value = isVisiblePass;
                            });
                          },
                          tooltip: 'Increment',
                          icon: Icon(isVisiblePass
                              ? Icons.visibility
                              : Icons.visibility_off),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            /*  Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                    style: ButtonStyle(
                        overlayColor:
                            MaterialStateProperty.all(Colors.transparent)),
                    onPressed: () => setState(() => isCheck = !isCheck),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                              style: ButtonStyle(
                                  overlayColor: MaterialStateProperty.all(
                                      Colors.transparent)),
                              onPressed: () =>
                                  setState(() => isCheck = !isCheck),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                        height: 24.0,
                                        width: 24.0,
                                        child: Checkbox(
                                            value: isCheck,
                                            onChanged: (value) {
                                              setState(
                                                  () => isCheck = !isCheck);
                                            })),
                                    const SizedBox(width: 1.0),
                                    const Text("Remember me")
                                  ])),
                        ])),
              ],
            ), */

            Container(
              margin:
                  EdgeInsets.only(top: MediaQuery.of(context).size.height / 16),
              width: MediaQuery.of(context).size.width / 1.6,
              height: 35.0,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.blue),
                  onPressed: () async {
                    setState(() {
                      login();
                    });
                  },
                  child: const Text("Login")),
            ),
            Container(
              alignment: Alignment.topRight,
              width: MediaQuery.of(context).size.width / 1.8,
              height: 35.0,
              child: const Text(
                "Forgot password?",
                style: TextStyle(
                    fontSize: 11.0,
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 15.0),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                "Or, login with...",
                style: TextStyle(color: Theme.of(context).hoverColor),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 1.5,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: const BorderSide(color: Colors.black12),
                      )),
                    ),
                    child: Image.asset(
                      isDark
                          ? 'assets/images/apple.png'
                          : 'assets/images/appledark.png',
                      height: 24.0,
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: const BorderSide(color: Colors.black12),
                      )),
                    ),
                    child:
                        Image.asset('assets/images/google.png', height: 24.0),
                  ),
                  OutlinedButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: const BorderSide(color: Colors.black12),
                      )),
                    ),
                    child:
                        Image.asset('assets/images/facebook.png', height: 24.0),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "new to beratAPP?",
                  style: TextStyle(color: Theme.of(context).hoverColor),
                  textAlign: TextAlign.center,
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: const TextStyle(fontSize: 20),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CreateAccount()));
                  },
                  child: const Text(
                    'Register',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
