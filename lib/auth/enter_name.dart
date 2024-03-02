import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:starttech_qr/helpers/space.dart';

class EnterNamePage extends ConsumerStatefulWidget {
  const EnterNamePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EnterNamePageState();
}

class _EnterNamePageState extends ConsumerState<EnterNamePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xff1A1A1A),
      appBar: AppBar(
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
      body: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.05,
              ),
              Text(
                'Adını Gir',
                style: GoogleFonts.poppins(
                  fontSize: MediaQuery.of(context).size.width * 0.07,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.007,
          ),
          Row(
            children: [
              SpaceHelper.boslukWidth(context, 0.05),
              Expanded(
                child: Text(
                  'QR kodunu okutanların seni tanıyabilmesi için adını gir. (Bu adı daha sonra değiştirebilirsin.)',
                  overflow: TextOverflow.clip,
                  style: GoogleFonts.poppins(
                    fontSize: MediaQuery.of(context).size.width * 0.03,
                    fontWeight: FontWeight.w400,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ),
              SpaceHelper.boslukWidth(context, 0.05),
            ],
          ),
          Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.05,
              ),
              ElevatedButton(
                onPressed: () {},
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.05,
                    ),
                    Text(
                      'Devam Et',
                      style: GoogleFonts.poppins(
                        fontSize: MediaQuery.of(context).size.width * 0.035,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
