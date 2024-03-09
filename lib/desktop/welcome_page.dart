import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:starttech_qr/desktop/login.dart';
import 'package:starttech_qr/helpers/space.dart';
import 'package:video_player/video_player.dart';

class DesktopWelcomePage extends ConsumerStatefulWidget {
  const DesktopWelcomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DesktopWelcomePageState();
}

class _DesktopWelcomePageState extends ConsumerState<DesktopWelcomePage> {
  VideoPlayerController? _videoController;

  @override
  void initState() {
    super.initState();

    _videoController = VideoPlayerController.asset('assets/videos/bg1.mp4')
      ..initialize().then(
        (_) {
          _videoController!.setVolume(0);
          _videoController!.play();
          _videoController!.setLooping(true);
          setState(() {});
        },
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          if (_videoController != null) bgVideo(),
          bgContainer(context),
          Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                width: double.infinity,
              ),
              logo(context),
              SpaceHelper.boslukHeight(context, 0.05),
              Text(
                "Bursa'nın En Büyük Teknoloji ve Girişimcilik Zirvesine Hoşgeldiniz",
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Lütfen bu siteyi mobilden görüntüleyin.',
                style: GoogleFonts.poppins(
                  fontSize: 19,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SpaceHelper.boslukHeight(context, 0.05),
              signUpPage(context),
            ],
          )
        ],
      ),
    );
  }

  ElevatedButton signUpPage(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => const DesktopAdminLoginPage(),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        side: const BorderSide(
          color: Colors.white,
          width: 1,
        ),
        foregroundColor: Colors.white,
        backgroundColor: Colors.white,
        fixedSize: Size(
          MediaQuery.of(context).size.width * 0.2,
          MediaQuery.of(context).size.height * 0.05,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(
        'Admin Girişi',
        style: GoogleFonts.poppins(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
      ),
    );
  }

  Positioned bgVideo() {
    return Positioned.fill(
      child: FittedBox(
        fit: BoxFit.fitHeight,
        child: SizedBox(
          height: _videoController!.value.size.height,
          width: _videoController!.value.size.width * 2,
          child: VideoPlayer(_videoController!),
        ),
      ),
    );
  }

  Column bgContainer(BuildContext context) {
    return Column(
      children: [
        const Spacer(),
        // black color container
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  Image logo(BuildContext context) {
    return Image.asset(
      'assets/images/startech.png',
      height: MediaQuery.of(context).size.height * 0.3,
    );
  }
}
