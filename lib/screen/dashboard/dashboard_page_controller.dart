import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:selective/screen/dashboard/ayrinti.dart';
import 'package:selective/screen/dashboard/dashboard.dart';
import 'package:selective/utils/color.dart';
import 'package:selective/utils/text.dart';

class dash_page_controller extends StatefulWidget {
  const dash_page_controller({super.key});

  @override
  State<dash_page_controller> createState() => _dash_page_controllerState();
}

class _dash_page_controllerState extends State<dash_page_controller> {
  int loading = 0;

  var yetki = 0;

  gel() async {
    loading = 0;
    var userSnap = await FirebaseFirestore.instance
        .collection('users')
        .doc(
          FirebaseAuth.instance.currentUser!.uid,
        )
        .get();

    yetki = userSnap.data()!['yetki'];
    loading = 1;
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    gel();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: yetki == 1 || yetki == 0 || yetki == 3 ? 2 : 1,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
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
            indicatorWeight: 2,
            indicatorColor: Colors.white,
            // isScrollable: true,
            tabs: [
              Tab(
                text: "Grafik",
              ),
              Tab(
                text: "Ayrıntılar",
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [dasboard_screen(), ayrinti_scrren()],
        ),
      ),
    );
  }
}
