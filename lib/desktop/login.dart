// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:starttech_qr/desktop/desktop_main.dart';
import 'package:starttech_qr/helpers/dialog.dart';
import 'package:starttech_qr/helpers/space.dart';
import 'package:starttech_qr/services/auth_service.dart';

class DesktopAdminLoginPage extends ConsumerStatefulWidget {
  const DesktopAdminLoginPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DesktopAdminLoginPageState();
}

class _DesktopAdminLoginPageState extends ConsumerState<DesktopAdminLoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xff1A1A1A),
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Giriş Yap',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
        backgroundColor:
            isLoading ? Colors.black.withOpacity(0.5) : const Color(0xff1A1A1A),
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            : null,
      ),
      body: Stack(
        children: [
          getBody(context),
          loadingWidget(),
        ],
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          textFieldLabel(context, 'Mail'),
          SpaceHelper.boslukHeight(context, 0.008),
          emailField(context),
          SpaceHelper.boslukHeight(context, 0.03),
          textFieldLabel(context, 'Şifre'),
          SpaceHelper.boslukHeight(context, 0.008),
          passwordField(context),
          SpaceHelper.boslukHeight(context, 0.03),
          signUpBtn(context),
        ],
      ),
    );
  }

  passwordField(BuildContext context) {
    return Row(
      children: [
        SpaceHelper.boslukWidth(context, 0.35),
        Expanded(
          child: CupertinoTextField(
            obscureText: true,
            // eye icon

            cursorColor: Colors.white,
            controller: passwordController,
            padding: const EdgeInsets.all(18.0),
            placeholder: 'Şifreni Gir',
            placeholderStyle: GoogleFonts.poppins(
              color: Colors.white.withOpacity(0.3),
              fontWeight: FontWeight.w400,
            ),
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w400,
            ),
            decoration: BoxDecoration(
              color: const Color(0xff1A1A1A),
              border: Border.all(
                color: Colors.white,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            prefixMode: OverlayVisibilityMode.always,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
          ),
        ),
        SpaceHelper.boslukWidth(context, 0.35),
      ],
    );
  }

  Row textFieldLabel(BuildContext context, String text) {
    return Row(
      children: [
        SpaceHelper.boslukWidth(context, 0.35),
        Text(
          text,
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w400,
            color: Colors.white.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  emailField(BuildContext context) {
    return Row(
      children: [
        SpaceHelper.boslukWidth(context, 0.35),
        Expanded(
          child: CupertinoTextField(
            onTap: () {
              setState(() {});
            },
            onTapOutside: (_) {
              setState(() {});
              FocusScope.of(context).unfocus();
            },
            cursorColor: Colors.white,
            controller: emailController,
            padding: const EdgeInsets.all(18.0),
            placeholder: 'Mail Adresini Gir',
            placeholderStyle: GoogleFonts.poppins(
              color: Colors.white.withOpacity(0.3),
              fontWeight: FontWeight.w400,
            ),
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w400,
            ),
            decoration: BoxDecoration(
              color: const Color(0xff1A1A1A),
              border: Border.all(
                color: Colors.white,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            prefixMode: OverlayVisibilityMode.always,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
          ),
        ),
        SpaceHelper.boslukWidth(context, 0.35),
      ],
    );
  }

  Row signUpBtn(BuildContext context) {
    return Row(
      children: [
        SpaceHelper.boslukWidth(context, 0.35),
        ElevatedButton(
          onPressed: () {
            if (emailController.text.isEmpty ||
                passwordController.text.isEmpty) {
              DialogHelper.getCustomErrorDialog(
                subtitle: 'Lütfen tüm alanları doldurun.',
              );
              return;
            }
            if (emailController.text != 'admin@uludagdev.org') {
              DialogHelper.getCustomErrorDialog(
                subtitle: 'Böyle bir admin bulunmamaktadır.',
              );
              return;
            }

            login();
          },
          style: ElevatedButton.styleFrom(
            side: const BorderSide(
              color: Colors.white,
              width: 1,
            ),
            foregroundColor: Colors.white,
            backgroundColor: Colors.white,
            fixedSize: Size(
              MediaQuery.of(context).size.width * 0.3,
              MediaQuery.of(context).size.height * 0.055,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Text(
            'Giriş Yap',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ),
        SpaceHelper.boslukWidth(context, 0.35),
      ],
    );
  }

  void login() async {
    try {
      setState(() {
        isLoading = true;
      });
      debugPrint("email: ${emailController.text}");
      debugPrint("password: ${passwordController.text}");

      bool? result = await AuthService().signInWithEmailandPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      setState(() {
        isLoading = false;
      });
      if (result == true) {
        Navigator.pushAndRemoveUntil(
          context,
          CupertinoPageRoute(
            builder: (context) => const DesktopMainPage(),
          ),
          (route) => false,
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      debugPrint("login error: $e");
    }
  }
}
