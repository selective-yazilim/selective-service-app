import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:selective/screen/users/firma_add.dart';
import 'package:selective/screen/users/users_add.dart';
import 'package:selective/utils/color.dart';
import 'package:selective/utils/text.dart';
import 'package:selective/widget/cards_model_firma.dart';
import 'package:selective/widget/post_card.dart';
import 'package:selective/widget/post_card_users.dart';

class firma_screen extends StatefulWidget {
  const firma_screen({super.key});

  @override
  State<firma_screen> createState() => _firma_screenState();
}

class _firma_screenState extends State<firma_screen> {
  late Stream filter;
  String filterdurum = "";
  String filterfirma = "";
  int filterhidden = 0;
  sorgu() {
    print(filterdurum);
    if (filterdurum == "") {
      filter = FirebaseFirestore.instance
          .collection('firma')
          .where("durum", isEqualTo: "Aktif")
          .snapshots();
    } else if (filterdurum != "") {
      filter = FirebaseFirestore.instance
          .collection('firma')
          .where("durum", isEqualTo: filterdurum)
          .snapshots();
    }
    setState(() {});
    return filter;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          filtersystem(),
          StreamBuilder(
            stream: sorgu(),
            builder: (context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return Expanded(
                child: ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (ctx, index) => Container(
                    child: cards_model_firma(
                      snap: snapshot.data!.docs[index].data(),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: colors().mainColor,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => firma_add_screen(),
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
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width - 80,
                    decoration: BoxDecoration(
                      color: colors().white,
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      border: Border.all(
                        color: colors().white,
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
                  ),
                )
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
}
