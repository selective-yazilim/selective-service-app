import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:selective/screen/users/users_add.dart';
import 'package:selective/utils/color.dart';
import 'package:selective/utils/text.dart';
import 'package:selective/widget/post_card.dart';
import 'package:selective/widget/post_card_users.dart';

class user_screen extends StatefulWidget {
  const user_screen({super.key});

  @override
  State<user_screen> createState() => _user_screenState();
}

class _user_screenState extends State<user_screen> {
  late Stream filter;
  String filterdurum = "";
  String filterfirma = "";
  int filterhidden = 0;
  int yetki = 1;
  String firma = "";
  int isloading = 0;

  gel() async {
    isloading = 1;
    var userSnap = await FirebaseFirestore.instance
        .collection('users')
        .doc(
          FirebaseAuth.instance.currentUser!.uid,
        )
        .get();

    yetki = userSnap.data()!['yetki'];
    firma = userSnap.data()!["firma"];
    isloading = 0;
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    gel();
  }

  sorgu() {
    print(filterdurum);
    if (yetki == 1) {
      if (filterdurum == "" && filterfirma == "") {
        filter = FirebaseFirestore.instance
            .collection('users')
            .where("durum", isEqualTo: "Aktif")
            .where("firma", isEqualTo: firma)
            .snapshots();
      } else if (filterdurum != "") {
        filter = FirebaseFirestore.instance
            .collection('users')
            .where("durum", isEqualTo: filterdurum)
            .where("firma", isEqualTo: firma)
            .snapshots();
      }
    } else {
      if (filterdurum == "" && filterfirma == "") {
        filter = FirebaseFirestore.instance
            .collection('users')
            .where("durum", isEqualTo: "Aktif")
            .snapshots();
      } else if (filterdurum != "" && filterfirma == "") {
        filter = FirebaseFirestore.instance
            .collection('users')
            .where("durum", isEqualTo: filterdurum)
            .snapshots();
      } else if (filterdurum == "" && filterfirma != "") {
        filter = FirebaseFirestore.instance
            .collection('users')
            .where("firma", isEqualTo: filterfirma)
            .where("durum", isEqualTo: "Aktif")
            .snapshots();
      } else if (filterdurum != "" && filterfirma != "") {
        filter = FirebaseFirestore.instance
            .collection('users')
            .where("firma", isEqualTo: filterfirma)
            .where("durum", isEqualTo: filterdurum)
            .snapshots();
      }
    }

    setState(() {});
    return filter;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isloading == 1
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                filtersystem(),
                StreamBuilder(
                  stream: sorgu(),
                  builder: (context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                          snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    return Expanded(
                      child: ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (ctx, index) => Container(
                          child: PostCard_user(
                            sayfa: 3,
                            snap: snapshot.data!.docs[index].data(),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
      floatingActionButton: yetki == 1
          ? Container()
          : FloatingActionButton(
              backgroundColor: colors().mainColor,
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => users_add_screen(),
                    ));
              },
              child: Icon(
                Icons.add,
                color: colors().white,
              ),
            ),
    );
  }

  Container filtersystem() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          filterhidden == 1
              ? Container(
                  width: MediaQuery.of(context).size.width - 80,
                  decoration: BoxDecoration(
                    color: colors().white,
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    border: Border.all(
                      color: Colors.white,
                    ),
                  ),
                  child: DropdownSearch<String>(
                    selectedItem: "",
                    dropdownDecoratorProps: DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                        border: InputBorder.none,
                        labelText: "Durum",
                      ),
                    ),
                    items: ["Aktif", "Pasif"],
                    onChanged: (value) {
                      filterdurum = value.toString();
                    },
                  ),
                )
              : Container(),
          filterhidden == 1
              ? yetki != 1
                  ? filtercombo(
                      "firma", "Firma Filtrele", filterfirma, "firma_name")
                  : Container()
              : Container(),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(colors().secondColor),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                    )),
                onPressed: () {
                  if (filterhidden == 0) {
                    filterhidden = 1;
                    setState(() {
                      filterhidden;
                    });
                    print(filterhidden);
                  } else {
                    sorgu();
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(Filtrele),
                    SizedBox(
                      width: 5,
                    ),
                    Icon(Icons.filter_alt_rounded),
                  ],
                )),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              filterhidden == 1
                  ? Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  colors().mainColor),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30)),
                                ),
                              )),
                          onPressed: () {
                            if (filterhidden == 1) {
                              filterhidden = 0;
                              setState(() {
                                filterhidden;
                              });
                              print(filterhidden);
                            }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(FiltreGizle),
                              SizedBox(
                                width: 5,
                              ),
                              Icon(Icons.filter_alt_off_rounded),
                            ],
                          )),
                    )
                  : Container(),
              filterhidden == 1
                  ? Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  colors().threeColor),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30)),
                                ),
                              )),
                          onPressed: () {
                            if (filterhidden == 1) {
                              filterhidden = 0;
                              filterdurum = "";

                              filterfirma = "";

                              setState(() {
                                filterhidden;
                                filterdurum;
                              });
                              print(filterhidden);
                            }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(FiltreKaldir),
                              SizedBox(
                                width: 5,
                              ),
                              Icon(Icons.close),
                            ],
                          )),
                    )
                  : Container(),
            ],
          )
        ],
      ),
    );
  }

  StreamBuilder<QuerySnapshot<Map<String, dynamic>>> filtercombo(
      String filtercolection, String label, String control, String dataname) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection(filtercolection)
          .snapshots(includeMetadataChanges: true),
      builder: (context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width - 80,
                decoration: BoxDecoration(
                  color: colors().white,
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  border: Border.all(
                    color: colors().white,
                  ),
                ),
                child: DropdownSearch<String>(
                  selectedItem: control,
                  dropdownDecoratorProps: DropDownDecoratorProps(
                    dropdownSearchDecoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: label,
                    ),
                  ),
                  items: snapshot.data!.docs
                      .map((DocumentSnapshot document) {
                        Map<String, dynamic> data =
                            document.data()! as Map<String, dynamic>;

                        return data[dataname];
                      })
                      .toList()
                      .cast<String>(),
                  onChanged: (value) {
                    if (filtercolection == "users") {
                      filterdurum = value.toString();
                    }

                    if (filtercolection == "firma") {
                      filterfirma = value.toString();
                    }
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
