// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:starttech_qr/helpers/dialog.dart';
import 'package:starttech_qr/helpers/space.dart';
import 'package:starttech_qr/screens/auth/enter_name.dart';
import 'package:starttech_qr/screens/auth/welcome_page.dart';
import 'package:starttech_qr/screens/tabbar_main.dart';
import 'package:starttech_qr/services/firestore_service.dart';

class VerifyNumberPage extends ConsumerStatefulWidget {
  final String phoneNumber;
  final String verificationId;
  const VerifyNumberPage(
      {super.key, required this.phoneNumber, required this.verificationId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _VerifyNumberPageState();
}

class _VerifyNumberPageState extends ConsumerState<VerifyNumberPage> {
  TextEditingController controller = TextEditingController();
  bool isLoading = false;
  String verificationId = '';

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        body(context),
        loadingWidget(),
      ],
    );
  }

  Widget loadingWidget() {
    return isLoading
        ? Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Colors.black.withOpacity(0.5),
            child: const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
          )
        : const SizedBox();
  }

  Scaffold body(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xff1A1A1A),
      appBar: AppBar(
        backgroundColor: const Color(0xff1A1A1A),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          title(context),
          SpaceHelper.boslukHeight(context, 0.007),
          subtitle(context),
          SpaceHelper.boslukHeight(context, 0.05),
          pinfield(),
          SpaceHelper.boslukHeight(context, 0.02),
          validateBtn(context)
        ],
      ),
    );
  }

  Row validateBtn(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.05,
        ),
        ElevatedButton(
          onPressed: () {
            sendCodeToFirebase();
          },
          style: ElevatedButton.styleFrom(
            side: const BorderSide(
              color: Colors.white,
              width: 1,
            ),
            foregroundColor: Colors.white,
            backgroundColor: Colors.white,
            fixedSize: Size(
              MediaQuery.of(context).size.width * 0.9,
              MediaQuery.of(context).size.height * 0.07,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.05,
              ),
              Text(
                'Doğrula',
                style: GoogleFonts.poppins(
                  fontSize: MediaQuery.of(context).size.width * 0.035,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Row subtitle(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.05,
        ),
        Text(
          'Telefon numaranıza gönderilen 6 haneli kodu girin.',
          style: GoogleFonts.poppins(
            fontSize: MediaQuery.of(context).size.width * 0.03,
            fontWeight: FontWeight.w400,
            color: Colors.white.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  Row title(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.05,
        ),
        Text(
          'Kodu Gir',
          style: GoogleFonts.poppins(
            fontSize: MediaQuery.of(context).size.width * 0.07,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  pinfield() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.1,
      ),
      child: PinCodeTextField(
        cursorColor: Colors.white,
        controller: controller,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
        autoFocus: true,
        appContext: context,
        length: 6,
        obscureText: false,
        animationType: AnimationType.fade,
        pinTheme: PinTheme(
          shape: PinCodeFieldShape.underline,
          activeColor: Colors.white,
          selectedColor: Colors.white,
          inactiveColor: Colors.white30,
          activeFillColor: Colors.white,
        ),
        animationDuration: const Duration(milliseconds: 200),
        // enableActiveFill: true,
        textStyle: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: MediaQuery.of(context).size.width * 0.06,
          fontWeight: FontWeight.w600,
        ),
        onChanged: (value) {},
        beforeTextPaste: (text) {
          return false;
        },
      ),
    );
  }

  sendCodeToFirebase() async {
    if (controller.text.length != 6) {
      DialogHelper.getCustomErrorDialog(
        subtitle: 'Kod 6 haneli olmalıdır.',
      );
      return;
    }
    try {
      setState(() {
        isLoading = true;
      });
      debugPrint('Verification ID: ${widget.verificationId}');
      debugPrint('Code: ${controller.text}');
      await FirebaseAuth.instance
          .signInWithCredential(PhoneAuthProvider.credential(
              verificationId: widget.verificationId, smsCode: controller.text))
          .then((value) async {
        if (value.user != null) {
          // await FirebaseAuth.instance.signInWithPhoneNumber(
          //   widget.phoneNumber.replaceAll(' ', ''),
          // );
          setState(() {
            isLoading = false;
          });
          // if there is not a user in firestore with the same phone number, go to enter name page
          bool userExists = await FirestoreService().checkUserWithUid(
            FirebaseAuth.instance.currentUser!.uid,
          );
          if (!userExists) {
            Navigator.pushAndRemoveUntil(
              context,
              CupertinoPageRoute(
                builder: (context) => const EnterNamePage(),
              ),
              (route) => false,
            );
          } else {
            // if there is a user in firestore with the same phone number, go to home page
            Navigator.pushAndRemoveUntil(
              context,
              CupertinoPageRoute(
                builder: (context) => const TabBarMain(),
              ),
              (route) => false,
            );
          }
        } else {
          setState(() {
            isLoading = false;
          });

          Navigator.pushAndRemoveUntil(
            context,
            CupertinoPageRoute(
              builder: (context) => const WelcomePage(),
            ),
            (route) => false,
          );
        }
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      debugPrint('Error: $e');

      if (e.toString().contains("invalid-verification-code")) {
        // show error dialog
        DialogHelper.getCustomErrorDialog(
          subtitle: 'Kod hatalı. Lütfen tekrar deneyin.',
        );
      } else {
        DialogHelper.getCustomErrorDialog();
      }
    }
  }
}
