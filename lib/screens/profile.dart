// ignore_for_file: use_build_context_synchronously

import 'dart:js' as js;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:starttech_qr/helpers/space.dart';
import 'package:starttech_qr/main.dart';
import 'package:starttech_qr/screens/auth/welcome_page.dart';
import 'package:starttech_qr/screens/edit_profile.dart';
import 'package:starttech_qr/screens/profile_qr/scanned_qrs.dart';
import 'package:starttech_qr/services/firestore_service.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xff1A1A1A),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
            ),
            SpaceHelper.boslukHeight(context, 0.05),
            img(context),
            SpaceHelper.boslukHeight(context, 0.02),
            title(context),
            StreamBuilder(
              stream: FirestoreService()
                  .streamPoint(uid: FirebaseAuth.instance.currentUser!.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  return Text(
                    "Puanın: ${snapshot.data}",
                    style: GoogleFonts.poppins(
                      color: Colors.white70,
                      fontSize: MediaQuery.of(context).size.width * 0.04,
                      fontWeight: FontWeight.w400,
                    ),
                  );
                } else {
                  return const SizedBox();
                }
              },
            ),
            SpaceHelper.boslukHeight(context, 0.01),
            subtitle(context),
            SpaceHelper.boslukHeight(context, 0.05),
            settings1text(context),
            SpaceHelper.boslukHeight(context, 0.01),
            settings1container(context),
            SpaceHelper.boslukHeight(context, 0.05),
            settings2text(context),
            SpaceHelper.boslukHeight(context, 0.01),
            settings2container(context),
            SpaceHelper.boslukHeight(context, 0.01),
            settings2subtext(context),
            SpaceHelper.boslukHeight(context, 0.05),
            signOutBtn(context),
            SpaceHelper.boslukHeight(context, 0.05),
            builtByText(context),
            SpaceHelper.boslukHeight(context, 0.1),
          ],
        ),
      ),
    );
  }

  RichText builtByText(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: [
          TextSpan(
            text: 'Built with ',
            style: GoogleFonts.poppins(
              color: Colors.white70,
              fontSize: MediaQuery.of(context).size.width * 0.04,
              fontWeight: FontWeight.w400,
            ),
          ),
          TextSpan(
            // heart emoji
            text: '❤️',
            style: GoogleFonts.poppins(
              color: Colors.blue,
              fontSize: MediaQuery.of(context).size.width * 0.04,
              fontWeight: FontWeight.w400,
            ),
          ),
          TextSpan(
            text: ' and ',
            style: GoogleFonts.poppins(
              color: Colors.white70,
              fontSize: MediaQuery.of(context).size.width * 0.04,
              fontWeight: FontWeight.w400,
            ),
          ),
          TextSpan(
            // coffee
            text: '☕',
            style: GoogleFonts.poppins(
              color: Colors.blue,
              fontSize: MediaQuery.of(context).size.width * 0.04,
              fontWeight: FontWeight.w400,
            ),
          ),
          TextSpan(
            text: '\nby ',
            style: GoogleFonts.poppins(
              color: Colors.white70,
              fontSize: MediaQuery.of(context).size.width * 0.04,
              fontWeight: FontWeight.w400,
            ),
          ),
          WidgetSpan(
            child: GestureDetector(
              onTap: () async {
                js.context.callMethod('open', ['https://meliharik.dev']);
              },
              child: Text(
                'Melih',
                style: GoogleFonts.poppins(
                  decoration: TextDecoration.underline,
                  color: Colors.blue,
                  fontSize: MediaQuery.of(context).size.width * 0.04,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  ElevatedButton signOutBtn(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        await FirebaseAuth.instance.signOut();
        Navigator.pushAndRemoveUntil(
          GlobalcontextService.navigatorKey.currentContext!,
          CupertinoPageRoute(
            builder: (context) => const WelcomePage(),
          ),
          (route) => false,
        );
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.redAccent,
        backgroundColor: Colors.redAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        fixedSize: Size(
          MediaQuery.of(context).size.width * 0.9,
          MediaQuery.of(context).size.height * 0.06,
        ),
      ),
      child: Text(
        'Çıkış Yap',
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: MediaQuery.of(context).size.width * 0.04,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Row settings2subtext(BuildContext context) {
    return Row(
      children: [
        SpaceHelper.boslukWidth(context, 0.07),
        Expanded(
          child: Text(
            'Bizi sosyal medyadan takip etmeyi unutmayın!',
            overflow: TextOverflow.clip,
            style: GoogleFonts.poppins(
              color: Colors.white54,
              fontSize: MediaQuery.of(context).size.width * 0.034,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
        SpaceHelper.boslukWidth(context, 0.07),
      ],
    );
  }

  Row settings2container(BuildContext context) {
    return Row(
      children: [
        SpaceHelper.boslukWidth(context, 0.04),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey.withOpacity(0.07),
            ),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    js.context
                        .callMethod('open', ['https://linktr.ee/uludagdev']);
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 13, 8, 8),
                    child: Row(
                      children: [
                        SpaceHelper.boslukWidth(context, 0.03),
                        Text(
                          'Uludağ Yazılım Topluluğu',
                          overflow: TextOverflow.clip,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: MediaQuery.of(context).size.width * 0.036,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        // ios forward button
                        const Spacer(),
                        const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white54,
                          size: 15,
                        ),
                        SpaceHelper.boslukWidth(context, 0.03),
                      ],
                    ),
                  ),
                ),
                Divider(
                  indent: MediaQuery.of(context).size.width * 0.03,
                ),
                GestureDetector(
                  onTap: () {
                    js.context.callMethod(
                        'open', ['https://www.instagram.com/gdsculudag']);
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 3, 8, 13),
                    child: Row(
                      children: [
                        SpaceHelper.boslukWidth(context, 0.03),
                        Text(
                          'GDSC Uludağ',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: MediaQuery.of(context).size.width * 0.038,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const Spacer(),
                        const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white54,
                          size: 15,
                        ),
                        SpaceHelper.boslukWidth(context, 0.03),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        SpaceHelper.boslukWidth(context, 0.04),
      ],
    );
  }

  Row settings2text(BuildContext context) {
    return Row(
      children: [
        SpaceHelper.boslukWidth(context, 0.07),
        Text(
          'SOSYAL MEDYA HESAPLARI',
          style: GoogleFonts.poppins(
            color: Colors.white54,
            fontSize: MediaQuery.of(context).size.width * 0.033,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Row settings1container(BuildContext context) {
    return Row(
      children: [
        SpaceHelper.boslukWidth(context, 0.04),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey.withOpacity(0.07),
            ),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => const ScannedQRCodesPage(),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 13, 8, 8),
                    child: Row(
                      children: [
                        SpaceHelper.boslukWidth(context, 0.03),
                        Text(
                          'QR Kodumu Okuyanlar',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: MediaQuery.of(context).size.width * 0.036,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        // ios forward button
                        const Spacer(),
                        const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white54,
                          size: 15,
                        ),
                        SpaceHelper.boslukWidth(context, 0.03),
                      ],
                    ),
                  ),
                ),
                Divider(
                  indent: MediaQuery.of(context).size.width * 0.03,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => const ScannedQRCodesPage(),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 3, 8, 13),
                    child: Row(
                      children: [
                        SpaceHelper.boslukWidth(context, 0.03),
                        Text(
                          'QR Kodunu Okuduklarım',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: MediaQuery.of(context).size.width * 0.036,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        // ios forward button
                        const Spacer(),
                        const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white54,
                          size: 15,
                        ),
                        SpaceHelper.boslukWidth(context, 0.03),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        SpaceHelper.boslukWidth(context, 0.04),
      ],
    );
  }

  Row settings1text(BuildContext context) {
    return Row(
      children: [
        SpaceHelper.boslukWidth(context, 0.07),
        Text(
          'QR',
          style: GoogleFonts.poppins(
            color: Colors.white54,
            fontSize: MediaQuery.of(context).size.width * 0.033,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Text subtitle(BuildContext context) {
    return Text(
      getSubtitle(),
      overflow: TextOverflow.clip,
      style: GoogleFonts.poppins(
        color: Colors.white70,
        fontSize: MediaQuery.of(context).size.width * 0.04,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  Text title(BuildContext context) {
    return Text(
      FirebaseAuth.instance.currentUser!.displayName ?? "Kullanıcı Adı",
      overflow: TextOverflow.clip,
      style: GoogleFonts.poppins(
        color: Colors.white,
        fontSize: MediaQuery.of(context).size.width * 0.05,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget img(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
            FirebaseAuth.instance.currentUser!.photoURL ??
                "https://api.dicebear.com/7.x/adventurer-neutral/png?seed=${FirebaseAuth.instance.currentUser!.uid}",
            loadingBuilder: (BuildContext context, Widget child,
                ImageChunkEvent? loadingProgress) {
              if (loadingProgress == null) {
                return child;
              } else {
                return const CircularProgressIndicator();
              }
            },
            errorBuilder:
                (BuildContext context, Object error, StackTrace? stackTrace) {
              debugPrint('error: $error');
              debugPrint(FirebaseAuth.instance.currentUser!.photoURL!);
              return const Icon(
                Icons.error,
                color: Colors.red,
              );
            },
            height: MediaQuery.of(context).size.height * 0.18,
            width: MediaQuery.of(context).size.height * 0.18,
            fit: BoxFit.cover,
          ),
        ),
        // edit icon, top right
        Positioned(
          top: 2,
          right: 2,
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => const EditProfilePage(),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  Icons.edit,
                  color: Colors.black,
                  size: 20,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  getSubtitle() {
    FirebaseAuth.instance.currentUser!.reload();
    if (FirebaseAuth.instance.currentUser!.email != null) {
      return FirebaseAuth.instance.currentUser!.email;
    } else if (FirebaseAuth.instance.currentUser!.phoneNumber != null) {
      return FirebaseAuth.instance.currentUser!.phoneNumber;
    } else {
      return "";
    }
  }
}
