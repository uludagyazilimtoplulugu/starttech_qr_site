import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:starttech_qr/helpers/space.dart';
import 'package:starttech_qr/main.dart';

class DialogHelper {
  static getCustomDialog({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required List<Widget> buttons,
  }) {
    showDialog(
      context: GlobalcontextService.navigatorKey.currentContext!,
      barrierColor: Colors.black.withOpacity(0.7),
      builder: (BuildContext context) {
        return Dialog(
          elevation: 0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0)), //this right here
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SpaceHelper.boslukHeight(context, 0.023),
              Icon(
                icon,
                color: iconColor,
                size: MediaQuery.of(context).size.height * 0.05,
              ),
              SpaceHelper.boslukHeight(context, 0.023),

              Text(
                title,
                style: GoogleFonts.blinker(
                  fontSize: MediaQuery.of(context).size.height * 0.028,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SpaceHelper.boslukHeight(context, 0.004),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.blinker(
                    fontSize: MediaQuery.of(context).size.height * 0.02,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              SpaceHelper.boslukHeight(context, 0.013),
              // add buttons and space between them
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: buttons,
              ),
              SpaceHelper.boslukHeight(context, 0.023),
            ],
          ),
        );
      },
    );
  }

  static getCustomErrorDialog({
    String title = "Hata",
    String subtitle = "Bir hata oluştu. Lütfen daha sonra tekrar deneyiniz.",
  }) {
    showDialog(
      context: GlobalcontextService.navigatorKey.currentContext!,
      barrierColor: Colors.black.withOpacity(0.7),
      builder: (BuildContext context) {
        return Dialog(
          elevation: 0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0)), //this right here
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SpaceHelper.boslukHeight(context, 0.023),
              Icon(
                FontAwesomeIcons.circleXmark,
                color: Colors.red,
                size: MediaQuery.of(context).size.height * 0.05,
              ),
              SpaceHelper.boslukHeight(context, 0.023),
              Text(
                title,
                style: GoogleFonts.blinker(
                  fontSize: MediaQuery.of(context).size.height * 0.028,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SpaceHelper.boslukHeight(context, 0.004),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.blinker(
                    fontSize: MediaQuery.of(context).size.height * 0.02,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              SpaceHelper.boslukHeight(context, 0.013),
              // add buttons and space between them
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        fixedSize: Size(
                          MediaQuery.of(context).size.width * 0.65,
                          MediaQuery.of(context).size.height * 0.065,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(
                            GlobalcontextService.navigatorKey.currentContext!);
                      },
                      child: Text(
                        "Tamam",
                        style: GoogleFonts.blinker(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              SpaceHelper.boslukHeight(context, 0.023),
            ],
          ),
        );
      },
    );
  }

  static getCustomErrorDialogWithoutButton({
    String title = "Hata",
    String subtitle = "Bir hata oluştu. Lütfen daha sonra tekrar deneyiniz.",
  }) {
    showDialog(
      context: GlobalcontextService.navigatorKey.currentContext!,
      barrierColor: Colors.black.withOpacity(0.7),
      builder: (BuildContext context) {
        return Dialog(
          elevation: 0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0)), //this right here
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SpaceHelper.boslukHeight(context, 0.023),
              Icon(
                FontAwesomeIcons.circleXmark,
                color: Colors.red,
                size: MediaQuery.of(context).size.height * 0.05,
              ),
              SpaceHelper.boslukHeight(context, 0.023),
              Text(
                title,
                style: GoogleFonts.blinker(
                  fontSize: MediaQuery.of(context).size.height * 0.028,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SpaceHelper.boslukHeight(context, 0.004),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.blinker(
                    fontSize: MediaQuery.of(context).size.height * 0.02,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              SpaceHelper.boslukHeight(context, 0.013),
              // add buttons and space between them
            ],
          ),
        );
      },
    );
  }

  static getCustomWarningDialog({
    String title = "Uyarı",
    String subtitle = "Bir hata oluştu. Lütfen daha sonra tekrar deneyiniz.",
  }) {
    showDialog(
      context: GlobalcontextService.navigatorKey.currentContext!,
      barrierColor: Colors.black.withOpacity(0.7),
      builder: (BuildContext context) {
        return Dialog(
          elevation: 0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0)), //this right here
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SpaceHelper.boslukHeight(context, 0.023),
              Icon(
                FontAwesomeIcons.triangleExclamation,
                color: Colors.red,
                size: MediaQuery.of(context).size.height * 0.05,
              ),
              SpaceHelper.boslukHeight(context, 0.023),
              Text(
                title,
                style: GoogleFonts.blinker(
                  fontSize: MediaQuery.of(context).size.height * 0.028,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SpaceHelper.boslukHeight(context, 0.004),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.blinker(
                    fontSize: MediaQuery.of(context).size.height * 0.02,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              SpaceHelper.boslukHeight(context, 0.013),
              // add buttons and space between them
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        fixedSize: Size(
                          MediaQuery.of(context).size.width * 0.65,
                          MediaQuery.of(context).size.height * 0.06,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(
                            GlobalcontextService.navigatorKey.currentContext!);
                      },
                      child: Text(
                        "Tamam",
                        style: GoogleFonts.blinker(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              SpaceHelper.boslukHeight(context, 0.023),
            ],
          ),
        );
      },
    );
  }

  static getCustomSuccessDialog({
    String title = "Başarılı!",
    String subtitle = "İşlem başarıyla gerçekleştirildi",
  }) {
    showDialog(
      context: GlobalcontextService.navigatorKey.currentContext!,
      barrierColor: Colors.black.withOpacity(0.7),
      builder: (BuildContext context) {
        return Dialog(
          elevation: 0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0)), //this right here
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SpaceHelper.boslukHeight(context, 0.023),
              Icon(
                FontAwesomeIcons.circleCheck,
                color: Colors.white,
                size: MediaQuery.of(context).size.height * 0.05,
              ),
              SpaceHelper.boslukHeight(context, 0.023),
              Text(
                title,
                style: GoogleFonts.blinker(
                  fontSize: MediaQuery.of(context).size.height * 0.028,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SpaceHelper.boslukHeight(context, 0.004),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.blinker(
                    fontSize: MediaQuery.of(context).size.height * 0.02,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              SpaceHelper.boslukHeight(context, 0.013),
              // add buttons and space between them
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        fixedSize: Size(
                          MediaQuery.of(context).size.width * 0.65,
                          MediaQuery.of(context).size.height * 0.06,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(
                            GlobalcontextService.navigatorKey.currentContext!);
                      },
                      child: Text(
                        "Tamam",
                        style: GoogleFonts.blinker(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              SpaceHelper.boslukHeight(context, 0.023),
            ],
          ),
        );
      },
    );
  }

  static getCustomSuccessDialogWithoutButton({
    String title = "Başarılı!",
    String subtitle = "İşlem başarıyla gerçekleştirildi",
  }) {
    showDialog(
      context: GlobalcontextService.navigatorKey.currentContext!,
      barrierColor: Colors.black.withOpacity(0.7),
      builder: (BuildContext context) {
        return Dialog(
          elevation: 0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0)), //this right here
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SpaceHelper.boslukHeight(context, 0.023),
              Icon(
                FontAwesomeIcons.circleCheck,
                color: Colors.white,
                size: MediaQuery.of(context).size.height * 0.05,
              ),
              SpaceHelper.boslukHeight(context, 0.023),
              Text(
                title,
                style: GoogleFonts.blinker(
                  fontSize: MediaQuery.of(context).size.height * 0.028,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SpaceHelper.boslukHeight(context, 0.004),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.blinker(
                    fontSize: MediaQuery.of(context).size.height * 0.02,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              SpaceHelper.boslukHeight(context, 0.023),
            ],
          ),
        );
      },
    );
  }
}
