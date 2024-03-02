import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:starttech_qr/auth/enter_name.dart';
import 'package:starttech_qr/auth/welcome_page.dart';
import 'package:starttech_qr/home.dart';
import 'package:starttech_qr/main.dart';

class YonlendirmePage extends StatefulWidget {
  const YonlendirmePage({super.key});

  @override
  State<YonlendirmePage> createState() => _YonlendirmePageState();
}

class _YonlendirmePageState extends State<YonlendirmePage> {
  @override
  void initState() {
    super.initState();
    checkUser();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  void checkUser() async {
    await Future.delayed(const Duration(seconds: 1));
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      if (FirebaseAuth.instance.currentUser!.displayName.toString() == 'null' ||
          FirebaseAuth.instance.currentUser!.displayName!.toString().isEmpty) {
        Navigator.pushAndRemoveUntil(
            GlobalcontextService.navigatorKey.currentContext!,
            MaterialPageRoute(builder: (context) => const EnterNamePage()),
            (route) => false);
      } else {
        Navigator.pushAndRemoveUntil(
            GlobalcontextService.navigatorKey.currentContext!,
            MaterialPageRoute(builder: (context) => const HomePage()),
            (route) => false);
      }
    } else {
      Navigator.pushAndRemoveUntil(
          GlobalcontextService.navigatorKey.currentContext!,
          MaterialPageRoute(builder: (context) => const WelcomePage()),
          (route) => false);
    }
  }
}
