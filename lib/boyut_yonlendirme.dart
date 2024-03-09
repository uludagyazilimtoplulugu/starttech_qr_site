import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:starttech_qr/desktop/desktop_yonlendirme.dart';
import 'package:starttech_qr/yonlendirme.dart';

class BoyutYonlendirmePage extends ConsumerStatefulWidget {
  const BoyutYonlendirmePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _BoyutYonlendirmePageState();
}

class _BoyutYonlendirmePageState extends ConsumerState<BoyutYonlendirmePage> {
  @override
  Widget build(BuildContext context) {
    // width < 600 ? MobileMainPage() : DesktopMainPage();
    if (MediaQuery.of(context).size.width < 600) {
      return const MobilYonlendirmePage();
    } else {
      return const DesktopYonlendirmePage();
    }
  }
}
