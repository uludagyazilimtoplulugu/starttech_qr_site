import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:starttech_qr/helpers/space.dart';
import 'package:starttech_qr/models/user.dart';
import 'package:starttech_qr/services/firestore_service.dart';

class UsersScannesMyQRPage extends ConsumerStatefulWidget {
  const UsersScannesMyQRPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UsersScannesMyQRPageState();
}

class _UsersScannesMyQRPageState extends ConsumerState<UsersScannesMyQRPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff1A1A1A),
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'QR Kodumu Tarayanlar',
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
      body: Center(
        child: FutureBuilder(
          future: FirestoreService().getScannedUsersWithQrCode(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            if (snapshot.hasError) {
              return Text(
                'Error: ${snapshot.error}',
                style: GoogleFonts.poppins(
                  fontSize: MediaQuery.of(context).size.width * 0.05,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              );
            }
            List<FirestoreUser> users = snapshot.data;
            if (users.isEmpty) {
              return Text(
                'Henüz kimse QR kodunuzu tarayıp puan kazanmamış.',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: MediaQuery.of(context).size.width * 0.05,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              );
            }
            return ListView.separated(
              separatorBuilder: (context, index) => Column(
                children: [
                  SpaceHelper.boslukHeight(context, 0.01),
                  const Divider(
                    color: Colors.white30,
                  ),
                  SpaceHelper.boslukHeight(context, 0.01),
                ],
              ),
              itemCount: users.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    users[index].name,
                    style: GoogleFonts.poppins(
                      fontSize: MediaQuery.of(context).size.width * 0.038,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                  subtitle: users[index].email.toString() == 'null'
                      ? null
                      : Text(
                          users[index].email,
                          style: GoogleFonts.poppins(
                            fontSize: MediaQuery.of(context).size.width * 0.035,
                            fontWeight: FontWeight.w400,
                            color: Colors.white38,
                          ),
                        ),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      users[index].photoUrl,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.error,
                          color: Colors.white,
                        );
                      },
                      width: MediaQuery.of(context).size.width * 0.15,
                      height: MediaQuery.of(context).size.width * 0.15,
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
