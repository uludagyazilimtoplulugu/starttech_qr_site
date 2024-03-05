import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:starttech_qr/models/qr_code.dart';
import 'package:starttech_qr/models/user.dart';
import 'package:starttech_qr/services/firestore_service.dart';

class ScannedQRCodesPage extends ConsumerStatefulWidget {
  const ScannedQRCodesPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ScannedQRCodesPageState();
}

class _ScannedQRCodesPageState extends ConsumerState<ScannedQRCodesPage>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          labelStyle: GoogleFonts.poppins(
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
          unselectedLabelStyle: GoogleFonts.poppins(
            fontWeight: FontWeight.w400,
            color: Colors.white30,
          ),
          indicatorColor: Colors.white,
          tabs: const <Widget>[
            Tab(
              text: 'Kullanıcılar',
            ),
            Tab(
              text: 'Stantlar',
            ),
            Tab(
              text: 'Sunumlar',
            ),
          ],
        ),
        title: Text(
          'Taranan QR Kodları',
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
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          scannedUsersTab,
          scannedStandsTab,
          scannedPresentationsTab,
        ],
      ),
    );
  }

  Widget get scannedUsersTab {
    return FutureBuilder(
      future: FirestoreService().getCurrentUserScannedQrCodes(
        uid: FirebaseAuth.instance.currentUser!.uid,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          List<FirestoreUser>? users = snapshot.data;
          if (users!.isEmpty) {
            return Center(
              child: Text(
                'Henüz hiçbir kullanıcı taranmamış.',
                style: GoogleFonts.poppins(
                  fontSize: MediaQuery.of(context).size.width * 0.04,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
            );
          }
          return ListView.separated(
            separatorBuilder: (context, index) {
              return const Divider(
                color: Colors.white30,
              );
            },
            itemCount: users.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(
                    users[index].name,
                    style: GoogleFonts.poppins(
                      fontSize: MediaQuery.of(context).size.width * 0.04,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                  subtitle: Text(
                    users[index].email == 'null' ? '' : users[index].email,
                    style: GoogleFonts.poppins(
                      fontSize: MediaQuery.of(context).size.width * 0.03,
                      fontWeight: FontWeight.w400,
                      color: Colors.white30,
                    ),
                  ),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      users[index].photoUrl,
                      width: MediaQuery.of(context).size.width * 0.1,
                      height: MediaQuery.of(context).size.width * 0.1,
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
                    ),
                  ),
                ),
              );
            },
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget get scannedStandsTab {
    return FutureBuilder(
      future: FirestoreService().getCurrentUserScannedQrCodesFromQrCodes(
        uid: FirebaseAuth.instance.currentUser!.uid,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          List<CustomQRCode>? qrCodes = snapshot.data;
          for (var element in qrCodes!) {
            if (element.type != 'stant') {
              qrCodes.remove(element);
            }
          }
          if (qrCodes.isEmpty) {
            return Center(
              child: Text(
                'Henüz hiçbir stant taranmamış.',
                style: GoogleFonts.poppins(
                  fontSize: MediaQuery.of(context).size.width * 0.04,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
            );
          }
          return ListView.separated(
            separatorBuilder: (context, index) {
              return const Divider(
                color: Colors.white30,
              );
            },
            itemCount: qrCodes.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(
                    qrCodes[index].title,
                    style: GoogleFonts.poppins(
                      fontSize: MediaQuery.of(context).size.width * 0.04,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      qrCodes[index].photoUrl,
                      width: MediaQuery.of(context).size.width * 0.1,
                      height: MediaQuery.of(context).size.width * 0.1,
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
                    ),
                  ),
                ),
              );
            },
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget get scannedPresentationsTab {
    return FutureBuilder(
      future: FirestoreService().getCurrentUserScannedQrCodesFromQrCodes(
        uid: FirebaseAuth.instance.currentUser!.uid,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          List<CustomQRCode>? qrCodes = snapshot.data;
          for (var element in qrCodes!) {
            if (element.type != 'speaker') {
              qrCodes.remove(element);
            }
          }
          if (qrCodes.isEmpty) {
            return Center(
              child: Text(
                'Henüz hiçbir sunum taranmamış.',
                style: GoogleFonts.poppins(
                  fontSize: MediaQuery.of(context).size.width * 0.04,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
            );
          }
          return ListView.separated(
            separatorBuilder: (context, index) {
              return const Divider(
                color: Colors.white30,
              );
            },
            itemCount: qrCodes.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(
                    qrCodes[index].title,
                    style: GoogleFonts.poppins(
                      fontSize: MediaQuery.of(context).size.width * 0.04,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      qrCodes[index].photoUrl,
                      width: MediaQuery.of(context).size.width * 0.1,
                      height: MediaQuery.of(context).size.width * 0.1,
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
                    ),
                  ),
                ),
              );
            },
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
