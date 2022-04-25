import 'package:firestore_blog/profile_screen.dart';
import 'package:firestore_blog/s.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'create_account.dart';
import 'package:firestore_blog/create_account.dart';
import 'main.dart';
import 'theme_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailText = TextEditingController();
  TextEditingController passwordText = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  bool isCheck = false;
  late Box box1;

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

  @override
  void dispose() {
    darkNotifier.dispose();
    super.dispose();
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
        sdsds();
      });
    }
  }

  void sdsds() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Title"),
            content: Text(errorMessage),
            actions: <Widget>[
              TextButton(
                child: Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  bool checker = false;
  bool isDark = darkNotifier.value;
  @override
  Widget build(BuildContext context) {
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
                "assets/images/pngegg.png",
              ),
            ),
            const SizedBox(
              height: 15.0,
            ),
            Form(
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width / 1.3,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: Colors.white,
                    ),
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      controller: emailText,
                      decoration: const InputDecoration(
                          hintText: "E-mail adress",
                          hintStyle: TextStyle(
                              color: Colors.black26,
                              fontSize: 18,
                              fontWeight: FontWeight.w500)),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 2.0),
                    width: MediaQuery.of(context).size.width / 1.3,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: Colors.white,
                    ),
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      controller: passwordText,
                      decoration: const InputDecoration(
                          hintText: "Password",
                          hintStyle: TextStyle(
                              color: Colors.black26,
                              fontSize: 18,
                              fontWeight: FontWeight.w500)),
                    ),
                  ),
                ],
              ),
            ),
            TextButton(
                style: ButtonStyle(
                    overlayColor:
                        MaterialStateProperty.all(Colors.transparent)),
                onPressed: () => setState(() => isCheck = !isCheck),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  SizedBox(
                      height: 24.0,
                      width: 24.0,
                      child: Checkbox(
                          value: isCheck,
                          onChanged: (value) {
                            setState(() => isCheck = !isCheck);
                          })),
                  const SizedBox(width: 1.0),
                  const Text("Remember me")
                ])),
            Container(
              margin: const EdgeInsets.only(bottom: 5.0),
              width: MediaQuery.of(context).size.width / 2,
              height: 35.0,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.blue),
                  onPressed: () async {
                    setState(() {
                      login();
                    });
                  },
                  child: const Text("Sign-in")),
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
            Spacer(),
            Container(
              margin: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 5.0),
              width: MediaQuery.of(context).size.width / 1.8,
              height: 35.0,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Colors.blue, onPrimary: Colors.white),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CreateAccount()),
                    );
                  },
                  child: Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.only(left: 30.0),
                      child: const Text("Sign-up with E-mail"))),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 5.0),
              width: MediaQuery.of(context).size.width / 1.8,
              height: 35.0,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: const Color.fromARGB(255, 16, 51, 165),
                    onPrimary: Colors.white,
                  ),
                  onPressed: () {},
                  child: Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.only(left: 30.0),
                      child: const Text("Connect with Facebook"))),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 40.0),
              width: MediaQuery.of(context).size.width / 1.8,
              height: 35,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Colors.deepOrange, onPrimary: Colors.white),
                  onPressed: login,
                  child: Container(
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.only(left: 30.0),
                      child: const Text("Connect with Google"))),
            ),
          ],
        ),
      ),
    );
  }
}
