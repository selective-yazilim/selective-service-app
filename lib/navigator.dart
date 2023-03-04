import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/material.dart';
import 'package:selective/screen/dashboard/dashboard.dart';
import 'package:selective/screen/home/home.dart';
import 'package:selective/screen/home/yetkili_home.dart';
import 'package:selective/screen/info/info.dart';
import 'package:selective/screen/succes_post/succes_post.dart';
import 'package:selective/screen/succes_post/yetkili_succes.dart';
import 'package:selective/screen/users/page_controller.dart';
import 'package:selective/screen/users/page_controller_cs.dart';
import 'package:selective/screen/users/page_controller_firma.dart';
import 'package:selective/screen/wait_post/wait_post.dart';
import 'package:selective/screen/wait_post/wait_yetkili.dart';

class navigator_screen extends StatefulWidget {
  final String uid;
  const navigator_screen({super.key, required this.uid});

  @override
  State<navigator_screen> createState() => _navigator_screenState();
}

class _navigator_screenState extends State<navigator_screen> {
  int _selectedIndex = 0;
  late PageController pageController;

  int yetki = 0;

  bool isLoading = false;

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();

      yetki = userSnap.data()!['yetki'];
      print(yetki);
      setState(() {});
    } catch (e) {
      print(e);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    getData();
  }

  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        padEnds: true,
        controller: pageController,
        onPageChanged: onPageChanged,
        children: [
          yetki == 3 ? yetklili_home() : yardim_talebi_ekran(),
          yetki == 3 ? wait_yetkili() : wait_post_screen(),
          yetki == 3 ? succes_yetkili() : succes_post_screen(),
          yetki == 2 || yetki == 3
              ? const page_controller_screen()
              : yetki == 0
                  ? const page_controller_cs_screen()
                  : page_controller_firma_screen(),
       
        ],
      ),
      bottomNavigationBar: FlashyTabBar(
        animationCurve: Curves.linear,
        selectedIndex: _selectedIndex,
        showElevation: true, // use this to remove appBar's elevation
        onItemSelected: (index) => setState(() {
          _selectedIndex = index;
          pageController.jumpToPage(_selectedIndex);
        }),
        items: [
          FlashyTabBarItem(
            icon: Icon(Icons.assignment_late_outlined),
            title: Text('Anasayfa'),
          ),
          FlashyTabBarItem(
            icon: Icon(Icons.watch_later_outlined),
            title: Text('İşleme Alınanlar'),
          ),
          FlashyTabBarItem(
            icon: Icon(Icons.assignment_turned_in_rounded),
            title: Text('Biten İşlemler'),
          ),
          yetki == 2 || yetki == 3
              ? FlashyTabBarItem(
                  icon: Icon(Icons.people_alt_outlined),
                  title: Text('Kullanıcılar'),
                )
              : FlashyTabBarItem(
                  icon: Icon(Icons.people_outline_rounded),
                  title: Text('İletişim'),
                ),
       
        ],
      ),
    );
  }
}
