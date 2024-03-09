import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:starttech_qr/main.dart';
import 'package:starttech_qr/models/user.dart';
import 'package:starttech_qr/screens/auth/enter_name.dart';
import 'package:starttech_qr/screens/auth/welcome_page.dart';
import 'package:starttech_qr/screens/tabbar_main.dart';
import 'package:starttech_qr/services/firestore_service.dart';

class MobilYonlendirmePage extends StatefulWidget {
  const MobilYonlendirmePage({super.key});

  @override
  State<MobilYonlendirmePage> createState() => _MobilYonlendirmePageState();
}

class _MobilYonlendirmePageState extends State<MobilYonlendirmePage> {
  
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
      bool userExists = await FirestoreService().checkUserWithUid(user.uid);
      if (userExists) {
        FirestoreUser? firestoreUser = await FirestoreService().getUser(
          uid: user.uid,
        );

        debugPrint('firestoreUser name: ${firestoreUser!.name}');
        if (firestoreUser.name == 'null' || firestoreUser.name.isEmpty) {
          Navigator.pushAndRemoveUntil(
            GlobalcontextService.navigatorKey.currentContext!,
            CupertinoPageRoute(builder: (context) => const EnterNamePage()),
            (route) => false,
          );
        } else {
          Navigator.pushAndRemoveUntil(
            GlobalcontextService.navigatorKey.currentContext!,
            CupertinoPageRoute(builder: (context) => const TabBarMain()),
            (route) => false,
          );
        }
      } else {
        Navigator.pushAndRemoveUntil(
          GlobalcontextService.navigatorKey.currentContext!,
          CupertinoPageRoute(builder: (context) => const EnterNamePage()),
          (route) => false,
        );
      }
    } else {
      Navigator.pushAndRemoveUntil(
        GlobalcontextService.navigatorKey.currentContext!,
        CupertinoPageRoute(builder: (context) => const WelcomePage()),
        (route) => false,
      );
    }
  }
}
