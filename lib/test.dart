// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:starttech_qr/auth/login.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: FutureBuilder(
          future: getCurrentUserDetails(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              User? user = snapshot.data;

              return Column(
                children: [
                  Text(user!.email.toString()),
                  Text(user.displayName.toString()),
                  // sign out button
                  ElevatedButton(
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                          (route) => false);
                    },
                    child: const Text('Sign out'),
                  ),
                ],
              );
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }

  Future<User?> getCurrentUserDetails() async {
    User? user = FirebaseAuth.instance.currentUser;
    return user;
  }
}
