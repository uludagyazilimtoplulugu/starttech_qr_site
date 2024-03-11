import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:starttech_qr/boyut_yonlendirme.dart';
import 'package:starttech_qr/firebase_options.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Supabase.initialize(
    url: 'https://sazzqynqdkupdywyuais.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNhenpxeW5xZGt1cGR5d3l1YWlzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDk2NzcyMTIsImV4cCI6MjAyNTI1MzIxMn0.8tjsocAuP4nCb7d9Ctmfs2RmwBR6UWnu5217aFm3ncM',
  );

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class GlobalcontextService {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: GlobalcontextService.navigatorKey,
      title: 'StartTech',
      theme: ThemeData.dark(),
      home: const BoyutYonlendirmePage(),
      // home: ScoreBoardPage(),
    );
  }
}
