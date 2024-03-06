// ignore_for_file: deprecated_member_use

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_qrcode_scanner/flutter_web_qrcode_scanner.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:starttech_qr/helpers/dialog.dart';
import 'package:starttech_qr/helpers/space.dart';
import 'package:starttech_qr/main.dart';
import 'package:starttech_qr/screens/scan_completed.dart';
import 'package:starttech_qr/screens/tabbar_main.dart';

class QRScanPage extends ConsumerStatefulWidget {
  const QRScanPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _QRScanPageState();
}

class _QRScanPageState extends ConsumerState<QRScanPage>
    with AutomaticKeepAliveClientMixin {
  bool isCodeFieldTapped = false;
  TextEditingController codeController = TextEditingController();
  bool isLoading = false;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return WillPopScope(
      onWillPop: () async => false,
      child: Stack(
        children: [
          Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: const Color(0xff1A1A1A),
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                'QR Tara',
                style: GoogleFonts.poppins(
                  fontSize: MediaQuery.of(context).size.width * 0.05,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
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
            body: SingleChildScrollView(
              reverse: true,
              child: Column(
                children: [
                  scanner(context),
                  SpaceHelper.boslukHeight(context, 0.05),
                  customDivider(context),
                  SpaceHelper.boslukHeight(context, 0.05),
                  codeField(context),
                  SpaceHelper.boslukHeight(context, 0.03),
                  enterCodeBtn(context),
                ],
              ),
            ),
          ),
          loadingWidget(),
        ],
      ),
    );
  }

  FlutterWebQrcodeScanner scanner(BuildContext context) {
    return FlutterWebQrcodeScanner(
      cameraDirection: CameraDirection.back,
      height: MediaQuery.of(context).size.height * 0.5,
      stopOnFirstResult: true,
      onGetResult: (result) {
        // close kehboard
        FocusScope.of(context).unfocus();
        setState(() {
          isLoading = true;
        });

        Future.delayed(const Duration(milliseconds: 500));
        setState(() {
          isLoading = false;
        });
        Navigator.pushAndRemoveUntil(
          context,
          CupertinoPageRoute(
            builder: (context) => const TabBarMain(),
          ),
          (route) => false,
        );
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => ScanCompletedPage(
              qrCode: result,
            ),
          ),
        );
      },
      onError: (e) {
        DialogHelper.getCustomErrorDialog();
      },
    );
  }

  Row customDivider(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: Colors.white.withOpacity(0.1),
            indent: MediaQuery.of(context).size.width * 0.15,
            endIndent: MediaQuery.of(context).size.width * 0.05,
          ),
        ),
        Text(
          'VEYA',
          style: GoogleFonts.poppins(
            fontSize: MediaQuery.of(context).size.width * 0.03,
            fontWeight: FontWeight.w500,
            color: Colors.white.withOpacity(0.7),
          ),
        ),
        Expanded(
          child: Divider(
            color: Colors.white.withOpacity(0.1),
            endIndent: MediaQuery.of(context).size.width * 0.15,
            indent: MediaQuery.of(context).size.width * 0.05,
          ),
        ),
      ],
    );
  }

  codeField(BuildContext context) {
    return Row(
      children: [
        SpaceHelper.boslukWidth(context, 0.05),
        Expanded(
          child: CupertinoTextField(
            onTap: () {
              setState(() {
                isCodeFieldTapped = true;
              });
            },
            onTapOutside: (_) {
              setState(() {
                isCodeFieldTapped = false;
              });
              FocusScope.of(context).unfocus();
            },
            cursorColor: Colors.white,
            controller: codeController,
            padding: const EdgeInsets.all(18.0),
            placeholder: 'Kodu Gir',
            placeholderStyle: GoogleFonts.poppins(
              color: Colors.white.withOpacity(0.3),
              fontWeight: FontWeight.w400,
              fontSize: MediaQuery.of(context).size.width * 0.038,
            ),
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w400,
              fontSize: MediaQuery.of(context).size.width * 0.04,
            ),
            decoration: BoxDecoration(
              color: const Color(0xff1A1A1A),
              border: Border.all(
                color: isCodeFieldTapped ? Colors.white : Colors.white54,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            prefixMode: OverlayVisibilityMode.always,
            keyboardType: TextInputType.name,
            textInputAction: TextInputAction.done,
          ),
        ),
        SpaceHelper.boslukWidth(context, 0.05),
      ],
    );
  }

  Row enterCodeBtn(BuildContext context) {
    return Row(
      children: [
        SpaceHelper.boslukWidth(context, 0.05),
        ElevatedButton(
          onPressed: () async {
            if (codeController.text.isEmpty) {
              DialogHelper.getCustomErrorDialog(
                subtitle: 'Lütfen bir kod girin.',
              );
            } else {
              setState(() {
                isLoading = true;
              });
              // close kehboard
              FocusScope.of(context).unfocus();

              await Future.delayed(const Duration(milliseconds: 1000));

              setState(() {
                isLoading = false;
              });

              if (GlobalcontextService.navigatorKey.currentContext == null) {
                return;
              }

              Navigator.pushAndRemoveUntil(
                GlobalcontextService.navigatorKey.currentContext!,
                CupertinoPageRoute(
                  builder: (context) => const TabBarMain(),
                ),
                (route) => false,
              );
              Navigator.push(
                GlobalcontextService.navigatorKey.currentContext!,
                CupertinoPageRoute(
                  builder: (context) => ScanCompletedPage(
                    qrCode: codeController.text,
                  ),
                ),
              );
            }
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
          child: Text(
            'Devam Et',
            style: GoogleFonts.poppins(
              fontSize: MediaQuery.of(context).size.width * 0.035,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ),
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
}
