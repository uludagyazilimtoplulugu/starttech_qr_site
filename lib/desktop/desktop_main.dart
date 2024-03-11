import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:starttech_qr/desktop/all_users.dart';
import 'package:starttech_qr/desktop/konusmacilar.dart';
import 'package:starttech_qr/desktop/scoreboard.dart';
import 'package:starttech_qr/desktop/stantlar.dart';
import 'package:starttech_qr/helpers/space.dart';

class DesktopMainPage extends ConsumerStatefulWidget {
  const DesktopMainPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DesktopMainPageState();
}

class _DesktopMainPageState extends ConsumerState<DesktopMainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xff1A1A1A),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              fixedSize: Size(
                MediaQuery.of(context).size.width * 0.5,
                MediaQuery.of(context).size.height * 0.07,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => const AllUsersPage(),
                ),
              );
            },
            child: Text(
              'Tüm Katılımcılar',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ),
          SpaceHelper.boslukHeight(context, 0.05),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              fixedSize: Size(
                MediaQuery.of(context).size.width * 0.5,
                MediaQuery.of(context).size.height * 0.07,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => const ScoreBoardPage(),
                ),
              );
            },
            child: Text(
              'Lider Tablosu',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ),
          SpaceHelper.boslukHeight(context, 0.05),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              fixedSize: Size(
                MediaQuery.of(context).size.width * 0.5,
                MediaQuery.of(context).size.height * 0.07,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => const StantlarPage(),
                ),
              );
            },
            child: Text(
              'Stantlar',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ),
          SpaceHelper.boslukHeight(context, 0.05),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              fixedSize: Size(
                MediaQuery.of(context).size.width * 0.5,
                MediaQuery.of(context).size.height * 0.07,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => const KonusmacilarPage(),
                ),
              );
            },
            child: Text(
              'Konuşmacılar',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
