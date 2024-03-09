import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:starttech_qr/desktop/welcome_page.dart';
import 'package:starttech_qr/main.dart';

class DesktopYonlendirmePage extends ConsumerStatefulWidget {
  const DesktopYonlendirmePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DesktopYonlendirmePageState();
}

class _DesktopYonlendirmePageState
    extends ConsumerState<DesktopYonlendirmePage> {
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
      debugPrint('cikis yapildi');
      await FirebaseAuth.instance.signOut();
    }
    Navigator.pushAndRemoveUntil(
      GlobalcontextService.navigatorKey.currentContext!,
      CupertinoPageRoute(builder: (context) => const DesktopWelcomePage()),
      (route) => false,
    );
  }
}
