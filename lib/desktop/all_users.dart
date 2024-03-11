import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:starttech_qr/models/user.dart';
import 'package:starttech_qr/services/firestore_service.dart';

class AllUsersPage extends ConsumerStatefulWidget {
  const AllUsersPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AllUsersPageState();
}

class _AllUsersPageState extends ConsumerState<AllUsersPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xff1A1A1A),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Tüm Katılımcılar',
          style: GoogleFonts.poppins(
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
            future: FirestoreService().getAllUsers(),
            builder: ((context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator(
                  color: Colors.white,
                );
              } else if (snapshot.hasError) {
                return Text(
                  'Hata: ${snapshot.error}',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                  ),
                );
              } else {
                List<FirestoreUser> users = snapshot.data;
                return ListView.separated(
                  separatorBuilder: (context, index) => const Divider(
                    color: Colors.white54,
                  ),
                  itemCount: users.length,
                  itemBuilder: ((context, index) {
                    return ListTile(
                        title: Text(
                          '${users[index].name} - ${users[index].qrCode}',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                          ),
                        ),
                        subtitle: Text(
                          users[index].email == 'null'
                              ? '${users[index].phoneNumber} - ${users[index].uid}'
                              : '${users[index].email} - ${users[index].uid}',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                          ),
                        ),
                        isThreeLine: true,
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                            snapshot.data[index].photoUrl,
                          ),
                        ),
                        trailing: Text(
                          snapshot.data[index].point.toString(),
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                          ),
                        ));
                  }),
                );
              }
            })),
      ),
    );
  }
}
