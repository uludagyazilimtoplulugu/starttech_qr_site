import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:starttech_qr/helpers/space.dart';
import 'package:starttech_qr/models/user.dart';
import 'package:starttech_qr/services/firestore_service.dart';

class ScoreBoardPage extends ConsumerStatefulWidget {
  const ScoreBoardPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ScoreBoardPageState();
}

class _ScoreBoardPageState extends ConsumerState<ScoreBoardPage> {
  int _counter = 0;
  List<FirestoreUser> users = [];
  bool isLoading = true;
  bool isError = false;

  @override
  void initState() {
    super.initState();
    FirestoreService().getAllUsersOrderByPoint().then((value) {
      users = value;
      setState(() {
        isLoading = false;
      });
      Timer.periodic(const Duration(seconds: 1), (timer) {
        _increment();
        if (_counter == 10) {
          timer.cancel();
        }
      });
    });
  }

  void _increment() {
    setState(() {
      _counter++;
    });
  }

  void _decrement() {
    setState(() {
      _counter--;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xff1A1A1A),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Skor Tablosu',
          style: GoogleFonts.poppins(
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
      body: isLoading ? loadingWidget() : body(context),
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

  SingleChildScrollView body(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
          ),
          SpaceHelper.boslukHeight(context, 0.02),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              third(context),
              first(context),
              second(context),
            ],
          ),
          AnimatedOpacity(
            duration: const Duration(seconds: 1),
            opacity: _counter > 9 ? 1.0 : 0.0,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                ),
                child: ListView.separated(
                  separatorBuilder: (context, index) {
                    if (index == 0 || index == 1 || index == 2) {
                      return const SizedBox();
                    }
                    return const Divider(
                      color: Colors.white24,
                    );
                  },
                  itemCount: users.length > 50 ? 50 : users.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: ((context, index) {
                    if (index == 0 || index == 1 || index == 2) {
                      return const SizedBox();
                    }
                    return ListTile(
                      title: Text(
                        '${users[index].name} ',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                      subtitle: Text(
                        '${users[index].point} Puan',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                      leading: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${index + 1}.   ',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          CircleAvatar(
                            backgroundImage: NetworkImage(
                              users[index].photoUrl,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Column second(BuildContext context) {
    return Column(
      children: [
        AnimatedOpacity(
          duration: const Duration(seconds: 1),
          opacity: _counter > 4 ? 1.0 : 0.0,
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  users[1].photoUrl,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    } else {
                      return const CircularProgressIndicator();
                    }
                  },
                  errorBuilder: (BuildContext context, Object error,
                      StackTrace? stackTrace) {
                    return const Icon(
                      Icons.error,
                      color: Colors.red,
                    );
                  },
                  height: MediaQuery.of(context).size.height * 0.18,
                  width: MediaQuery.of(context).size.height * 0.18,
                  fit: BoxFit.cover,
                ),
              ),
              SpaceHelper.boslukHeight(context, 0.02),
              Text(
                users[1].name,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: Colors.white,
                ),
              ),
              Text(
                '${users[1].point} Puan',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                  color: Colors.grey,
                ),
              ),
              SpaceHelper.boslukHeight(context, 0.02),
            ],
          ),
        ),
        AnimatedContainer(
          duration: const Duration(seconds: 1),
          curve: Curves.fastEaseInToSlowEaseOut,
          height: _counter > 3 ? MediaQuery.of(context).size.height * 0.3 : 0,
          width: MediaQuery.of(context).size.width * 0.12,
          decoration: const BoxDecoration(
            color: Colors.grey,
          ),
          child: Center(
            child: Text(
              '2',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 100,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Column first(BuildContext context) {
    return Column(
      children: [
        AnimatedOpacity(
          duration: const Duration(seconds: 1),
          opacity: _counter > 7 ? 1.0 : 0.0,
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  users.first.photoUrl,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    } else {
                      return const CircularProgressIndicator();
                    }
                  },
                  errorBuilder: (BuildContext context, Object error,
                      StackTrace? stackTrace) {
                    return const Icon(
                      Icons.error,
                      color: Colors.red,
                    );
                  },
                  height: MediaQuery.of(context).size.height * 0.18,
                  width: MediaQuery.of(context).size.height * 0.18,
                  fit: BoxFit.cover,
                ),
              ),
              SpaceHelper.boslukHeight(context, 0.02),
              Text(
                users.first.name,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: Colors.white,
                ),
              ),
              Text(
                '${users.first.point} Puan',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                  color: Colors.amber,
                ),
              ),
              SpaceHelper.boslukHeight(context, 0.02),
            ],
          ),
        ),
        AnimatedContainer(
          duration: const Duration(seconds: 1),
          curve: Curves.fastEaseInToSlowEaseOut,
          height: _counter > 6 ? MediaQuery.of(context).size.height * 0.4 : 0,
          width: MediaQuery.of(context).size.width * 0.12,
          decoration: const BoxDecoration(
            color: Colors.amber,
          ),
          child: Center(
            child: Text(
              '1',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 100,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Column third(BuildContext context) {
    return Column(
      children: [
        AnimatedOpacity(
          duration: const Duration(seconds: 1),
          opacity: _counter > 1 ? 1.0 : 0.0,
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  users[2].photoUrl,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    } else {
                      return const CircularProgressIndicator();
                    }
                  },
                  errorBuilder: (BuildContext context, Object error,
                      StackTrace? stackTrace) {
                    return const Icon(
                      Icons.error,
                      color: Colors.red,
                    );
                  },
                  height: MediaQuery.of(context).size.height * 0.18,
                  width: MediaQuery.of(context).size.height * 0.18,
                  fit: BoxFit.cover,
                ),
              ),
              SpaceHelper.boslukHeight(context, 0.02),
              Text(
                users[2].name,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: Colors.white,
                ),
              ),
              Text(
                '${users[2].point} Puan',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                  color: Colors.brown,
                ),
              ),
              SpaceHelper.boslukHeight(context, 0.02),
            ],
          ),
        ),
        AnimatedContainer(
          duration: const Duration(seconds: 1),
          curve: Curves.fastOutSlowIn,
          height: _counter > 0 ? MediaQuery.of(context).size.height * 0.2 : 0,
          width: MediaQuery.of(context).size.width * 0.12,
          decoration: const BoxDecoration(
            color: Colors.brown,
          ),
          child: Center(
            child: Text(
              '3',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 100,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
