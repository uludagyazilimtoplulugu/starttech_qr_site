// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:starttech_qr/helpers/dialog.dart';
import 'package:starttech_qr/helpers/space.dart';
import 'package:starttech_qr/services/firestore_service.dart';

class FeedbackPage extends ConsumerStatefulWidget {
  const FeedbackPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends ConsumerState<FeedbackPage> {
  bool isLoading = false;
  TextEditingController feedbackController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xff1A1A1A),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Geri Bildirim',
          style: GoogleFonts.poppins(
            fontSize: MediaQuery.of(context).size.width * 0.05,
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
          body(context),
          loadingWidget(),
        ],
      ),
    );
  }

  SingleChildScrollView body(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SpaceHelper.boslukHeight(context, 0.05),
          textfield(context),
          SpaceHelper.boslukHeight(context, 0.05),
          sendBtn(context),
        ],
      ),
    );
  }

  ElevatedButton sendBtn(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        minimumSize: Size(
          MediaQuery.of(context).size.width * 0.9,
          MediaQuery.of(context).size.height * 0.07,
        ),
      ),
      onPressed: () async {
        if (feedbackController.text.isEmpty) {
          DialogHelper.getCustomErrorDialog(
            subtitle: 'Lütfen geri bildirim yazın.',
          );
          return;
        }
        try {
          setState(() {
            isLoading = true;
          });
          await FirestoreService().sendFeedback(
            uid: FirebaseAuth.instance.currentUser!.uid,
            feedback: feedbackController.text,
          );
          setState(() {
            isLoading = false;
          });
          feedbackController.clear();
          Navigator.pop(context);
          DialogHelper.getCustomSuccessDialog(
              subtitle: 'Geri bildiriminiz alınmıştır. Teşekkür ederiz.');
        } catch (e) {
          setState(() {
            isLoading = false;
          });
          DialogHelper.getCustomErrorDialog(
            subtitle: 'Bir hata oluştu. Lütfen tekrar deneyin.',
          );
        }
      },
      child: Text(
        'Gönder',
        style: GoogleFonts.poppins(
          fontSize: MediaQuery.of(context).size.width * 0.04,
          fontWeight: FontWeight.w400,
          color: Colors.white,
        ),
      ),
    );
  }

  Padding textfield(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.05,
      ),
      child: TextFormField(
        controller: feedbackController,
        cursorColor: Colors.white,
        onTapOutside: (_) {
          FocusScope.of(context).unfocus();
        },
        decoration: InputDecoration(
          hintText: 'Geri bildirim yazın.',
          hintStyle: GoogleFonts.poppins(
            fontSize: MediaQuery.of(context).size.width * 0.04,
            fontWeight: FontWeight.w400,
            color: Colors.grey,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Colors.grey,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Colors.white70,
            ),
          ),
        ),
        maxLines: 10,
        minLines: 5,
        style: GoogleFonts.poppins(
          fontSize: MediaQuery.of(context).size.width * 0.04,
          fontWeight: FontWeight.w400,
          color: Colors.white,
        ),
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
}
