import 'package:drivers_app/global/globals.dart';
import 'package:flutter/material.dart';

import '../authentication/login_screen.dart';

class ProfileTabPage extends StatefulWidget {
  const ProfileTabPage({super.key});

  @override
  State<ProfileTabPage> createState() => _ProfileTabPageState();
}

class _ProfileTabPageState extends State<ProfileTabPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
          child: Text("Sign out"),
          onPressed: () {
            fauth.signOut();
            Navigator.push(
                context, MaterialPageRoute(builder: (c) => LoginScreen()));
          }),
    );
  }
}
