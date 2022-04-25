import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
  final FirebaseAuth auth = FirebaseAuth.instance;
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    var user = FirebaseAuth.instance.currentUser!;

    var nick = user.displayName;

    return Scaffold(
        body: Container(
      child: Column(
        children: [
          Text(nick.toString(),
              style: const TextStyle(color: Colors.redAccent)),
          Text("hh".toString()),
        ],
      ),
    ));
  }
}
