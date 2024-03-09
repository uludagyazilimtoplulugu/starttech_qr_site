// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
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

  int _currenIndex = 0;

  CarouselController carouselController = CarouselController();

  List<Widget> get _pages => [
        customSliderItem(
          "İnsanlarla Tanış",
          'Etkinlikte olabildiğince çok kişiyle tanışarak puan kazanabilirsin. Unutma, hepimiz bu etkinliğe yeni insanlar tanıyıp network oluşturmak için katıldık.',
          1,
        ),
        customSliderItem(
          "QR Okut",
          "Her tanıştığın kişinin QR kodunu okutarak puan kazanabilirsin. Okuttuğun kod YALNIZCA sana puan kazandırır. Karşındaki kişi de senin kodunu okutarak puan kazanır.",
          2,
        ),
        customSliderItem(
          "Büyük Hediye",
          "Etkinlik sonunda en çok puan kazanan kişiye büyük hediye verilecek. Kazanmak için etkinlik boyunca QR kodlarını okutmayı unutma!",
          3,
        ),
      ];

  Widget customSliderItem(String s, String t, int index) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        MediaQuery.of(context).size.width * 0.05,
        0,
        MediaQuery.of(context).size.width * 0.05,
        0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Lottie.asset(
            'assets/lottie/animation$index.json',
            height: MediaQuery.of(context).size.height * 0.4,
            repeat: false,
          ),
          Text(
            s,
            style: GoogleFonts.poppins(
              fontSize: MediaQuery.of(context).size.width * 0.052,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            t,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: MediaQuery.of(context).size.width * 0.03,
              fontWeight: FontWeight.w400,
              color: Colors.white60,
            ),
          ),
        ],
      ),
    );
  }

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
          onPressed: () {
            setState(() {
              _currenIndex = 0;
              // carouselController.jumpToPage(0);
            });
            // open bottom sheet
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(25.0),
                  topLeft: Radius.circular(25.0),
                ),
              ),
              builder: (context) {
                return StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState2) {
                  return Container(
                    height: MediaQuery.of(context).size.height * 0.8,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(25.0),
                        topLeft: Radius.circular(25.0),
                      ),
                      color: Color(0xff1A1A1A),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        // drag indicator and close button on the right top corner
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Container(
                              width: 50.0,
                              height: 5.0,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                        ),

                        slider(setState2, context),
                        dots(),
                        const Spacer(),

                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                minimumSize: Size(
                                  MediaQuery.of(context).size.width * 0.8,
                                  MediaQuery.of(context).size.height * 0.07,
                                ),
                              ),
                              onPressed: () {
                                setState2(() {
                                  if (_currenIndex < 2) {
                                    _currenIndex++;
                                    carouselController.nextPage();
                                  } else {
                                    Navigator.pop(context);
                                  }
                                });
                              },
                              child: Text(
                                _currenIndex < 2 ? 'İlerle' : 'Kapat',
                                style: GoogleFonts.poppins(
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.04,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SpaceHelper.boslukHeight(context, 0.05),
                      ],
                    ),
                  );
                });
              },
            );
          },
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

  Row dots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        _pages.length,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: _currenIndex == index ? 20 : 8,
          height: 8,
          margin: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            color: _currenIndex == index
                ? Colors.white
                : Colors.white.withOpacity(0.5),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  CarouselSlider slider(StateSetter setState2, BuildContext context) {
    return CarouselSlider(
      carouselController: carouselController,
      items: _pages,
      options: CarouselOptions(
        onPageChanged: (index, reason) {
          setState(() {
            setState2(() {
              carouselController.jumpToPage(index);
              _currenIndex = index;
            });
          });
        },
        height: MediaQuery.of(context).size.height * 0.6,

        viewportFraction: 1,
        initialPage: 0,
        enableInfiniteScroll: true,
        reverse: false,
        autoPlay: false,
        // disable scroll
        // scrollPhysics: const NeverScrollableScrollPhysics(),
        autoPlayInterval: const Duration(seconds: 4),
        autoPlayAnimationDuration: const Duration(milliseconds: 500),
        // autoPlayCurve: Curves.fastOutSlowIn,
        // enlargeCenterPage: true,
        scrollDirection: Axis.horizontal,
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
