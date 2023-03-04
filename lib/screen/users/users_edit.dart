import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:selective/services/auth.dart';
import 'package:selective/utils/color.dart';
import 'package:selective/utils/text.dart';

class users_edit_screen extends StatefulWidget {
  final userid;
  const users_edit_screen({super.key, required this.userid});

  @override
  State<users_edit_screen> createState() => _users_edit_screenState();
}

class _users_edit_screenState extends State<users_edit_screen> {
  TextEditingController firma = TextEditingController();
  TextEditingController gorev = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController mail = TextEditingController();
  TextEditingController sifre = TextEditingController();
  TextEditingController telefon = TextEditingController();
  TextEditingController yildiz = TextEditingController();

  String selectedValue = "0";
  authservices _auth = authservices();
  String _selectedValuefirma = "1";
  int yetki = 1;
  int isLoading = 0;
  var firmadata = {};
  List<String> firma_name = [];
  String esifre = "";
  getData() async {
    isLoading = 0;
    try {
      var collection = FirebaseFirestore.instance.collection('firma');
      var querySnapshot = await collection.get();
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data();
        firma_name.add(data['firma_name']); // <-- Retrieving the value.
      }
      var usersnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userid)
          .get();
      var userssnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      yetki = userssnap.data()!['yetki'];
      firma.text = usersnap.data()!['firma'];
      gorev.text = usersnap.data()!['gorev'];
      username.text = usersnap.data()!['username'];
      mail.text = usersnap.data()!['email'];
      telefon.text = usersnap.data()!['telefon'];
      sifre.text = usersnap.data()!['password'];
      selectedValue = usersnap.data()!['yetki'].toString();
      esifre = usersnap.data()!['password'];
      setState(() {
        selectedValue;
      });
    } catch (e) {
      print(e);
    }
    isLoading = 1;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Color.fromARGB(255, 171, 197, 225),
        centerTitle: false,
        title: Row(
          children: [
            SizedBox(
              width: 50,
            ),
            CircleAvatar(
              backgroundColor: Color.fromARGB(255, 171, 197, 225),
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
      ),
      body: isLoading == 0
          ? const Center(child: CircularProgressIndicator())
          : PageView(scrollDirection: Axis.vertical, children: [
              Padding(
                padding: EdgeInsets.all(8),
                child: Column(
                  children: [
                    Text(
                      kullaniciduzenle,
                      style: TextStyle(fontSize: 30),
                    ),
                    textfield(gorev, "Görevi", Icons.account_tree_outlined, 40,
                        yetki == 1 ? true : false),
                    textfield(username, "Adı - Soyadı",
                        Icons.account_circle_outlined, 40, true),
                    textfield(mail, "E-mail", Icons.mail_outline, 40,
                        yetki == 1 ? true : false),
                    textfield(
                        widget.userid == FirebaseAuth.instance.currentUser!.uid
                            ? sifre
                            : yildiz,
                        widget.userid == FirebaseAuth.instance.currentUser!.uid
                            ? "Kullanıcı şifresi"
                            : "*******",
                        Icons.lock,
                        40,
                        widget.userid == FirebaseAuth.instance.currentUser!.uid
                            ? false
                            : true),
                    textfield(telefon, "Telefon numarası", Icons.phone_android,
                        11, yetki == 1 ? true : false),
                    yetki == 1
                        ? Container()
                        : Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 8),
                            child: Row(
                              children: [
                                const Text(
                                  "Yetki Tipi :",
                                  style: TextStyle(fontSize: 15),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                DropdownButtonHideUnderline(
                                  child: DropdownButton(
                                      value: selectedValue,
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          selectedValue = newValue!;
                                        });

                                        setState(() {
                                          selectedValue = newValue!;
                                        });
                                      },
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                      iconSize: 20,
                                      icon: const Icon(Icons
                                          .arrow_drop_down_circle_outlined),
                                      dropdownColor: const Color.fromARGB(
                                          255, 171, 197, 225),
                                      items: dropdownItems),
                                ),
                              ],
                            ),
                          ),
                    yetki == 1
                        ? Container()
                        : StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('firma')
                                .snapshots(includeMetadataChanges: true),
                            builder: (context,
                                AsyncSnapshot<
                                        QuerySnapshot<Map<String, dynamic>>>
                                    snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }

                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 242, 242, 242),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(40)),
                                    border: Border.all(
                                      color: Colors.white,
                                    ),
                                  ),
                                  child: DropdownSearch<String>(
                                    dropdownDecoratorProps:
                                        DropDownDecoratorProps(
                                      dropdownSearchDecoration: InputDecoration(
                                        labelText: firma.text == ""
                                            ? "Firma "
                                            : firma.text,
                                      ),
                                    ),
                                    items: snapshot.data!.docs
                                        .map((DocumentSnapshot document) {
                                          Map<String, dynamic> data = document
                                              .data()! as Map<String, dynamic>;
                                          return data["firma_name"];
                                        })
                                        .toList()
                                        .cast<String>(),
                                    onChanged: (value) {
                                      firma.text = value.toString();
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                    SizedBox(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                        onPressed: () async {
                          print(FirebaseAuth.instance.currentUser!.uid);
                          _auth.updateuser(
                              firma: firma.text,
                              username: username.text,
                              gorev: gorev.text,
                              email: mail.text,
                              password: sifre.text,
                              telefon: telefon.text,
                              yetki: int.parse(selectedValue),
                              uid: widget.userid);
                          _auth.changePassword(esifre, sifre.text);
                          Navigator.pop(context);
                        },
                        child: Text(Kaydet),
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                              colors().mainColor,
                            ),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30)),
                              ),
                            )),
                      ),
                    )
                  ],
                ),
              ),
            ]),
    );
  }

  Padding textfield(TextEditingController controller, String hinttext,
      IconData icon, int max, bool yaz) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: SizedBox(
        height: 60,
        child: Material(
          //elevation: 8,
          // shadowColor: Colors.black87,
          // color: Colors.transparent,
          borderRadius: BorderRadius.circular(30),
          child: TextField(
            readOnly: yaz,
            maxLength: max,
            controller: controller,
            textAlignVertical: TextAlignVertical.bottom,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: colors().white,
              hintText: hinttext,
              prefixIcon: Icon(icon),
            ),
          ),
        ),
      ),
    );
  }

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> timeitems = [
      const DropdownMenuItem(
          value: "0",
          child: Text(
            "Firma Çalışan",
            style: TextStyle(fontSize: 14),
          )),
      const DropdownMenuItem(
          value: "1",
          child: Text(
            "Firma Yetkili",
            style: TextStyle(fontSize: 14),
          )),
      const DropdownMenuItem(
          value: "2",
          child: Text(
            "Selective Çalışan",
            style: TextStyle(fontSize: 14),
          )),
      const DropdownMenuItem(
          value: "3",
          child: Text(
            "Admin",
            style: TextStyle(fontSize: 14),
          )),
    ];
    return timeitems;
  }
}
