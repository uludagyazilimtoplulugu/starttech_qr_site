// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:starttech_qr/helpers/dialog.dart';
import 'package:starttech_qr/helpers/space.dart';
import 'package:starttech_qr/screens/tabbar_main.dart';
import 'package:starttech_qr/services/firestore_service.dart';

class EnterNamePage extends ConsumerStatefulWidget {
  const EnterNamePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EnterNamePageState();
}

class _EnterNamePageState extends ConsumerState<EnterNamePage> {
  TextEditingController controller = TextEditingController();
  bool isTextFieldTapped = false;
  bool isLoading = false;

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
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            : null,
      ),
      body: Column(
        children: [
          title(context),
          SpaceHelper.boslukHeight(context, 0.007),
          subtitle(context),
          SpaceHelper.boslukHeight(context, 0.02),
          nameField(context),
          SpaceHelper.boslukHeight(context, 0.05),
          continueBtn(context),
        ],
      ),
    );
  }

  Row continueBtn(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.05,
        ),
        ElevatedButton(
          onPressed: () {
            sendData();
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
                'Devam Et',
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

  Row nameField(BuildContext context) {
    return Row(
      children: [
        SpaceHelper.boslukWidth(context, 0.05),
        Expanded(
          child: CupertinoTextField(
            placeholder: 'Elon Bumsk',
            placeholderStyle: GoogleFonts.poppins(
              color: Colors.white.withOpacity(0.3),
              fontWeight: FontWeight.w400,
              fontSize: MediaQuery.of(context).size.width * 0.038,
            ),
            cursorColor: Colors.white,
            controller: controller,
            padding: const EdgeInsets.all(18.0),
            onTap: () {
              setState(() {
                isTextFieldTapped = true;
              });
            },
            decoration: BoxDecoration(
              color: const Color(0xff1A1A1A),
              border: Border.all(
                color: isTextFieldTapped ? Colors.white : Colors.white54,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            onTapOutside: (_) {
              setState(() {
                isTextFieldTapped = false;
              });
              FocusScope.of(context).unfocus();
            },
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w400,
              fontSize: MediaQuery.of(context).size.width * 0.04,
            ),
            prefixMode: OverlayVisibilityMode.always,
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
        Expanded(
          child: Text(
            'QR kodunu okutanların seni tanıyabilmesi için adını gir. (Bu adı daha sonra değiştirebilirsin.)',
            overflow: TextOverflow.clip,
            style: GoogleFonts.poppins(
              fontSize: MediaQuery.of(context).size.width * 0.03,
              fontWeight: FontWeight.w400,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ),
        SpaceHelper.boslukWidth(context, 0.05),
      ],
    );
  }

  Row title(BuildContext context) {
    return Row(
      children: [
        SpaceHelper.boslukWidth(context, 0.05),
        Text(
          'Adını Gir',
          style: GoogleFonts.poppins(
            fontSize: MediaQuery.of(context).size.width * 0.07,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  sendData() async {
    setState(() {
      isTextFieldTapped = false;
    });
    if (controller.text.isEmpty) {
      DialogHelper.getCustomErrorDialog(
        subtitle: "Adını yazmazsan QR kodunu okutanlar seni tanıyamaz.",
      );
    } else if (controller.text.length < 3) {
      DialogHelper.getCustomErrorDialog(
        subtitle: "Adın en az 3 karakter olmalıdır.",
      );
    } else {
      try {
        setState(() {
          isLoading = true;
        });
        // user reload
        await FirebaseAuth.instance.currentUser!.reload();
        User? user = FirebaseAuth.instance.currentUser;
        user!.updateDisplayName(controller.text);
        user.updatePhotoURL(
          "https://api.dicebear.com/7.x/adventurer-neutral/png?seed=${user.uid}",
        );
        await FirestoreService().addUserToFirestore(
          uid: user.uid,
          email: user.email.toString(),
          name: controller.text,
          phoneNumber: user.phoneNumber.toString(),
          photoUrl:
              "https://api.dicebear.com/7.x/adventurer-neutral/png?seed=${user.uid}",
        );
        setState(() {
          isLoading = false;
        });
        Navigator.pushAndRemoveUntil(
          context,
          CupertinoPageRoute(builder: (context) => const TabBarMain()),
          (route) => false,
        );
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        DialogHelper.getCustomErrorDialog(
          subtitle: e.toString(),
        );
      }
    }
  }
}
