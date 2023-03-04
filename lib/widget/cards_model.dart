import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:selective/notifications/notif.dart';
import 'package:selective/screen/home/add_descrip/comments_screen.dart';
import 'package:selective/screen/home/detail/detail.dart';
import 'package:selective/screen/home/edit/edit.dart';
import 'package:selective/services/firestore_methods.dart';
import 'package:selective/utils/color.dart';
import 'package:selective/utils/text.dart';
import 'package:selective/utils/utils.dart';

// ignore: non_constant_identifier_names
Widget card_model(BuildContext context, snap, int yetki, int page) {
  notifpush notif = notifpush();
  String durum = onaybekliyor;
  String parabirimi = "TL";
  String oncelik = "5";
  String? atanan;
  iptalpost(String postId, String durum, int sayfa) async {
    try {
      await FireStoreMethods().updatedurum(postId, durum, sayfa);
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }

  onayla(String postId, String durum, int sayfa, int dgr) async {
    try {
      await FireStoreMethods().updatedurums(postId, durum, sayfa, dgr);
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }

  atapost(String postId, String durum, String Satanan, int sayfa,
      String oncelik) async {
    try {
      await FireStoreMethods().islemata(postId, durum, Satanan, sayfa, oncelik);
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }

  moneyekle(String postId, String ucret) async {
    try {
      await FireStoreMethods().updatemoney(postId, ucret);
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }

  TextEditingController ucret = TextEditingController();
  Future popup(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            scrollable: true,
            title: Text(ServisBedeli),
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                //crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: TextFormField(
                      controller: ucret,
                      decoration: InputDecoration(
                        labelText: Tutar,
                      ),
                    ),
                  ),
                  DropdownSearch<String>(
                    dropdownDecoratorProps: DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                        labelText: parabirimi,
                      ),
                    ),
                    items: ["TL", "USD", "EURO"],
                    onChanged: (value) {
                      parabirimi = value.toString();
                    },
                  ),
                ],
              ),
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(Iptal),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          Color.fromARGB(255, 225, 171, 171),
                        ),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                          ),
                        )),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      durum = Firmaservisonayi;
                      String servisbedeli = "${ucret.text}  $parabirimi";
                      moneyekle(snap['postId'], servisbedeli);
                      iptalpost(snap['postId'], durum, 0);

                      Navigator.pop(context);
                    },
                    child: Text(Gonder),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          colors().mainColor,
                        ),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                          ),
                        )),
                  ),
                ],
              ),
            ],
          );
        });
  }

  Future popups(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            scrollable: true,
            title: Text(Islemata),
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                child: Column(
                  children: <Widget>[
                    StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .where("yetki", isEqualTo: 2)
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
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              Container(
                                width: 210,
                                decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 242, 242, 242),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(40)),
                                  border: Border.all(
                                    color: Colors.white,
                                  ),
                                ),
                                child: DropdownSearch<String>(
                                  dropdownDecoratorProps:
                                      DropDownDecoratorProps(
                                    dropdownSearchDecoration: InputDecoration(
                                      labelText: Islemata,
                                    ),
                                  ),
                                  items: snapshot.data!.docs
                                      .map((DocumentSnapshot document) {
                                        Map<String, dynamic> data = document
                                            .data()! as Map<String, dynamic>;

                                        return data["username"];
                                      })
                                      .toList()
                                      .cast<String>(),
                                  onChanged: (value) {
                                    atanan = value.toString();
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 210,
                          decoration: BoxDecoration(
                            color: colors().white,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(40)),
                            border: Border.all(
                              color: Colors.white,
                            ),
                          ),
                          child: DropdownSearch<String>(
                            selectedItem: "5-(Çok Düşük)",
                            dropdownDecoratorProps:
                                const DropDownDecoratorProps(
                              dropdownSearchDecoration: InputDecoration(
                                labelText: "Öncelik Sırası",
                              ),
                            ),
                            items: [
                              "1-(Yüksek Öncelikli)",
                              "2-(Öncelikli)",
                              "3-(Normal )",
                              "4-(Düşük )",
                              "5-(Çok Düşük)"
                            ],
                            onChanged: (value) {
                              oncelik = value.toString();
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  durum = "Selective Onayladı";
                  atapost(snap['postId'], durum, atanan!, 0, oncelik);
                  Navigator.pop(context);
                },
                child: Text("Gönder"),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      Color.fromARGB(255, 171, 197, 225),
                    ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                    )),
              ),
            ],
          );
        });
  }

  List<dynamic> resim = snap['images'];
  Widget headimage(int sayi) {
    return InkWell(
      onTap: () {
        showImageViewer(context, Image.network(resim[sayi]).image,
            swipeDismissible: true, doubleTapZoomable: true);
      },
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(30)),
            border: Border.all(
              color: Colors.white,
            ),
            color: Colors.grey[200],
          ),
          child: Image.network(resim[sayi], fit: BoxFit.cover)),
    );
  }

  Future secenekSayfa1yetki23() {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Wrap(
            children: [
              const Center(
                child: Icon(
                  Icons.linear_scale_outlined,
                  color: Colors.black,
                  size: 25,
                ),
              ),
              ListTile(
                iconColor: Colors.green,
                leading: const Icon(
                  Icons.remove_red_eye_sharp,
                ),
                title: TextButton(
                    onPressed: () {
                      Navigator.pop(context);

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                detail_screen(postid: snap['postId']),
                          ));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AyrintiGor,
                          style: TextStyle(color: Colors.black),
                          textAlign: TextAlign.start,
                        ),
                        SizedBox(
                          width: 50,
                        )
                      ],
                    )),
              ),
              ListTile(
                iconColor: Colors.orange,
                leading: const Icon(
                  Icons.task_alt_rounded,
                ),
                title: TextButton(
                    onPressed: () {
                      Navigator.pop(context);

                      durum = Islemtamamlandi;
                      iptalpost(snap['postId'], durum, 2);
                      notifpush().dataget(snap['postId'], 1, durum);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          Islemtamamla,
                          style: TextStyle(color: Colors.black),
                          textAlign: TextAlign.start,
                        ),
                        SizedBox(
                          width: 50,
                        )
                      ],
                    )),
              ),
              ListTile(
                iconColor: Colors.yellow[700],
                leading: const Icon(Icons.add_comment),
                title: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CommentsScreen(
                                postId: snap['postId'].toString()),
                          ));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          EkaciklamaGir,
                          style: TextStyle(color: Colors.black),
                        ),
                        SizedBox(
                          width: 50,
                        )
                      ],
                    )),
              ),
              yetki == 3
                  ? ListTile(
                      iconColor: Colors.red,
                      leading: const Icon(
                        Icons.cancel,
                      ),
                      title: TextButton(
                          onPressed: () {
                            Navigator.pop(context);

                            durum = IslemiptalEd;
                            iptalpost(snap['postId'], durum, 3);
                            notifpush().dataget(snap['postId'], 1, durum);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                Reddet,
                                style: TextStyle(color: Colors.black),
                                textAlign: TextAlign.start,
                              ),
                              SizedBox(
                                width: 50,
                              )
                            ],
                          )),
                    )
                  : Container(),
            ],
          );
        });
  }

  Future secenekSayfa0yetki23() {
    return showModalBottomSheet(
      // ana sayfa yetki 2-3 seçenekler
      context: context,
      builder: (context) {
        return Wrap(
          children: [
            const Center(
              child: Icon(
                Icons.linear_scale_outlined,
                color: Colors.black,
                size: 25,
              ),
            ),
            ListTile(
              iconColor: Colors.green,
              leading: const Icon(
                Icons.remove_red_eye_sharp,
              ),
              title: TextButton(
                  onPressed: () {
                    Navigator.pop(context);

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              detail_screen(postid: snap['postId']),
                        ));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        "Ayrıntılı Gör",
                        style: TextStyle(color: Colors.black),
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(
                        width: 50,
                      )
                    ],
                  )),
            ),
            yetki == 2
                ? ListTile(
                    iconColor: Colors.orange,
                    leading: const Icon(
                      Icons.timelapse_sharp,
                    ),
                    title: TextButton(
                        onPressed: () {
                          Navigator.pop(context);

                          durum = "İşleme Alındı";
                          iptalpost(snap['postId'], durum, 1);
                          notifpush().dataget(snap['postId'], 1, durum);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              "İşleme al",
                              style: TextStyle(color: Colors.black),
                              textAlign: TextAlign.start,
                            ),
                            SizedBox(
                              width: 50,
                            )
                          ],
                        )),
                  )
                : Container(),
            ListTile(
              iconColor: Colors.yellow[700],
              leading: const Icon(Icons.add_comment),
              title: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              CommentsScreen(postId: snap['postId'].toString()),
                        ));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        "Ek Açıklama Gir",
                        style: TextStyle(color: Colors.black),
                      ),
                      SizedBox(
                        width: 50,
                      )
                    ],
                  )),
            ),
          ],
        );
      },
    );
  }

  Future secenekSayfa2yetki23() {
    return showModalBottomSheet(
        // işlem tamamlandı sayfası yetki 3
        context: context,
        builder: (context) {
          return Wrap(
            children: [
              const Center(
                child: Icon(
                  Icons.linear_scale_outlined,
                  color: Colors.black,
                  size: 25,
                ),
              ),
              ListTile(
                iconColor: Colors.green,
                leading: const Icon(
                  Icons.remove_red_eye_sharp,
                ),
                title: TextButton(
                    onPressed: () {
                      Navigator.pop(context);

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                detail_screen(postid: snap['postId']),
                          ));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AyrintiGor,
                          style: TextStyle(color: Colors.black),
                          textAlign: TextAlign.start,
                        ),
                        SizedBox(
                          width: 50,
                        )
                      ],
                    )),
              ),
              ListTile(
                iconColor: Colors.yellow[700],
                leading: const Icon(Icons.add_comment),
                title: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CommentsScreen(
                                postId: snap['postId'].toString()),
                          ));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          EkaciklamaGir,
                          style: TextStyle(color: Colors.black),
                        ),
                        SizedBox(
                          width: 50,
                        )
                      ],
                    )),
              ),
            ],
          );
        });
  }

  Future secenekSayfa0yetki10() {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Wrap(
            children: [
              const Center(
                child: Icon(
                  Icons.linear_scale_outlined,
                  color: Colors.black,
                  size: 25,
                ),
              ),
              ListTile(
                iconColor: Colors.green,
                leading: const Icon(
                  Icons.remove_red_eye_sharp,
                ),
                title: TextButton(
                    onPressed: () {
                      Navigator.pop(context);

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                detail_screen(postid: snap['postId']),
                          ));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AyrintiGor,
                          style: TextStyle(color: Colors.black),
                          textAlign: TextAlign.start,
                        ),
                        SizedBox(
                          width: 50,
                        )
                      ],
                    )),
              ),
              //  snap['durum'] == "Firma Onay Bekliyor"?
              ListTile(
                iconColor: Colors.yellow[700],
                leading: const Icon(Icons.add_comment),
                title: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CommentsScreen(
                                postId: snap['postId'].toString()),
                          ));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          EkaciklamaGir,
                          style: TextStyle(color: Colors.black),
                        ),
                        SizedBox(
                          width: 50,
                        )
                      ],
                    )),
              ),
              //   : Container(),
              snap['durum'] == FirmaOnaybekliyor
                  ? ListTile(
                      iconColor: Colors.orange,
                      leading: const Icon(Icons.edit_note),
                      title: TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => edit_screen(
                                    postuid: snap['postId'].toString(),
                                    uid: snap['uid'].toString(),
                                  ),
                                ));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text(
                                "Düzenle",
                                style: TextStyle(color: Colors.black),
                              ),
                              SizedBox(
                                width: 50,
                              )
                            ],
                          )),
                    )
                  : Container(),
              snap['durum'] == FirmaServisUcretOnay
                  ? yetki == 1
                      ? ListTile(
                          iconColor: Colors.orange,
                          leading: const Icon(Icons.add_comment_rounded),
                          title: TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text(
                                    "Ek Açıklama Gir",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  SizedBox(
                                    width: 50,
                                  )
                                ],
                              )),
                        )
                      : Container()
                  : Container(),
              snap['durum'] == FirmaServisUcretOnay
                  ? yetki == 1
                      ? ListTile(
                          iconColor: Colors.green,
                          leading: const Icon(Icons.task_alt),
                          title: TextButton(
                              onPressed: () {
                                durum = Servisucretonaylandi;
                                iptalpost(snap['postId'].toString(), durum, 0);
                                Navigator.pop(context);
                                notifpush().getselective(snap['postId'], durum);
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    Servisonaylandi,
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  SizedBox(
                                    width: 50,
                                  )
                                ],
                              )),
                        )
                      : Container()
                  : Container(),
              snap['durum'] == FirmaOnaybekliyor
                  ? yetki == 1
                      ? ListTile(
                          iconColor: Colors.green,
                          leading: const Icon(Icons.task_alt),
                          title: TextButton(
                              onPressed: () {
                                durum = SelectivedenOnaybekliyor;
                                onayla(snap['postId'].toString(), durum, 0, 1);
                                notifpush().getselective(snap['postId'], durum);
                                notifpush().dataget(snap['postId'], 0, durum);
                                Navigator.pop(context);
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    Onayla,
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  SizedBox(
                                    width: 50,
                                  )
                                ],
                              )),
                        )
                      : Container()
                  : snap['durum'] == Islemtamamlandi
                      ? Container()
                      : snap["durum"] == Servisbedeliodendi ||
                              snap["durum"] == Servisucretonaylandi
                          ? ListTile(
                              iconColor: Colors.red,
                              leading: const Icon(Icons.delete),
                              title: TextButton(
                                  onPressed: () {
                                    durum = Talebiniptalisteniyor;
                                    iptalpost(
                                        snap['postId'].toString(), durum, 0);
                                    notifpush()
                                        .getselective(snap['postId'], durum);

                                    Navigator.pop(context);
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        Iptaltalebindebulun,
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      SizedBox(
                                        width: 50,
                                      )
                                    ],
                                  )),
                            )
                          : Container(),

              // ListTile(
              //   iconColor: Colors.red,
              //   leading: const Icon(Icons.delete),
              //  title: TextButton(
              //       onPressed: () {},
              //       child: Row(
              //         mainAxisAlignment: MainAxisAlignment.center,
              //         children: const [
              //            Text(
              //             "İptal Et",
              //             style: TextStyle(color: Colors.black),
              //           ),
              //           SizedBox(
              //              width: 50,
              //           )
              //         ],
              //       )),
              // ),
              snap['durum'] == FirmaOnaybekliyor
                  ? ListTile(
                      iconColor: Colors.red,
                      leading: const Icon(Icons.delete),
                      title: TextButton(
                          onPressed: () {
                            durum = Talepiptaledildi;
                            iptalpost(snap['postId'].toString(), durum, 3);

                            notifpush().dataget(snap['postId'], 0, durum);
                            Navigator.pop(context);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                Basvuruiptal,
                                style: TextStyle(color: Colors.black),
                              ),
                              SizedBox(
                                width: 50,
                              )
                            ],
                          )),
                    )
                  : Container(),
              snap['durum'] == SelectivedenOnaybekliyor ||
                      snap['durum'] == Firmaservisonayi
                  ? yetki == 1
                      ? ListTile(
                          iconColor: Colors.red,
                          leading: const Icon(Icons.delete),
                          title: TextButton(
                              onPressed: () {
                                durum = Talepiptaledildi;
                                iptalpost(snap['postId'].toString(), durum, 3);

                                notifpush().dataget(snap['postId'], 0, durum);
                                Navigator.pop(context);
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    Basvuruiptal,
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  SizedBox(
                                    width: 50,
                                  )
                                ],
                              )),
                        )
                      : Container()
                  : Container(),
            ],
          );
        });
  }

  Future secenekSayfa2yetki10() {
    return showModalBottomSheet(
        // işlem tamamlandı sayfası yetki 3
        context: context,
        builder: (context) {
          return Wrap(
            children: [
              const Center(
                child: Icon(
                  Icons.linear_scale_outlined,
                  color: Colors.black,
                  size: 25,
                ),
              ),
              ListTile(
                iconColor: Colors.green,
                leading: const Icon(
                  Icons.remove_red_eye_sharp,
                ),
                title: TextButton(
                    onPressed: () {
                      Navigator.pop(context);

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                detail_screen(postid: snap['postId']),
                          ));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AyrintiGor,
                          style: TextStyle(color: Colors.black),
                          textAlign: TextAlign.start,
                        ),
                        SizedBox(
                          width: 50,
                        )
                      ],
                    )),
              ),
              snap['durum'] != Islemtamamlandi
                  ? ListTile(
                      iconColor: Colors.yellow[700],
                      leading: const Icon(Icons.add_comment),
                      title: TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CommentsScreen(
                                      postId: snap['postId'].toString()),
                                ));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                EkaciklamaGir,
                                style: TextStyle(color: Colors.black),
                              ),
                              SizedBox(
                                width: 50,
                              )
                            ],
                          )),
                    )
                  : Container(),
            ],
          );
        });
  }

  print(yetki);
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: InkWell(
      onTap: () {
        page == 0
            ? yetki == 2 || yetki == 3
                ? snap['sayfa'] == 0
                    // sayfa0 ve yetki 2-3 ise
                    ? secenekSayfa0yetki23()
                    // sayfa 1 ve yetki 2-3 ise
                    : snap['sayfa'] == 1
                        ? secenekSayfa1yetki23()
                        // sayfa 2 ve yetki 2-3 ise
                        : snap['sayfa'] == 2
                            ? secenekSayfa2yetki23()
                            : Container()
                : yetki == 0 || yetki == 1
                    ? snap['sayfa'] == 0
                        ? secenekSayfa0yetki10()
                        : snap['sayfa'] == 1
                            ? secenekSayfa0yetki10()
                            : snap['sayfa'] == 2
                                ? secenekSayfa2yetki10()
                                : Container()
                    : Container()
            : Container();
      },
      child: Container(
        // boundary needed for web
        decoration: BoxDecoration(
          borderRadius: page == 1
              ? BorderRadius.all(Radius.circular(2))
              : BorderRadius.all(Radius.circular(20)),
          border: Border.all(
            color: Colors.white,
          ),
          color: Colors.grey[200],
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 10,
        ),
        child: Column(
          children: [
            // HEADER SECTION OF THE POST
            Container(
              child: Column(
                children: [
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 0,
                          ),
                          child: Column(
                            // mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              page == 1
                                  ? Center(
                                      child: Container(
                                        height: 150,
                                        child: resim.length != 0
                                            ? ListView.builder(
                                                shrinkWrap: true,
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemCount: resim.length,
                                                itemBuilder:
                                                    (BuildContext context,
                                                            int index) =>
                                                        headimage(index))
                                            : Center(
                                                child: Text(Fotografeklenmemis),
                                              ),
                                      ),
                                    )
                                  : Container(
                                      height: 1,
                                      width: 1,
                                    ),
                              yetki == 2 || yetki == 3
                                  ? Container(
                                      // width: 200,
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 0),
                                        child: Text(
                                          "Firma : ${snap['firma']}",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                      ),
                                    )
                                  : Container(),
                              Row(
                                children: [
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          // width: 200,
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 0),
                                            child: Text(
                                              "Kategori : ${snap['kategori']}",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              page == 1
                                  ? snap['kategori'] == "Diğer"
                                      ? Container(
                                          // width: 200,
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 0),
                                            child: Text(
                                              "Başlık : ${snap['baslik']}",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16),
                                            ),
                                          ),
                                        )
                                      : Container()
                                  : Container(),
                              SizedBox(
                                height: 5,
                              ),
                              RichText(
                                text: TextSpan(
                                  style: const TextStyle(color: Colors.black),
                                  children: [
                                    TextSpan(
                                        text: 'Açıklama : ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    TextSpan(
                                      text: ' ${snap['description']}',
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              page == 1
                                  ? snap['para'] == null
                                      ? Container()
                                      : Align(
                                          alignment: Alignment.centerLeft,
                                          child: RichText(
                                            text: TextSpan(
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
                                              children: [
                                                TextSpan(
                                                  text:
                                                      'Ücret : ${snap['para']}',
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                  : yetki == 1
                                      ? snap['para'] == null
                                          ? Container()
                                          : Align(
                                              alignment: Alignment.centerLeft,
                                              child: RichText(
                                                text: TextSpan(
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  children: [
                                                    TextSpan(
                                                      text:
                                                          'Ücret : ${snap['para']}',
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                      : Container(),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: RichText(
                                  text: TextSpan(
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                    children: [
                                      TextSpan(
                                        text: 'Durum : ${snap['durum']}',
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Başvuru zamanı : ${DateFormat.yMMMMd().format(snap['datePublished'].toDate())}",
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              page == 1
                                  ? snap["Scalisan"] == null
                                      ? Container()
                                      // Align(
                                      //        alignment: Alignment.centerLeft,
                                      //   child: Text(
                                      //     "Atanan kişi : ",
                                      //     style: const TextStyle(
                                      //         color: Colors.black,
                                      //         fontWeight: FontWeight.bold),
                                      //   ),
                                      // )
                                      : Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "Atanan kişi : ${snap["Scalisan"]}",
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        )
                                  : Container(),
                              page == 1
                                  ? snap['atamaTarih'] == null
                                      ? Container()
                                      // const Align(
                                      //        alignment: Alignment.centerLeft,
                                      //   child: Text(
                                      //     "Atama zamanı : ",
                                      //     style: TextStyle(
                                      //         color: Colors.black,
                                      //          fontWeight: FontWeight.bold),
                                      //    ),
                                      //  )
                                      : Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "Atama zamanı : ${DateFormat.yMMMMd().format(snap['atamaTarih'].toDate())}",
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        )
                                  : Container(),
                              page == 1
                                  ? snap['finishtime'] == null
                                      ? Container()

                                      //const Align(
                                      //  alignment: Alignment.centerRight,
                                      //  child: Text(
                                      // //    "Bitiş zamanı : ",
                                      //     style: TextStyle(
                                      //         color: Colors.black,
                                      //         fontWeight: FontWeight.bold),
                                      //   ),
                                      // )
                                      : Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "Bitiş zamanı : ${DateFormat.yMMMMd().format(snap['finishtime'].toDate())}",
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        )
                                  : Container(),
                              //  snap["durum"] == "Servis Bedeli Onaylandı"
                              //      ? Align(
                              //          alignment: Alignment.centerLeft,
                              //          child: ElevatedButton(
                              //            onPressed: () {
                              //              Navigator.push(
                              //                  context,
                              //                  MaterialPageRoute(
                              //                    builder: (context) =>
                              //                        add_dekont_screen(
                              //                           uid: snap["postId"]),
                              //                 ));
                              //          },
                              //           child: Text("Dekont Yükle"),
                              //           style: ButtonStyle(
                              //                backgroundColor:
                              //                    MaterialStateProperty.all<
                              //                         Color>(
                              //                   Color.fromARGB(
                              //                       255, 171, 197, 225),
                              //                 ),
                              //                 shape: MaterialStateProperty.all<
                              //                     RoundedRectangleBorder>(
                              //                   const RoundedRectangleBorder(
                              //                     borderRadius: BorderRadius.all(
                              //                        Radius.circular(30)),
                              //                  ),
                              //                )),
                              //          ),
                              //        )
                              //      : Container()
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
