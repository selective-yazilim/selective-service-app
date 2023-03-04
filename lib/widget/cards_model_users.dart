import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:selective/screen/home/add_descrip/comments_screen.dart';
import 'package:selective/screen/home/detail/detail.dart';
import 'package:selective/screen/home/edit/edit.dart';
import 'package:selective/screen/users/users_edit.dart';
import 'package:selective/services/firestore_methods.dart';
import 'package:selective/utils/text.dart';
import 'package:selective/utils/utils.dart';

Widget card_model_users(BuildContext context, snap, int yetki, int sayfa) {
  // iptalfirma(String firmaId , String durum) async {
  //   try {
  //    await FireStoreMethods().updatedurum(postId, durum);
  //   } catch (err) {
  //     showSnackBar(
  //      context,
  //      err.toString(),
  //     );
  //   }
  // }
  String userdurum;
  pasifuser(String uid, String udurum) async {
    try {
      await FireStoreMethods().updateuserdurum(uid, udurum);
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }

  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: InkWell(
      onTap: () {
        showModalBottomSheet(
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
                    iconColor: Colors.orange,
                    leading: const Icon(Icons.edit_note),
                    title: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => users_edit_screen(
                                  userid: snap['uid'].toString(),
                                ),
                              ));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              Duzenle,
                              style: TextStyle(color: Colors.black),
                            ),
                            SizedBox(
                              width: 50,
                            )
                          ],
                        )),
                  ),
                  snap['durum'] == "Aktif"
                      ? ListTile(
                          iconColor: Colors.red,
                          leading: const Icon(
                            Icons.pause_circle_outline_sharp,
                          ),
                          title: TextButton(
                              onPressed: () {
                                userdurum = "Pasif";

                                pasifuser(snap['uid'].toString(), userdurum);
                                Navigator.pop(context);
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text(
                                    "Pasife Al",
                                    style: TextStyle(color: Colors.black),
                                    textAlign: TextAlign.start,
                                  ),
                                  SizedBox(
                                    width: 50,
                                  )
                                ],
                              )),
                        )
                      : ListTile(
                          iconColor: Colors.green,
                          leading: const Icon(
                            Icons.play_circle_outline_outlined,
                          ),
                          title: TextButton(
                              onPressed: () {
                                userdurum = "Aktif";
                                pasifuser(snap['uid'].toString(), userdurum);
                                Navigator.pop(context);
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text(
                                    "Aktifleştir",
                                    style: TextStyle(color: Colors.black),
                                    textAlign: TextAlign.start,
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
      },
      child: Container(
        // boundary needed for web
        decoration: BoxDecoration(
          borderRadius: sayfa == 1
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
                            left: 8,
                          ),
                          child: Column(
                            // mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Align(
                                    alignment: Alignment.center,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          // width: 200,

                                          child: Text(
                                            "Firma : " +
                                                snap['firma'].toString(),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              RichText(
                                text: TextSpan(
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                  children: [
                                    TextSpan(
                                        text: 'isim : ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    TextSpan(
                                      text: ' ${snap['username']}',
                                    ),
                                  ],
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: RichText(
                                  text: TextSpan(
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                    children: [
                                      TextSpan(
                                        text: 'Mail : ${snap['email']}',
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: RichText(
                                  text: TextSpan(
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                    children: [
                                      TextSpan(
                                        text:
                                            'Şifre : ${snap['yetki'] == 2 || snap['yetki'] == 3 ? "****" : snap['password']}',
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: RichText(
                                  text: TextSpan(
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                    children: [
                                      TextSpan(
                                        text: 'Görev : ${snap['gorev']}',
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: RichText(
                                  text: TextSpan(
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                    children: [
                                      TextSpan(
                                        text: 'Telefon : ${snap['telefon']}',
                                      ),
                                    ],
                                  ),
                                ),
                              ),
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
