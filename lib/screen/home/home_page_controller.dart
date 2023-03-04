import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:selective/screen/home/home.dart';
import 'package:selective/screen/home/yetkili_home.dart';

class home_page_controller extends StatefulWidget {
  const home_page_controller({super.key});

  @override
  State<home_page_controller> createState() => _home_page_controllerState();
}

class _home_page_controllerState extends State<home_page_controller> {
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
          automaticallyImplyLeading: false,
          backgroundColor: Color.fromARGB(255, 171, 197, 225),
          centerTitle: false,
          title: Row(
            children: const [
              CircleAvatar(
                backgroundColor: Color.fromARGB(255, 171, 197, 225),
                radius: 20,
                child: Image(
                  image: AssetImage("assets/logo.png"),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Text("Selective"),
            ],
          ),
          actions: [
            IconButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                },
                icon: Icon(Icons.login))
          ],
          bottom: TabBar(
            indicatorWeight: 3,
            indicatorColor: Colors.white,
            // isScrollable: true,
            tabs: yetki == 0 || yetki == 1 || yetki == 3
                ? [
                    yetki == 1
                        ? Tab(
                            text: "Onay Bekleyen Talepler",
                          )
                        : yetki == 0
                            ? Tab(
                                text: "Taleplerim",
                              )
                            : yetki == 3
                                ? Tab(
                                    text: "Müşteri Talepleri",
                                  )
                                : Container(),
                    yetki == 1 || yetki == 0
                        ? Tab(
                            text: " Selective Onayında ki Taleplerim",
                          )
                        : Tab(
                            text: "Atadığım Talepler",
                          ),
                  ]
                : [
                    Tab(
                      text: "Atanan Talepler",
                    ),
                  ],
          ),
        ),
        body: TabBarView(
          children: yetki == 0 || yetki == 1 || yetki == 3
              ? [
                  yardim_talebi_ekran(),
                  //succes_home_screen(),
                ]
              : [
                  yardim_talebi_ekran(),
                ],
        ),
      ),
    );
  }
}
