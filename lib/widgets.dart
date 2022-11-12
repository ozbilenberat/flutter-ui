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
final TextEditingController _textFieldController = TextEditingController();
String errorMessage = "";
Size size = WidgetsBinding.instance.window.physicalSize;

renewPasswordDialog(BuildContext context) async {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Find your OZBILEN app account'),
          content: TextField(
            controller: _textFieldController,
            textInputAction: TextInputAction.go,
            decoration:
                const InputDecoration(hintText: "Enter your e-mail adress"),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Submit'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      });
}

class SlideRightRoute extends PageRouteBuilder {
  @override
  Duration get transitionDuration => Duration(milliseconds: duration);
  final Widget page;
  double xy;
  double xz;
  int duration;

  SlideRightRoute(
      {required this.page,
      required this.xy,
      required this.xz,
      required this.duration})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              SlideTransition(
            position: Tween<Offset>(
              begin: Offset(xy, xz),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
}

class ColoredSafeArea extends StatelessWidget {
  final Widget child;
  final Color color;

  const ColoredSafeArea({Key? key, required this.child, required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.onPrimary,
      child: SafeArea(
        child: child,
      ),
    );
  }
}
