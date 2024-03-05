import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:image_picker_web/image_picker_web.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:permission_handler_web/permission_handler_web.dart';
// import 'package:image_picker_web/image_picker_web.dart';

import 'package:starttech_qr/helpers/dialog.dart';
import 'package:starttech_qr/helpers/space.dart';
import 'package:starttech_qr/main.dart';
import 'package:starttech_qr/services/firestore_service.dart';
import 'package:starttech_qr/services/storage_service.dart';
import 'package:starttech_qr/yonlendirme.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  const EditProfilePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  TextEditingController nameController = TextEditingController();
  bool isLoading = false;

  Uint8List webImage = Uint8List(8);

  @override
  void initState() {
    super.initState();
    nameController.text = FirebaseAuth.instance.currentUser!.displayName ?? '';
  }

  @override
  void dispose() {
    nameController.dispose();
    webImage = Uint8List(8);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff1A1A1A),
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Profili Düzenle',
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
          SingleChildScrollView(
            child: Column(
              children: [
                img(context),
                SpaceHelper.boslukHeight(context, 0.02),
                _fotoyuDegistirText,
                SpaceHelper.boslukHeight(context, 0.03),
                nameField(context),
                SpaceHelper.boslukHeight(context, 0.03),
                FirebaseAuth.instance.currentUser!.email != null
                    ? Column(
                        children: [
                          emailField(context),
                          Row(
                            children: [
                              SpaceHelper.boslukWidth(context, 0.05),
                              Expanded(
                                child: Text(
                                  'Mail adresi değiştirilemez.',
                                  overflow: TextOverflow.clip,
                                  style: GoogleFonts.poppins(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.035,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white70,
                                  ),
                                ),
                              ),
                              SpaceHelper.boslukWidth(context, 0.05),
                            ],
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          numberField(context),
                          Row(
                            children: [
                              SpaceHelper.boslukWidth(context, 0.05),
                              Text(
                                'Telefon numarası değiştirilemez.',
                                overflow: TextOverflow.clip,
                                style: GoogleFonts.poppins(
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.035,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white70,
                                ),
                              ),
                              SpaceHelper.boslukWidth(context, 0.05),
                            ],
                          ),
                        ],
                      ),
                SpaceHelper.boslukHeight(context, 0.03),
                updateBtn(context),
              ],
            ),
          ),
          loadingWidget(),
        ],
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

  GestureDetector img(BuildContext context) {
    return GestureDetector(
      onTap: _galeridenSec,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: _fotoGetir(),
      ),
    );
  }

  ElevatedButton updateBtn(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        if (nameController.text.isEmpty) {
          DialogHelper.getCustomErrorDialog(
            title: 'Hata',
            subtitle: 'İsim alanı boş bırakılamaz.',
          );
          return;
        } else if (nameController.text.length < 3) {
          DialogHelper.getCustomErrorDialog(
            title: 'Hata',
            subtitle: 'İsim alanı en az 3 karakter olmalıdır.',
          );
          return;
        }
        update();
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
        'Güncelle',
        style: GoogleFonts.poppins(
          fontSize: MediaQuery.of(context).size.width * 0.038,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
      ),
    );
  }

  update() async {
    try {
      setState(() {
        isLoading = true;
      });
      String profilFotoUrl = '';
      if (webImage.length == 8) {
        profilFotoUrl = FirebaseAuth.instance.currentUser!.photoURL!;
      } else {
        profilFotoUrl = await StorageService().uploadFile(webImage);
      }

      User? user = FirebaseAuth.instance.currentUser;

      await FirestoreService().updateUserDetails(
        id: user!.uid.toString(),
        email: user.email.toString(),
        phoneNumber: user.phoneNumber.toString(),
        name: nameController.text,
        photoUrl: profilFotoUrl == '' ? user.photoURL! : profilFotoUrl,
      );
      setState(() {
        isLoading = false;
      });

      Navigator.pushAndRemoveUntil(
        GlobalcontextService.navigatorKey.currentContext!,
        MaterialPageRoute(
          builder: (context) => const YonlendirmePage(),
        ),
        (route) => false,
      );
    } catch (e) {
      debugPrint('Hata: $e');
      setState(() {
        isLoading = false;
      });
      DialogHelper.getCustomErrorDialog(
        title: 'Hata',
        subtitle: 'Bir hata oluştu: $e',
      );
    }
  }

  _fotoGetir() {
    if (webImage.length == 8) {
      return Image.network(
        FirebaseAuth.instance.currentUser!.photoURL!,
        fit: BoxFit.cover,
        height: MediaQuery.of(context).size.height * 0.18,
        width: MediaQuery.of(context).size.height * 0.18,
      );
    } else {
      return Image.memory(
        webImage,
        height: MediaQuery.of(context).size.height * 0.18,
        width: MediaQuery.of(context).size.height * 0.18,
        fit: BoxFit.cover,
      );
    }
  }

  _galeridenSec() async {
    // var image = await ImagePicker().pickImage(source: ImageSource.gallery);
    // var f = await image!.readAsBytes();

    await PermissionHandlerWeb().requestPermissions([
      Permission.camera,
      Permission.microphone,
      Permission.photos,
    ]);

    Uint8List? bytesFromPicker = await ImagePickerWeb.getImageAsBytes();

    setState(() {
      webImage = bytesFromPicker!;
    });
  }

  Widget get _fotoyuDegistirText => TextButton(
      onPressed: _galeridenSec,
      child: Text(
        'Profil Fotoğrafını Değiştir',
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ));

  nameField(BuildContext context) {
    return Row(
      children: [
        SpaceHelper.boslukWidth(context, 0.05),
        Expanded(
          child: CupertinoTextField(
            onTapOutside: (_) {
              FocusScope.of(context).unfocus();
            },
            maxLength: 30,
            cursorColor: Colors.white,
            controller: nameController,
            padding: const EdgeInsets.all(18.0),
            placeholder: 'İsmini Gir',
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
                color: Colors.white54,
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

  // emailField
  emailField(BuildContext context) {
    return Row(
      children: [
        SpaceHelper.boslukWidth(context, 0.05),
        Expanded(
          child: CupertinoTextField(
            readOnly: true,
            cursorColor: Colors.white,
            controller: TextEditingController()
              ..text = FirebaseAuth.instance.currentUser!.email ?? '',
            padding: const EdgeInsets.all(18.0),
            placeholder: 'Mail Adresini Gir',
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
                color: Colors.white54,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            prefixMode: OverlayVisibilityMode.always,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
          ),
        ),
        SpaceHelper.boslukWidth(context, 0.05),
      ],
    );
  }

  numberField(BuildContext context) {
    return Row(
      children: [
        SpaceHelper.boslukWidth(context, 0.05),
        Expanded(
          child: CupertinoTextField(
            readOnly: true,
            cursorColor: Colors.white,
            controller: TextEditingController()
              ..text = FirebaseAuth.instance.currentUser!.phoneNumber ?? '',
            padding: const EdgeInsets.all(18.0),
            placeholder: '555 555 5555',
            placeholderStyle: GoogleFonts.poppins(
              color: Colors.white.withOpacity(0.3),
              fontWeight: FontWeight.w400,
              fontSize: MediaQuery.of(context).size.width * 0.038,
            ),
            prefix: Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: Text(
                '+90',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                  fontSize: MediaQuery.of(context).size.width * 0.04,
                ),
              ),
            ),
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w400,
              fontSize: MediaQuery.of(context).size.width * 0.04,
            ),
            decoration: BoxDecoration(
              color: const Color(0xff1A1A1A),
              border: Border.all(
                color: Colors.white54,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            prefixMode: OverlayVisibilityMode.always,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
          ),
        ),
        SpaceHelper.boslukWidth(context, 0.05),
      ],
    );
  }
}
