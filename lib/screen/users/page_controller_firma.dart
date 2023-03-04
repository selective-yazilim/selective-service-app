import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:selective/screen/cancel/iptal.dart';
import 'package:selective/screen/cancel/iptal_firma.dart';
import 'package:selective/screen/info/info.dart';
import 'package:selective/screen/users/firma.dart';
import 'package:selective/screen/users/firma_add.dart';
import 'package:selective/screen/users/user.dart';
import 'package:selective/utils/color.dart';
import 'package:selective/utils/text.dart';

class page_controller_firma_screen extends StatefulWidget {
  const page_controller_firma_screen({super.key});

  @override
  State<page_controller_firma_screen> createState() =>
      _page_controller_firma_screenState();
}

class _page_controller_firma_screenState
    extends State<page_controller_firma_screen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: colors().mainColor,
          centerTitle: false,
          title: Row(
            children: [
              CircleAvatar(
                backgroundColor: colors().mainColor,
                radius: 20,
                child: Image(
                  image: AssetImage(logo),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Text(Selective),
            ],
          ),
          bottom: TabBar(
            indicatorWeight: 3,
            indicatorColor: Colors.white,
            // isScrollable: true,
            tabs: [
              Tab(
                text: Kullanicisayfa,
              ),
              Tab(
                text: Iptaltalepsayfa,
              ),
              Tab(
                text: Bilgi,
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [user_screen(), iptal_screen_firma(), info_scren()],
        ),
      ),
    );
  }
}
