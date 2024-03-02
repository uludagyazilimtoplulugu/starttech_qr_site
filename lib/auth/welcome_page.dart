import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:starttech_qr/auth/signup.dart';
import 'package:video_player/video_player.dart';

class WelcomePage extends ConsumerStatefulWidget {
  const WelcomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _WelcomePageState();
}

class _WelcomePageState extends ConsumerState<WelcomePage> {
  VideoPlayerController? _videoController;
  int _currenIndex = 0;

  List<Widget> get _pages => [
        customSliderItem(
          "Hoşgeldin",
          "StartTech etkinliğimize hoşgeldin! Etkinlikte birbirinden değerli konuşmacıları dinlerken aynı zamanda yeni insanlarla tanışabilirsin.",
        ),
        customSliderItem(
          "QR Okut",
          "Etkinlik sırasında alanda olan ve kayıt oluşturan herkesin bir QR kodu olur. Herkese ait QR kodu okutarak etkinlikteki kişilerle iletişime geçip puan kazanabilirsin.",
        ),
        customSliderItem(
          "Stantlar",
          "Dışarıdaki stantların da QR kodları olur. Stantlardaki QR kodları okutarak stant sahipleriyle iletişime geçebilirsin. Unutma, stant puanları 5 puan.",
        ),
        customSliderItem(
          "Büyük Hediye",
          "Gün sonunda en çok puan kazanan kişiye büyük hediye verilecek. Kazanmak için etkinlik boyunca QR kodlarını okutmayı unutma!",
        ),
      ];

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
          if (_videoController != null)
            Positioned.fill(
              child: FittedBox(
                fit: BoxFit.fitHeight,
                child: SizedBox(
                  height: _videoController!.value.size.height,
                  width: _videoController!.value.size.width,
                  child: VideoPlayer(_videoController!),
                ),
              ),
            ),
          Column(
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
              // Container(
              //   height: MediaQuery.of(context).size.height,
              //   width: MediaQuery.of(context).size.width,
              //   decoration: BoxDecoration(
              //     gradient: LinearGradient(
              //       begin: Alignment.topCenter,
              //       end: Alignment.bottomCenter,
              //       stops: const [0.1, 0.2],
              //       colors: [
              //         Colors.transparent,
              //         Colors.black.withOpacity(0.8),
              //       ],
              //     ),
              //   ),
              // ),
            ],
          ),
          Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                width: double.infinity,
              ),
              // Spacer(),
              // logo

              Image.asset(
                'assets/images/startech.png',
                width: MediaQuery.of(context).size.width * 0.7,
              ),
              const Spacer(),

              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              CarouselSlider(
                items: _pages,
                options: CarouselOptions(
                  onPageChanged: (index, reason) {
                    setState(() {
                      _currenIndex = index;
                    });
                  },
                  height: MediaQuery.of(context).size.height * 0.17,

                  viewportFraction: 1,
                  initialPage: 0,
                  enableInfiniteScroll: true,
                  reverse: false,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 4),
                  autoPlayAnimationDuration: const Duration(milliseconds: 500),
                  // autoPlayCurve: Curves.fastOutSlowIn,
                  // enlargeCenterPage: true,
                  scrollDirection: Axis.horizontal,
                ),
              ),

              Row(
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
              ),
              // DotsIndicator(

              //   dotsCount: _pages.length,

              //   position: _currenIndex,
              //   decorator: DotsDecorator(
              //     color: Colors.grey,
              //     activeColor: Colors.white,
              //     size: const Size(6, 6),
              //     activeSize: const Size(22, 6),
              //     activeShape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(5.0),
              //     ),
              //   ),
              // ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),

              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignUpPage(),
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
                    MediaQuery.of(context).size.width * 0.7,
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
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.grey[900],
                  fixedSize: Size(
                    MediaQuery.of(context).size.width * 0.7,
                    MediaQuery.of(context).size.height * 0.07,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Giriş Yap',
                  style: GoogleFonts.poppins(
                    fontSize: MediaQuery.of(context).size.width * 0.035,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget customSliderItem(String s, String t) {
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
}
