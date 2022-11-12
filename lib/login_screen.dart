import 'package:firestore_blog/create_account.dart';
import 'package:firestore_blog/profile_screen.dart';
import 'package:firestore_blog/widgets.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'main.dart';
import 'widgets.dart';

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
  bool isVisiblePass = passValue.value;
  TextEditingController passwordText = TextEditingController();

  @override
  void dispose() {
    darkNotifier.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    createBox();
  }

  void disposes() {
    passValue.dispose();
    super.dispose();
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
            errorMessage = error.message.toString();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    double contentPadding = deviceWidth / 1.3;
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
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
                  icon: Icon(
                      isDark ? Icons.wb_sunny_outlined : Icons.bubble_chart),
                ),
              ),
              Hero(
                tag: "logo",
                child: Container(
                  margin: EdgeInsets.only(top: deviceHeight / 10.0),
                  height: deviceHeight / 5,
                  child: Image.asset(
                    "assets/images/logo.png",
                  ),
                ),
              ),
              const SizedBox(
                height: 15.0,
              ),
              Form(
                child: Column(
                  children: [
                    Container(
                      width: deviceWidth / 1.3,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: TextFormField(
                        textAlign: TextAlign.start,
                        controller: emailText,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(
                              contentPadding / 3, 8.0, 0.0, 8.0),
                          hintText: "E-mail adress",

                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(2),
                            borderSide: BorderSide(
                                width: 2.0,
                                color:
                                    isDark ? Colors.white54 : Colors.black45),
                          ),
                          hintStyle:
                              const TextStyle(fontWeight: FontWeight.w500),
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
                      margin: const EdgeInsets.only(top: 4.0),
                      width: deviceWidth / 1.3,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: TextFormField(
                        obscureText: isVisiblePass,
                        textAlign: TextAlign.start,
                        controller: passwordText,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(
                                width: 2.0,
                                color:
                                    isDark ? Colors.white54 : Colors.black45),
                          ),
                          contentPadding: EdgeInsets.fromLTRB(
                              contentPadding / 3, 8.0, 0.0, 8.0),
                          hintText: "  Password",
                          hintStyle:
                              const TextStyle(fontWeight: FontWeight.w500),
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
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  errorMessage,
                  style: TextStyle(color: Colors.red.shade900),
                ),
              ),
              SizedBox(
                width: deviceWidth / 1.6,
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
                color: isDark ? Colors.black87 : Colors.white60,
                alignment: Alignment.centerRight,
                width: deviceWidth / 1.8,
                height: 35.0,
                child: errorMessage.isNotEmpty
                    ? TextButton(
                        style: TextButton.styleFrom(
                          textStyle: const TextStyle(fontSize: 15),
                        ),
                        onPressed: () {
                          renewPasswordDialog(context);
                        },
                        child: const Text(
                          "Can't login?",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15.0),
                        ),
                      )
                    : null,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  "Or, login with...",
                  style: TextStyle(color: Theme.of(context).hoverColor),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                width: deviceWidth / 1.5,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    OutlinedButton(
                      onPressed: () {},
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: const BorderSide(color: Colors.black12),
                        )),
                      ),
                      child: Image.asset(
                        isDark
                            ? 'assets/images/apple.png'
                            : 'assets/images/appledark.png',
                        height: 25.0,
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () {},
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: const BorderSide(color: Colors.black12),
                        )),
                      ),
                      child:
                          Image.asset('assets/images/google.png', height: 25.0),
                    ),
                    OutlinedButton(
                      onPressed: () {},
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: const BorderSide(color: Colors.black12),
                        )),
                      ),
                      child: Image.asset('assets/images/facebook.png',
                          height: 25.0),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(top: 35.0),
                child: Row(
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
                            SlideRightRoute(
                                page: CreateAccount(),
                                xy: -1.0,
                                xz: 0.0,
                                duration: 500));
                      },
                      child: const Text(
                        'Register',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15.0),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
