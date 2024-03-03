import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:starttech_qr/screens/home.dart';
import 'package:starttech_qr/screens/profile.dart';

class TabBarMain extends ConsumerStatefulWidget {
  const TabBarMain({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TabBarMainState();
}

class _TabBarMainState extends ConsumerState<TabBarMain>
    with SingleTickerProviderStateMixin {
  int currentIndex = 0;
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
  }

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xff1A1A1A),
      tabBar: CupertinoTabBar(
        backgroundColor: const Color(0xff1A1A1A),
        activeColor: Colors.white,
        inactiveColor: Colors.grey.withOpacity(0.6),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.qrcode),
            label: 'QR Kod',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person_fill),
            label: 'Aktivite',
          ),
        ],
      ),
      tabBuilder: (BuildContext context, int index) {
        return CupertinoTabView(
          builder: (BuildContext context) {
            if (index == 0) {
              return const HomePage();
            } else {
              return const ProfilePage();
            }
          },
        );
      },
    );
  }
}
