// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:starttech_qr/helpers/dialog.dart';
import 'package:starttech_qr/helpers/space.dart';
import 'package:starttech_qr/screens/auth/signup.dart';
import 'package:starttech_qr/screens/tabbar_main.dart';
import 'package:starttech_qr/services/auth_service.dart';

class SignInWithEmailPage extends ConsumerStatefulWidget {
  const SignInWithEmailPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SignInWithEmailPageState();
}

class _SignInWithEmailPageState extends ConsumerState<SignInWithEmailPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isLoading = false;
  bool isPasswordVisible = false;
  bool isMailFieldTapped = false;
  bool isPasswordFieldTapped = false;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        getBody(context),
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

  getBody(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xff1A1A1A),
      appBar: AppBar(
        backgroundColor: const Color(0xff1A1A1A),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          bigTitle(context),
          subtitle(context),
          SpaceHelper.boslukHeight(context, 0.03),
          textFieldLabel(context, 'Mail'),
          SpaceHelper.boslukHeight(context, 0.008),
          emailField(context),
          SpaceHelper.boslukHeight(context, 0.03),
          textFieldLabel(context, 'Şifre'),
          SpaceHelper.boslukHeight(context, 0.008),
          passwordField(context),
          SpaceHelper.boslukHeight(context, 0.03),
          signUpBtn(context),
          SpaceHelper.boslukHeight(context, 0.008),
          loginText(context),
        ],
      ),
    );
  }

  // emailField
  emailField(BuildContext context) {
    return Row(
      children: [
        SpaceHelper.boslukWidth(context, 0.05),
        Expanded(
          child: CupertinoTextField(
            onTap: () {
              setState(() {
                isMailFieldTapped = true;

                isPasswordFieldTapped = false;
              });
            },
            onTapOutside: (_) {
              setState(() {
                isMailFieldTapped = false;

                isPasswordFieldTapped = false;
              });
              FocusScope.of(context).unfocus();
            },
            cursorColor: Colors.white,
            controller: emailController,
            padding: const EdgeInsets.all(18.0),
            placeholder: 'Mail Adresini Gir',
            placeholderStyle: GoogleFonts.poppins(
              color: Colors.white.withOpacity(0.3),
              fontWeight: FontWeight.w400,
              fontSize: MediaQuery.of(context).size.width * 0.038,
            ),
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w400,
              fontSize: MediaQuery.of(context).size.width * 0.04,
            ),
            decoration: BoxDecoration(
              color: const Color(0xff1A1A1A),
              border: Border.all(
                color: isMailFieldTapped ? Colors.white : Colors.white54,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            prefixMode: OverlayVisibilityMode.always,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
          ),
        ),
        SpaceHelper.boslukWidth(context, 0.05),
      ],
    );
  }

  Row signUpBtn(BuildContext context) {
    return Row(
      children: [
        SpaceHelper.boslukWidth(context, 0.05),
        ElevatedButton(
          onPressed: () {
            signUp();
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
            'Giriş Yap',
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

  signUp() async {
    if (emailController.text.isEmpty) {
      DialogHelper.getCustomErrorDialog(
        subtitle: "Mail adresini yazmalısın.",
      );
      return;
    }

    if (!emailController.text.contains('@') ||
        !emailController.text.contains('.') ||
        emailController.text.length < 6 ||
        emailController.text.endsWith('.')) {
      DialogHelper.getCustomErrorDialog(
        subtitle: "Mail adresin geçerli değil.",
      );
      return;
    }
    if (passwordController.text.isEmpty) {
      DialogHelper.getCustomErrorDialog(
        subtitle: "Şifreni yazmalısın.",
      );
      return;
    }
    if (passwordController.text.length < 6) {
      DialogHelper.getCustomErrorDialog(
        subtitle: "Şifren en az 6 karakter olmalıdır.",
      );
      return;
    }

    try {
      setState(() {
        isLoading = true;
        isMailFieldTapped = false;
        isPasswordFieldTapped = false;
      });

      debugPrint("email: ${emailController.text}");
      debugPrint("password: ${passwordController.text}");

      bool? result = await AuthService().signInWithEmailandPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      await FirebaseAuth.instance.currentUser!.reload();
      User? user = FirebaseAuth.instance.currentUser;
      await user!.reload();

      await FirebaseAuth.instance.currentUser!.reload();
      await user.reload();

      setState(() {
        isLoading = false;
      });
      if (result == true) {
        Navigator.pushAndRemoveUntil(
          context,
          CupertinoPageRoute(
            builder: (context) => const TabBarMain(),
          ),
          (route) => false,
        );
      } else {
        DialogHelper.getCustomErrorDialog(
          subtitle: "Giriş yapılamadı.",
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      debugPrint("e: $e");
    }
  }

  // passwordField
  passwordField(BuildContext context) {
    return Row(
      children: [
        SpaceHelper.boslukWidth(context, 0.05),
        Expanded(
          child: CupertinoTextField(
            onTap: () {
              setState(() {
                isPasswordFieldTapped = true;
                isMailFieldTapped = false;
              });
            },
            onTapOutside: (_) {
              setState(() {
                isPasswordFieldTapped = false;
                isMailFieldTapped = false;
              });
              FocusScope.of(context).unfocus();
            },
            obscureText: !isPasswordVisible,
            // eye icon
            suffix: IconButton(
              onPressed: () {
                setState(() {
                  isPasswordVisible = !isPasswordVisible;
                });
              },
              icon: Icon(
                isPasswordVisible
                    ? Icons.visibility
                    : Icons.visibility_off_outlined,
                color: Colors.white.withOpacity(0.5),
              ),
            ),
            cursorColor: Colors.white,
            controller: passwordController,
            padding: const EdgeInsets.all(18.0),
            placeholder: 'Şifreni Gir',
            placeholderStyle: GoogleFonts.poppins(
              color: Colors.white.withOpacity(0.3),
              fontWeight: FontWeight.w400,
              fontSize: MediaQuery.of(context).size.width * 0.038,
            ),
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w400,
              fontSize: MediaQuery.of(context).size.width * 0.04,
            ),
            decoration: BoxDecoration(
              color: const Color(0xff1A1A1A),
              border: Border.all(
                color: isPasswordFieldTapped ? Colors.white : Colors.white54,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            prefixMode: OverlayVisibilityMode.always,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
          ),
        ),
        SpaceHelper.boslukWidth(context, 0.05),
      ],
    );
  }

  Row subtitle(BuildContext context) {
    return Row(
      children: [
        SpaceHelper.boslukWidth(context, 0.05),
        Text(
          'Mail adresini girerek giriş yap.',
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
          'Giriş Yap',
          style: GoogleFonts.poppins(
            fontSize: MediaQuery.of(context).size.width * 0.07,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Row textFieldLabel(BuildContext context, String text) {
    return Row(
      children: [
        SpaceHelper.boslukWidth(context, 0.05),
        Text(
          text,
          style: GoogleFonts.poppins(
            fontSize: MediaQuery.of(context).size.width * 0.035,
            fontWeight: FontWeight.w400,
            color: Colors.white.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  loginText(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Hesabın yok mu?',
          style: GoogleFonts.poppins(
            fontSize: MediaQuery.of(context).size.width * 0.035,
            fontWeight: FontWeight.w400,
            color: Colors.white.withOpacity(0.8),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => const SignUpPage(),
              ),
            );
          },
          child: Text(
            'Kayıt Ol',
            style: GoogleFonts.poppins(
              fontSize: MediaQuery.of(context).size.width * 0.035,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
