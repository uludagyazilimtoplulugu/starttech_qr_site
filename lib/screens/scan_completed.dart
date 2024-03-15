// ignore_for_file: deprecated_member_use

import 'package:confetti/confetti.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:starttech_qr/helpers/space.dart';
import 'package:starttech_qr/models/qr_code.dart';
import 'package:starttech_qr/models/user.dart';
import 'package:starttech_qr/services/firestore_service.dart';

class ScanCompletedPage extends ConsumerStatefulWidget {
  final String qrCode;
  const ScanCompletedPage({super.key, required this.qrCode});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ScanCompletedPageState();
}

class _ScanCompletedPageState extends ConsumerState<ScanCompletedPage>
    with AutomaticKeepAliveClientMixin {
  bool isLoading = false;
  late ConfettiController _controllerCenterLeft;

  List<Color> confettiColors = [
    Colors.red,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.purple,
    Colors.pink,
    Colors.orange,
    Colors.teal,
  ];

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _controllerCenterLeft.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _controllerCenterLeft =
        ConfettiController(duration: const Duration(milliseconds: 1300));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: const Color(0xff1A1A1A),
        appBar: AppBar(
          backgroundColor: const Color(0xff1A1A1A),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              // Navigator.pushAndRemoveUntil(
              //   context,
              //   CupertinoPageRoute(
              //     builder: (context) => const TabBarMain(),
              //   ),
              //   (route) => false,
              // );
              // pop
              Navigator.pop(context);
            },
          ),
        ),
        body: Stack(
          children: [
            FutureBuilder(
              future: updatePoint(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.data == null) {
                    return userNotFound(context);
                  }
                  if (snapshot.data == 'already-exists') {
                    return alreadyExists(context);
                  }
                  if (snapshot.data == 'same-user') {
                    FirestoreUser? user = snapshot.data;

                    return sameUser(context, user);
                  }
                  debugPrint('snapshot.data: ${snapshot.data}');
                  if (snapshot.data.runtimeType == FirestoreUser) {
                    FirestoreUser? user = snapshot.data;
                    _controllerCenterLeft.play();

                    return created(context, user);
                  }
                  if (snapshot.data.runtimeType == CustomQRCode) {
                    CustomQRCode? customQRCode = snapshot.data;
                    _controllerCenterLeft.play();

                    return createdCustomQR(context, customQRCode);
                  }
                  FirestoreUser? user = snapshot.data;
                  _controllerCenterLeft.play();

                  return created(context, user);
                }
                return loading();
              },
            ),
            _getConfetti,
          ],
        ),
      ),
    );
  }

  Future updatePoint() async {
    if (widget.qrCode.length == 6) {
      bool isScannedBefore =
          await FirestoreService().didUserScanTheQrCodeBefore(
        uid: FirebaseAuth.instance.currentUser!.uid,
        qrCode: widget.qrCode,
      );
      if (isScannedBefore) {
        // kullanıcı daha önce taratmış
        return 'already-exists';
      } else {
        FirestoreUser? user = await FirestoreService().getUserWithQrCode(
          qrCode: widget.qrCode,
        );
        if (user == null) {
          return null;
        }
        if (FirebaseAuth.instance.currentUser!.uid == user.uid) {
          return 'same-user';
        }
        await FirestoreService().updateUserPointAndScannedQrCodes(
          uid: FirebaseAuth.instance.currentUser!.uid,
          scannedQrCode: widget.qrCode,
          point: getPoint(),
        );
        return user;
      }
    } else {
      // custom qr code
      CustomQRCode? qrCode = await FirestoreService()
          .getCustomQRWithQRCode(qrCode: widget.qrCode)
          .then((value) {
        if (value != null) {
          return value;
        }
        return null;
      });
      if (qrCode == null) {
        return null;
      }
      bool isScannedBefore =
          await FirestoreService().didUserScanTheQrCodeBefore(
        uid: FirebaseAuth.instance.currentUser!.uid,
        qrCode: widget.qrCode,
      );
      if (isScannedBefore) {
        // kullanıcı daha önce taratmış
        return 'already-exists';
      } else {
        await FirestoreService().updateUserPointAndScannedQrCodes(
          uid: FirebaseAuth.instance.currentUser!.uid,
          scannedQrCode: widget.qrCode,
          point: qrCode.point,
        );
        return qrCode;
      }
    }
  }

  Center loading() {
    return const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      ),
    );
  }

  Center userNotFound(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          'Kullanıcı veya etkinlik bulunamadı. Kodu kontrol edin.',
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: MediaQuery.of(context).size.width * 0.05,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget alreadyExists(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
          ),
          Text(
            'OPSSS',
            style: GoogleFonts.poppins(
              fontSize: MediaQuery.of(context).size.width * 0.07,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          Text(
            'Bu kodu daha önce tarattın.',
            style: GoogleFonts.poppins(
              fontSize: MediaQuery.of(context).size.width * 0.04,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
          StreamBuilder(
            stream: FirestoreService()
                .streamPoint(uid: FirebaseAuth.instance.currentUser!.uid),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                return Text(
                  "Güncel puanın: ${snapshot.data}",
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
        ],
      ),
    );
  }

  SingleChildScrollView created(BuildContext context, FirestoreUser? user) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
          ),
          Text(
            'YEYYYYYY',
            style: GoogleFonts.poppins(
              fontSize: MediaQuery.of(context).size.width * 0.07,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          Text(
            'Bir yeni network oluşturdun.',
            style: GoogleFonts.poppins(
              fontSize: MediaQuery.of(context).size.width * 0.04,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
          SpaceHelper.boslukHeight(context, 0.02),
          RichText(
            text: TextSpan(
              text: 'Bu işlemden tam ',
              style: GoogleFonts.poppins(
                fontSize: MediaQuery.of(context).size.width * 0.04,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: '${getPoint()} puan',
                  style: GoogleFonts.poppins(
                    fontSize: MediaQuery.of(context).size.width * 0.04,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue,
                  ),
                ),
                TextSpan(
                  text: ' kazandın.',
                  style: GoogleFonts.poppins(
                    fontSize: MediaQuery.of(context).size.width * 0.04,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          StreamBuilder(
            stream: FirestoreService()
                .streamPoint(uid: FirebaseAuth.instance.currentUser!.uid),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                return Text(
                  "Güncel puanın: ${snapshot.data}",
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
          SpaceHelper.boslukHeight(context, 0.05),
          img(context, user!.photoUrl),
          const SizedBox(height: 10),
          Text(
            user.name,
            style: GoogleFonts.poppins(
              fontSize: MediaQuery.of(context).size.width * 0.05,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            user.email == 'null' ? '' : user.email,
            style: GoogleFonts.poppins(
              fontSize: MediaQuery.of(context).size.width * 0.04,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget get _getConfetti {
    return Column(
      children: [
        SpaceHelper.boslukHeight(context, 0.15),
        Align(
          alignment: Alignment.topLeft,
          child: ConfettiWidget(
            colors: confettiColors,
            confettiController: _controllerCenterLeft,
            blastDirection: 0, // radial value - RIGHT
            emissionFrequency: 0.4,
            minimumSize: const Size(10,
                10), // set the minimum potential size for the confetti (width, height)
            maximumSize: const Size(50,
                50), // set the maximum potential size for the confetti (width, height)
            numberOfParticles: 1,
            gravity: 0.1,
          ),
        ),
      ],
    );
  }

  ClipRRect img(BuildContext context, String img) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.network(
        img,
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
          return const Icon(
            Icons.error,
            color: Colors.red,
          );
        },
        height: MediaQuery.of(context).size.height * 0.18,
        width: MediaQuery.of(context).size.height * 0.18,
        fit: BoxFit.cover,
      ),
    );
  }

  int getPoint() {
    debugPrint('widget.qrCode: ${widget.qrCode}');
    // length
    if (widget.qrCode.trim().length == 6) {
      // kullanıcı taratma
      return 5;
    } else {
      // get point from firestore
      FirestoreService()
          .getCustomQRWithQRCode(qrCode: widget.qrCode)
          .then((value) {
        if (value != null) {
          return value.point;
        }
      });
    }
    return 0;
  }

  Widget sameUser(BuildContext context, FirestoreUser? user) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
            ),
            Text(
              'HEY',
              style: GoogleFonts.poppins(
                fontSize: MediaQuery.of(context).size.width * 0.07,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            Text(
              'Bu senin kodun. Lütfen başkasının kodunu tarat.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: MediaQuery.of(context).size.width * 0.04,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
            // StreamBuilder(
            //   stream: FirestoreService()
            //       .streamPoint(uid: FirebaseAuth.instance.currentUser!.uid),
            //   builder: (context, snapshot) {
            //     if (snapshot.connectionState == ConnectionState.active) {
            //       return Text(
            //         "Güncel puanın: ${snapshot.data}",
            //         style: GoogleFonts.poppins(
            //           color: Colors.white70,
            //           fontSize: MediaQuery.of(context).size.width * 0.04,
            //           fontWeight: FontWeight.w400,
            //         ),
            //       );
            //     } else {
            //       return const SizedBox();
            //     }
            //   },
            // ),

            FutureBuilder(
              future: FirestoreService()
                  .getUser(uid: FirebaseAuth.instance.currentUser!.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  return Text(
                    "Güncel puanın: ${snapshot.data}",
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
          ],
        ),
      ),
    );
  }

  Widget createdCustomQR(BuildContext context, CustomQRCode? qrCode) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
          ),
          Text(
            'YEYYYYYY',
            style: GoogleFonts.poppins(
              fontSize: MediaQuery.of(context).size.width * 0.07,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          Text(
            qrCode!.type == 'speaker'
                ? 'Bir konuşmacıyı dinledin.'
                : 'Bir standı ziyaret ettin.',
            style: GoogleFonts.poppins(
              fontSize: MediaQuery.of(context).size.width * 0.04,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
          SpaceHelper.boslukHeight(context, 0.02),
          RichText(
            text: TextSpan(
              text: 'Bu işlemden tam ',
              style: GoogleFonts.poppins(
                fontSize: MediaQuery.of(context).size.width * 0.04,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: '${qrCode.point} puan',
                  style: GoogleFonts.poppins(
                    fontSize: MediaQuery.of(context).size.width * 0.04,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue,
                  ),
                ),
                TextSpan(
                  text: ' kazandın.',
                  style: GoogleFonts.poppins(
                    fontSize: MediaQuery.of(context).size.width * 0.04,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          StreamBuilder(
            stream: FirestoreService()
                .streamPoint(uid: FirebaseAuth.instance.currentUser!.uid),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                return Text(
                  "Güncel puanın: ${snapshot.data}",
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
          SpaceHelper.boslukHeight(context, 0.05),
          img(context, qrCode.photoUrl),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 3, 8, 3),
            child: Text(
              qrCode.title,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: MediaQuery.of(context).size.width * 0.05,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              qrCode.description,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: MediaQuery.of(context).size.width * 0.04,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
