import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:selective/services/auth.dart';
import 'package:selective/utils/color.dart';
import 'package:selective/utils/text.dart';
import 'package:selective/utils/utils.dart';

class users_add_screen extends StatefulWidget {
  const users_add_screen({super.key});

  @override
  State<users_add_screen> createState() => _users_add_screenState();
}

class _users_add_screenState extends State<users_add_screen> {
  TextEditingController firma = TextEditingController();
  TextEditingController gorev = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController mail = TextEditingController();
  TextEditingController sifre = TextEditingController();
  TextEditingController telefon = TextEditingController();
  String selectedValue = "0";
  authservices _auth = authservices();
  String _selectedValuefirma = "1";

  int isLoading = 0;
  var firmadata = {};
  List<String> firma_name = [];

  getData() async {
    isLoading = 0;
    try {
      var collection = FirebaseFirestore.instance.collection('firma');
      var querySnapshot = await collection.get();
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data();
        firma_name.add(data['firma_name']); // <-- Retrieving the value.
      }

      setState(() {});
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
                      KullaniciKayit,
                      style: TextStyle(fontSize: 30),
                    ),
                    textfield(gorev, "Görevi", Icons.account_tree_outlined, 40),
                    textfield(username, "Adı - Soyadı",
                        Icons.account_circle_outlined, 40),
                    textfield(mail, "E-mail", Icons.mail_outline, 40),
                    textfield(sifre, "Kullanıcı şifresi", Icons.lock, 40),
                    textfield(
                        telefon, "Telefon numarası", Icons.phone_android, 11),
                    Padding(
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
                                icon: const Icon(
                                    Icons.arrow_drop_down_circle_outlined),
                                dropdownColor: colors().mainColor,
                                items: dropdownItems),
                          ),
                        ],
                      ),
                    ),
                    StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('firma')
                          .snapshots(includeMetadataChanges: true),
                      builder: (context,
                          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
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
                              color: colors().white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(40)),
                              border: Border.all(
                                color: Colors.white,
                              ),
                            ),
                            child: DropdownSearch<String>(
                              dropdownDecoratorProps: DropDownDecoratorProps(
                                dropdownSearchDecoration: InputDecoration(
                                  labelText: "Firma ",
                                ),
                              ),
                              items: snapshot.data!.docs
                                  .map((DocumentSnapshot document) {
                                    Map<String, dynamic> data = document.data()!
                                        as Map<String, dynamic>;
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
                          if (sifre.text.length < 6) {
                            showSnackBar(context, Sifreuzun);
                          } else {
                            print(FirebaseAuth.instance.currentUser!.uid);
                            if (firma.text == "" ||
                                username.text == "" ||
                                mail.text == "" ||
                                selectedValue.isEmpty) {
                              showSnackBar(context, bosbirakma);
                            } else {
                              try {
                                var usercontrol = await FirebaseFirestore
                                    .instance
                                    .collection('users')
                                    .where("username", isEqualTo: username.text)
                                    .get();
                                if (usercontrol.docs.isEmpty) {
                                  _auth.signUpUser(
                                      firma: firma.text,
                                      username: username.text.toLowerCase(),
                                      gorev: gorev.text,
                                      email: mail.text,
                                      password: sifre.text,
                                      telefon: telefon.text,
                                      yetki: int.parse(selectedValue));
                                  print(FirebaseAuth.instance.currentUser!.uid);
                                  Navigator.pop(context);
                                } else {
                                  showSnackBar(context, Kullanicialinmis);
                                }
                              } catch (e) {}
                            }
                          }
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
      IconData icon, int max) {
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
