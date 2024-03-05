import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:starttech_qr/helpers/space.dart';
import 'package:starttech_qr/screens/qr.dart';
import 'package:starttech_qr/screens/qr_scan.dart';
import 'package:starttech_qr/services/firestore_service.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: const Color(0xff1A1A1A),
        floatingActionButton: ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            minimumSize: Size(
              MediaQuery.of(context).size.width * 0.4,
              MediaQuery.of(context).size.height * 0.07,
            ),
          ),
          onPressed: () {},
          child: Text(
            'Nasıl çalışır?',
            style: GoogleFonts.poppins(
              fontSize: MediaQuery.of(context).size.width * 0.04,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
        ),
        body: Column(
          children: [
            logo(context),
            bigTitle(context),
            StreamBuilder(
              stream: FirestoreService()
                  .streamPoint(uid: FirebaseAuth.instance.currentUser!.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  return Row(
                    children: [
                      SpaceHelper.boslukWidth(context, 0.05),
                      Text(
                        "Puanın: ${snapshot.data}",
                        style: GoogleFonts.poppins(
                          color: Colors.white70,
                          fontSize: MediaQuery.of(context).size.width * 0.04,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  );
                } else {
                  return const SizedBox();
                }
              },
            ),
            SpaceHelper.boslukHeight(context, 0.006),
            subtitle(context),
            SpaceHelper.boslukHeight(context, 0.05),
            qrOkutBtn(context),
            SpaceHelper.boslukHeight(context, 0.02),
            qrKoduOlusturBtn(context),
            SpaceHelper.boslukHeight(context, 0.01),
            communityLogos(context),
          ],
        ),
      ),
    );
  }

  Row subtitle(BuildContext context) {
    return Row(
      children: [
        SpaceHelper.boslukWidth(context, 0.05),
        Expanded(
          child: Text(
            'Bu sayfada sana ait olan QR kodunu görebilir ve yeni tanıştığın kişilerin QR kodunu okutarak onları ekleyebilirsin.'
            '\n\nUnutma, en çok puan alan kişi büyük ödülün sahibi olur.',
            overflow: TextOverflow.clip,
            style: GoogleFonts.poppins(
              fontSize: MediaQuery.of(context).size.width * 0.027,
              fontWeight: FontWeight.w400,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ),
        SpaceHelper.boslukWidth(context, 0.05),
      ],
    );
  }

  Row bigTitle(BuildContext context) {
    return Row(
      children: [
        SpaceHelper.boslukWidth(context, 0.05),
        Text(
          'Selam, ${getName()}',
          style: GoogleFonts.poppins(
            fontSize: MediaQuery.of(context).size.width * 0.05,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  getName() {
    FirebaseAuth.instance.currentUser!.reload();
    List<String> name =
        FirebaseAuth.instance.currentUser!.displayName!.split(' ');
    if (FirebaseAuth.instance.currentUser!.displayName == null) {
      return 'Kullanıcı';
    }
    if (name.length > 1) {
      return name[0];
    } else {
      return FirebaseAuth.instance.currentUser!.displayName;
    }
  }

  qrOkutBtn(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        minimumSize: Size(
          MediaQuery.of(context).size.width * 0.9,
          MediaQuery.of(context).size.height * 0.075,
        ),
      ),
      onPressed: () {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => const QRScanPage(),
          ),
        );
      },
      child: Text(
        'QR Kod Okut',
        style: GoogleFonts.poppins(
          fontSize: MediaQuery.of(context).size.width * 0.04,
          fontWeight: FontWeight.w400,
          color: Colors.white,
        ),
      ),
    );
  }

  qrKoduOlusturBtn(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        minimumSize: Size(
          MediaQuery.of(context).size.width * 0.9,
          MediaQuery.of(context).size.height * 0.075,
        ),
      ),
      onPressed: () {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => const QRPage(),
          ),
        );
      },
      child: Text(
        'QR Kod Göster',
        style: GoogleFonts.poppins(
          fontSize: MediaQuery.of(context).size.width * 0.04,
          fontWeight: FontWeight.w400,
          color: Colors.black,
        ),
      ),
    );
  }

  logo(BuildContext context) {
    return Image.asset(
      'assets/images/startech.png',
      width: MediaQuery.of(context).size.width * 0.5,
      height: MediaQuery.of(context).size.height * 0.2,
    );
  }

  communityLogos(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.4,
          height: MediaQuery.of(context).size.height * 0.2,
          child: Column(
            children: [
              Image.asset(
                'assets/images/uudevlogo_beyaz.png',
                width: MediaQuery.of(context).size.width * 0.1,
                height: MediaQuery.of(context).size.height * 0.1,
              ),
              Text(
                'Uludağ Yazılım Topluluğu',
                overflow: TextOverflow.clip,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: MediaQuery.of(context).size.width * 0.03,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.4,
          height: MediaQuery.of(context).size.height * 0.2,
          child: Column(
            children: [
              Image.asset(
                'assets/images/gdgcloudbursalogo.png',
                width: MediaQuery.of(context).size.width * 0.1,
                height: MediaQuery.of(context).size.height * 0.1,
              ),
              Text(
                'Google DSC Uludag University',
                textAlign: TextAlign.center,
                overflow: TextOverflow.clip,
                style: GoogleFonts.poppins(
                  fontSize: MediaQuery.of(context).size.width * 0.03,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
