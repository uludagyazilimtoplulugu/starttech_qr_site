import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_multi_formatter/formatters/phone_input_formatter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:starttech_qr/auth/verify_number.dart';

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
  String err = '';

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
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
              Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.05,
                  ),
                  Text(
                    'Hesap Oluştur',
                    style: GoogleFonts.poppins(
                      fontSize: MediaQuery.of(context).size.width * 0.07,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.05,
                  ),
                  Text(
                    'Telefon numaranı girerek hesap oluştur.',
                    style: GoogleFonts.poppins(
                      fontSize: MediaQuery.of(context).size.width * 0.03,
                      fontWeight: FontWeight.w400,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.05,
                  ),
                  Text(
                    'Telefon Numaran',
                    style: GoogleFonts.poppins(
                      fontSize: MediaQuery.of(context).size.width * 0.035,
                      fontWeight: FontWeight.w400,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.008,
              ),
              numberField(context),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.05,
                  ),
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
              ),
              Text(err),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              Row(
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
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.05,
                  ),
                  ElevatedButton(
                    onPressed: () {},
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
                        const Icon(FontAwesomeIcons.github,
                            color: Colors.black),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.05,
                        ),
                        Text(
                          'Github ile Kayıt Ol',
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
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.05,
                  ),
                  ElevatedButton(
                    onPressed: () {},
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
                        const Icon(FontAwesomeIcons.google,
                            color: Colors.black),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.05,
                        ),
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
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              // sign in with apple button
              Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.05,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // sign out
                      FirebaseAuth.instance.signOut();
                      debugPrint('sign out');
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
                        const Icon(FontAwesomeIcons.apple, color: Colors.black),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.05,
                        ),
                        Text(
                          'Apple ile Kayıt Ol',
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
              ),
            ],
          ),
        ),
        isLoading
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
            : const SizedBox(),
      ],
    );
  }

  numberField(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.05,
        ),
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
              color: Colors.white.withOpacity(0.5),
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
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.05,
        ),
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
          // DialogHelper().cupertinoDialog(
          //   title: 'Error',
          //   subtitle: verificationFailed.message.toString(),
          // );
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
            ),
          );
        },
        codeAutoRetrievalTimeout: (verificationId) async {
          debugPrint(verificationId);
          setState(() {
            isLoading = false;
          });
          // DialogHelper().cupertinoDialog(
          //   title: 'Error',
          //   subtitle: 'Code auto retrieval timeout.',
          // );
        },
      );
    } catch (e) {
      setState(() {
        isLoading = false;
        err = e.toString();
      });
      debugPrint("hata: $e");
      // DialogHelper().cupertinoDialog(
      //   title: 'Error',
      //   subtitle: e.toString(),
      // );
    }
  }
}
