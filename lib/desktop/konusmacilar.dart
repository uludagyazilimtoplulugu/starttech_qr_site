import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:starttech_qr/main.dart';
import 'package:starttech_qr/models/qr_code.dart';
import 'package:starttech_qr/services/firestore_service.dart';

class KonusmacilarPage extends ConsumerStatefulWidget {
  const KonusmacilarPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _KonusmacilarPageState();
}

class _KonusmacilarPageState extends ConsumerState<KonusmacilarPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          TextEditingController titleController = TextEditingController();
          TextEditingController descriptionController = TextEditingController();
          TextEditingController photoUrlController = TextEditingController();
          TextEditingController pointController = TextEditingController();
          bool isLoading = false;
          showDialog(
            context: context,
            builder: (context) {
              return StatefulBuilder(builder: (context, setState2) {
                return AlertDialog(
                  title: const Text('Konuşmacı Ekle'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                      ),
                      TextFormField(
                        controller: titleController,
                        decoration: const InputDecoration(
                          labelText: 'Konuşmacı Adı',
                        ),
                      ),
                      TextFormField(
                        controller: descriptionController,
                        decoration: const InputDecoration(
                          labelText: 'Konuşmacı Açıklaması',
                        ),
                      ),
                      TextFormField(
                        controller: photoUrlController,
                        decoration: const InputDecoration(
                          labelText: 'Konuşmacı Fotoğrafı',
                        ),
                      ),
                      TextFormField(
                        controller: pointController,
                        decoration: const InputDecoration(
                          labelText: 'Puan',
                        ),
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Vazgeç'),
                    ),
                    isLoading
                        ? const Text(
                            'EKLENDİ',
                          )
                        : TextButton(
                            onPressed: () async {
                              setState2(() {
                                isLoading = true;
                              });
                              setState(() {});
                              await FirestoreService().addSpeakerToFirestore(
                                title: titleController.text,
                                description: descriptionController.text,
                                photoUrl: photoUrlController.text,
                                point: int.parse(pointController.text),
                              );
                              Navigator.pop(GlobalcontextService
                                  .navigatorKey.currentContext!);
                            },
                            child: const Text('Ekle'),
                          ),
                  ],
                );
              });
            },
          );
        },
        child: const Icon(Icons.add),
      ),
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xff1A1A1A),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Stantlar',
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
          future: FirestoreService().getSpeakers(),
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
              List<CustomQRCode> users = snapshot.data;
              return ListView.separated(
                separatorBuilder: (context, index) => const Divider(
                  color: Colors.white54,
                ),
                itemCount: users.length,
                itemBuilder: ((context, index) {
                  return ListTile(
                    title: Text(
                      '${users[index].title} - ${users[index].qrCode}',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                      ),
                    ),
                    subtitle: Text(
                      users[index].description,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                      ),
                    ),
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                        users[index].photoUrl,
                      ),
                    ),
                    trailing: Text(
                      snapshot.data[index].point.toString(),
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                      ),
                    ),
                  );
                }),
              );
            }
          }),
        ),
      ),
    );
  }
}
