// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/formatters/phone_input_formatter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:starttech_qr/helpers/dialog.dart';
import 'package:starttech_qr/helpers/space.dart';
import 'package:starttech_qr/screens/auth/email_signup.dart';
import 'package:starttech_qr/screens/auth/verify_number.dart';
import 'package:starttech_qr/screens/tabbar_main.dart';
import 'package:starttech_qr/services/auth_service.dart';
import 'package:starttech_qr/services/firestore_service.dart';

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  TextEditingController controller = TextEditingController();
  bool isTextFieldTapped = false;
  bool isLoading = false;
  String verificationId = '';

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        getBody(context),
        loadingWidget(),
      ],
    );
  }

  numberField(BuildContext context) {
    return Row(
      children: [
        SpaceHelper.boslukWidth(context, 0.05),
        Expanded(
          child: CupertinoTextField(
            onTap: () {
              setState(() {
                isTextFieldTapped = true;
              });
            },
            onTapOutside: (_) {
              setState(() {
                isTextFieldTapped = false;
              });
              FocusScope.of(context).unfocus();
            },
            cursorColor: Colors.white,
            controller: controller,
            padding: const EdgeInsets.all(18.0),
            placeholder: '555 555 5555',
            placeholderStyle: GoogleFonts.poppins(
              color: Colors.white.withOpacity(0.3),
              fontWeight: FontWeight.w400,
              fontSize: MediaQuery.of(context).size.width * 0.038,
            ),
            prefix: Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: Text(
                '+90',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                  fontSize: MediaQuery.of(context).size.width * 0.04,
                ),
              ),
            ),
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w400,
              fontSize: MediaQuery.of(context).size.width * 0.04,
            ),
            inputFormatters: [
              PhoneInputFormatter(
                defaultCountryCode: 'TR',
              ),
            ],
            decoration: BoxDecoration(
              color: const Color(0xff1A1A1A),
              border: Border.all(
                color: isTextFieldTapped ? Colors.white : Colors.white54,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            prefixMode: OverlayVisibilityMode.always,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
          ),
        ),
        SpaceHelper.boslukWidth(context, 0.05),
      ],
    );
  }

  Future verifyPhoneNumber() async {
    try {
      setState(() {
        isLoading = true;
      });
      FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+90${controller.text.replaceAll(' ', '')}',
        verificationCompleted: (phonesAuthCredentials) async {
          debugPrint(phonesAuthCredentials.toString());
          setState(() {
            isLoading = false;
          });
        },
        verificationFailed: (verificationFailed) async {
          debugPrint(verificationFailed.message.toString());
          setState(() {
            isLoading = false;
          });
          DialogHelper.getCustomErrorDialog(
            title: 'Error',
            subtitle: verificationFailed.message.toString(),
          );
        },
        codeSent: (verificationId, resendingToken) async {
          debugPrint(verificationId);
          setState(() {
            isLoading = false;
            this.verificationId = verificationId;
          });
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => VerifyNumberPage(
                verificationId: verificationId,
                phoneNumber: '+90 ${controller.text}',
              ),
              fullscreenDialog: true,
            ),
          );
        },
        codeAutoRetrievalTimeout: (verificationId) async {
          debugPrint(verificationId);
          setState(() {
            isLoading = false;
          });
          DialogHelper.getCustomErrorDialog(
            title: 'Error',
            subtitle: 'Kod otomatik olarak alınamadı.',
          );
        },
      );
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      debugPrint("hata: $e");
      DialogHelper.getCustomErrorDialog(
        title: 'Error',
        subtitle: e.toString(),
      );
    }
  }

  void signInWithGoogle() async {
    try {
      setState(() {
        isLoading = true;
      });
      await AuthService().signInWithGoogle();

      bool userExists = await FirestoreService().checkUserWithUid(
        FirebaseAuth.instance.currentUser!.uid,
      );
      if (userExists) {
        setState(() {
          isLoading = false;
        });
        Navigator.pushAndRemoveUntil(
          context,
          CupertinoPageRoute(
            builder: (context) => const TabBarMain(),
          ),
          (route) => false,
        );
      } else {
        User? user = FirebaseAuth.instance.currentUser;
        await FirestoreService().addUserToFirestore(
          uid: user!.uid,
          email: user.email.toString(),
          name: user.displayName.toString(),
          phoneNumber: user.phoneNumber.toString(),
          photoUrl: user.photoURL.toString(),
        );

        setState(() {
          isLoading = false;
        });
        Navigator.pushAndRemoveUntil(
          context,
          CupertinoPageRoute(
            builder: (context) => const TabBarMain(),
          ),
          (route) => false,
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      DialogHelper.getCustomErrorDialog(
        subtitle: e.toString(),
      );
    }
  }

  void signInWithGithub() async {
    try {
      setState(() {
        isLoading = true;
      });
      bool? signedIn = await AuthService().signInWithGithub();
      if (signedIn == true) {
        bool userExists = await FirestoreService().checkUserWithUid(
          FirebaseAuth.instance.currentUser!.uid,
        );
        if (userExists) {
          setState(() {
            isLoading = false;
          });
          Navigator.pushAndRemoveUntil(
            context,
            CupertinoPageRoute(
              builder: (context) => const TabBarMain(),
            ),
            (route) => false,
          );
        } else {
          User? user = FirebaseAuth.instance.currentUser;
          await FirestoreService().addUserToFirestore(
            uid: user!.uid,
            email: user.email.toString(),
            name: user.displayName.toString(),
            phoneNumber: user.phoneNumber.toString(),
            photoUrl: user.photoURL.toString(),
          );

          setState(() {
            isLoading = false;
          });
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
        DialogHelper.getCustomErrorDialog(
          subtitle: 'GitHub ile giriş yaparken bir hata oluştu.',
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      DialogHelper.getCustomErrorDialog(
        subtitle: e.toString(),
      );
    }
  }

  void signUpWithEmail() {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => const SignUpWithEmailPage(),
        fullscreenDialog: true,
      ),
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

  getBody(BuildContext context) {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          bigTitle(context),
          subtitle(context),
          SpaceHelper.boslukHeight(context, 0.03),
          textFieldLabel(context),
          SpaceHelper.boslukHeight(context, 0.008),
          numberField(context),
          SpaceHelper.boslukHeight(context, 0.03),
          signUpWithPhoneBtn(context),
          SpaceHelper.boslukHeight(context, 0.03),
          customDivider(context),
          SpaceHelper.boslukHeight(context, 0.03),
          signUpWithGithubBtn(context),
          SpaceHelper.boslukHeight(context, 0.03),
          signUpWithGoogleBtn(context),
          SpaceHelper.boslukHeight(context, 0.03),
          signUpWithEmailBtn(context),
        ],
      ),
    );
  }

  Row signUpWithEmailBtn(BuildContext context) {
    return Row(
      children: [
        SpaceHelper.boslukWidth(context, 0.05),
        ElevatedButton(
          onPressed: () {
            signUpWithEmail();
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
              const Icon(
                FontAwesomeIcons.envelope,
                color: Colors.black,
              ),
              SpaceHelper.boslukWidth(context, 0.05),
              Text(
                'E-posta ile Kayıt Ol',
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

  Row signUpWithGoogleBtn(BuildContext context) {
    return Row(
      children: [
        SpaceHelper.boslukWidth(context, 0.05),
        ElevatedButton(
          onPressed: () async {
            signInWithGoogle();
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
              const Icon(FontAwesomeIcons.google, color: Colors.black),
              SpaceHelper.boslukWidth(context, 0.05),
              Text(
                'Google ile Kayıt Ol',
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

  Row signUpWithGithubBtn(BuildContext context) {
    return Row(
      children: [
        SpaceHelper.boslukWidth(context, 0.05),
        ElevatedButton(
          onPressed: () async {
            signInWithGithub();
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
              const Icon(FontAwesomeIcons.github, color: Colors.black),
              SpaceHelper.boslukWidth(context, 0.05),
              Text(
                'GitHub ile Kayıt Ol',
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

  Row customDivider(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: Colors.white.withOpacity(0.1),
            indent: MediaQuery.of(context).size.width * 0.15,
            endIndent: MediaQuery.of(context).size.width * 0.05,
          ),
        ),
        Text(
          'YA DA',
          style: GoogleFonts.poppins(
            fontSize: MediaQuery.of(context).size.width * 0.03,
            fontWeight: FontWeight.w500,
            color: Colors.white.withOpacity(0.7),
          ),
        ),
        Expanded(
          child: Divider(
            color: Colors.white.withOpacity(0.1),
            endIndent: MediaQuery.of(context).size.width * 0.15,
            indent: MediaQuery.of(context).size.width * 0.05,
          ),
        ),
      ],
    );
  }

  Row signUpWithPhoneBtn(BuildContext context) {
    return Row(
      children: [
        SpaceHelper.boslukWidth(context, 0.05),
        ElevatedButton(
          onPressed: () {
            verifyPhoneNumber();
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
          child: Text(
            'Kayıt Ol',
            style: GoogleFonts.poppins(
              fontSize: MediaQuery.of(context).size.width * 0.035,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }

  Row textFieldLabel(BuildContext context) {
    return Row(
      children: [
        SpaceHelper.boslukWidth(context, 0.05),
        Text(
          'Telefon Numaran',
          style: GoogleFonts.poppins(
            fontSize: MediaQuery.of(context).size.width * 0.035,
            fontWeight: FontWeight.w400,
            color: Colors.white.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  Row subtitle(BuildContext context) {
    return Row(
      children: [
        SpaceHelper.boslukWidth(context, 0.05),
        Text(
          'Telefon numaranı girerek hesap oluştur.',
          style: GoogleFonts.poppins(
            fontSize: MediaQuery.of(context).size.width * 0.03,
            fontWeight: FontWeight.w400,
            color: Colors.white.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  Row bigTitle(BuildContext context) {
    return Row(
      children: [
        SpaceHelper.boslukWidth(context, 0.05),
        Text(
          'Hesap Oluştur',
          style: GoogleFonts.poppins(
            fontSize: MediaQuery.of(context).size.width * 0.07,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
