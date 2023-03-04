import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:selective/screen/home/detail/detail.dart';
import 'package:selective/utils/color.dart';
import 'package:selective/utils/text.dart';
import 'package:selective/utils/utils.dart';
import 'package:selective/widget/post_card.dart';

class iptal_screen_firma extends StatefulWidget {
  const iptal_screen_firma({super.key});

  @override
  State<iptal_screen_firma> createState() => _iptal_screen_firmaState();
}

class _iptal_screen_firmaState extends State<iptal_screen_firma> {
  int loading = 0;
  var yetki = 0;
  String durum = onaybekliyor;
  String parabirimi = "TL";
  String oncelik = "5";
  String? atanan;
  TextEditingController baslangic = TextEditingController();
  TextEditingController bitis = TextEditingController();
  DateTime? baspickedDate;
  DateTime? bitpickedDate;

  gel() async {
    loading = 0;
    var userSnap = await FirebaseFirestore.instance
        .collection('users')
        .doc(
          FirebaseAuth.instance.currentUser!.uid,
        )
        .get();

    yetki = userSnap.data()!['yetki'];
    firma = userSnap.data()!["firma"];
    loading = 1;
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    gel();
    baslangic;
    bitis;
  }

  int filterhidden = 0;
  String firma = "";
  String filterdurum = "";
  String filterkategori = "";
  String filterfirma = "";
  late Stream filter;
  sorgu() {
    if (yetki == 1 || yetki == 0) {
      //yetki 1-0
      if ((filterdurum == "" || filterdurum == "Hepsi") &&
          filterkategori == "" &&
          baslangic.text == "" &&
          bitis.text == "") {
        print("kategori");
        yetki == 0
            ? filter = FirebaseFirestore.instance
                .collection('posts')
                .where("sayfa", isEqualTo: 3)
                .where("uid", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                .snapshots()
            : yetki == 1
                ? filter = FirebaseFirestore.instance
                    .collection('posts')
                    .where("sayfa", isEqualTo: 3)
                    .where("firma", isEqualTo: firma)
                    .snapshots()
                : filter = FirebaseFirestore.instance
                    .collection('posts')
                    .where("sayfa", isEqualTo: 3)
                    .snapshots();
      } else if (filterdurum != "" &&
          filterkategori == "" &&
          filterdurum != "Hepsi" &&
          baslangic.text == "" &&
          bitis.text == "") {
        yetki == 0
            ? filter = FirebaseFirestore.instance
                .collection('posts')
                .where("sayfa", isEqualTo: 3)
                .where("uid", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                .where("durum", isEqualTo: filterdurum.toString())
                .snapshots()
            : yetki == 1
                ? filter = FirebaseFirestore.instance
                    .collection('posts')
                    .where("sayfa", isEqualTo: 3)
                    .where("firma", isEqualTo: firma)
                    .where("durum", isEqualTo: filterdurum.toString())
                    .snapshots()
                : filter = FirebaseFirestore.instance
                    .collection('posts')
                    .where("sayfa", isEqualTo: 3)
                    .snapshots();
      } else if ((filterdurum == "" || filterdurum == "Hepsi") &&
          filterkategori != "" &&
          baslangic.text == "" &&
          bitis.text == "") {
        yetki == 0
            ? filter = FirebaseFirestore.instance
                .collection('posts')
                .where("sayfa", isEqualTo: 3)
                .where("uid", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                .where("kategori", isEqualTo: filterkategori.toString())
                .snapshots()
            : yetki == 1
                ? filter = FirebaseFirestore.instance
                    .collection('posts')
                    .where("sayfa", isEqualTo: 3)
                    .where("firma", isEqualTo: firma)
                    .where("kategori", isEqualTo: filterkategori.toString())
                    .snapshots()
                : filter = FirebaseFirestore.instance
                    .collection('posts')
                    .where("sayfa", isEqualTo: 3)
                    .snapshots();
      } else if (filterdurum != "" &&
          filterkategori != "" &&
          filterdurum != "Hepsi" &&
          baslangic.text == "" &&
          bitis.text == "") {
        yetki == 0
            ? filter = FirebaseFirestore.instance
                .collection('posts')
                .where("sayfa", isEqualTo: 3)
                .where("uid", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                .where("kategori", isEqualTo: filterkategori.toString())
                .where("durum", isEqualTo: filterdurum.toString())
                .snapshots()
            : yetki == 1
                ? filter = FirebaseFirestore.instance
                    .collection('posts')
                    .where("sayfa", isEqualTo: 3)
                    .where("firma", isEqualTo: firma)
                    .where("kategori", isEqualTo: filterkategori.toString())
                    .where("durum", isEqualTo: filterdurum.toString())
                    .snapshots()
                : filter = FirebaseFirestore.instance
                    .collection('posts')
                    .where("sayfa", isEqualTo: 3)
                    .snapshots();
      } else if ((filterdurum == "" || filterdurum == "Hepsi") &&
          filterkategori == "" &&
          baslangic.text != "" &&
          bitis.text != "") {
        yetki == 0
            ? filter = FirebaseFirestore.instance
                .collection('posts')
                .where("sayfa", isEqualTo: 3)
                .where("uid", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                .where("datePublished", isGreaterThanOrEqualTo: baspickedDate)
                .where("datePublished", isLessThanOrEqualTo: bitpickedDate)
                .snapshots()
            : yetki == 1
                ? filter = FirebaseFirestore.instance
                    .collection('posts')
                    .where("sayfa", isEqualTo: 3)
                    .where("firma", isEqualTo: firma)
                    .where("datePublished",
                        isGreaterThanOrEqualTo: baspickedDate)
                    .where("datePublished", isLessThanOrEqualTo: bitpickedDate)
                    .snapshots()
                : filter = FirebaseFirestore.instance
                    .collection('posts')
                    .where("sayfa", isEqualTo: 3)
                    .snapshots();
      } else if (filterdurum != "" &&
          filterkategori == "" &&
          filterdurum != "Hepsi" &&
          baslangic.text != "" &&
          bitis.text != "") {
        yetki == 0
            ? filter = FirebaseFirestore.instance
                .collection('posts')
                .where("sayfa", isEqualTo: 3)
                .where("uid", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                .where("durum", isEqualTo: filterdurum.toString())
                .where("datePublished", isGreaterThanOrEqualTo: baspickedDate)
                .where("datePublished", isLessThanOrEqualTo: bitpickedDate)
                .snapshots()
            : yetki == 1
                ? filter = FirebaseFirestore.instance
                    .collection('posts')
                    .where("sayfa", isEqualTo: 3)
                    .where("firma", isEqualTo: firma)
                    .where("durum", isEqualTo: filterdurum.toString())
                    .where("datePublished",
                        isGreaterThanOrEqualTo: baspickedDate)
                    .where("datePublished", isLessThanOrEqualTo: bitpickedDate)
                    .snapshots()
                : filter = FirebaseFirestore.instance
                    .collection('posts')
                    .where("sayfa", isEqualTo: 3)
                    .snapshots();
      } else if ((filterdurum == "" || filterdurum == "Hepsi") &&
          filterkategori != "" &&
          baslangic.text != "" &&
          bitis.text != "") {
        yetki == 0
            ? filter = FirebaseFirestore.instance
                .collection('posts')
                .where("sayfa", isEqualTo: 3)
                .where("uid", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                .where("kategori", isEqualTo: filterkategori.toString())
                .where("datePublished", isGreaterThanOrEqualTo: baspickedDate)
                .where("datePublished", isLessThanOrEqualTo: bitpickedDate)
                .snapshots()
            : yetki == 1
                ? filter = FirebaseFirestore.instance
                    .collection('posts')
                    .where("sayfa", isEqualTo: 3)
                    .where("firma", isEqualTo: firma)
                    .where("kategori", isEqualTo: filterkategori.toString())
                    .where("datePublished",
                        isGreaterThanOrEqualTo: baspickedDate)
                    .where("datePublished", isLessThanOrEqualTo: bitpickedDate)
                    .snapshots()
                : filter = FirebaseFirestore.instance
                    .collection('posts')
                    .where("sayfa", isEqualTo: 3)
                    .snapshots();
      } else if ((filterdurum != "" && filterdurum != "Hepsi") &&
          filterkategori != "" &&
          (baslangic.text != "" && bitis.text != "")) {
        yetki == 0
            ? filter = FirebaseFirestore.instance
                .collection('posts')
                .where("sayfa", isEqualTo: 3)
                .where("uid", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                .where("kategori", isEqualTo: filterkategori.toString())
                .where("durum", isEqualTo: filterdurum.toString())
                .where("datePublished", isGreaterThanOrEqualTo: baspickedDate)
                .where("datePublished", isLessThanOrEqualTo: bitpickedDate)
                .snapshots()
            : yetki == 1
                ? filter = FirebaseFirestore.instance
                    .collection('posts')
                    .where("sayfa", isEqualTo: 3)
                    .where("firma", isEqualTo: firma)
                    .where("kategori", isEqualTo: filterkategori.toString())
                    .where("durum", isEqualTo: filterdurum.toString())
                    .where("datePublished",
                        isGreaterThanOrEqualTo: baspickedDate)
                    .where("datePublished", isLessThanOrEqualTo: bitpickedDate)
                    .snapshots()
                : filter = FirebaseFirestore.instance
                    .collection('posts')
                    .where("sayfa", isEqualTo: 3)
                    .snapshots();
      } else if ((filterdurum == "" || filterdurum == "Hepsi") &&
          filterkategori == "" &&
          (baslangic.text != "" && bitis.text != "")) {
        yetki == 0
            ? filter = FirebaseFirestore.instance
                .collection('posts')
                .where("sayfa", isEqualTo: 3)
                .where("uid", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                .where("datePublished", isGreaterThanOrEqualTo: baspickedDate)
                .where("datePublished", isLessThanOrEqualTo: bitpickedDate)
                .snapshots()
            : yetki == 1
                ? filter = FirebaseFirestore.instance
                    .collection('posts')
                    .where("sayfa", isEqualTo: 3)
                    .where("firma", isEqualTo: firma)
                    .where("datePublished",
                        isGreaterThanOrEqualTo: baspickedDate)
                    .where("datePublished", isLessThanOrEqualTo: bitpickedDate)
                    .snapshots()
                : filter = FirebaseFirestore.instance
                    .collection('posts')
                    .where("sayfa", isEqualTo: 3)
                    .snapshots();
      }
    } else
    //yetki 2-3
    {
      if ((filterdurum == "" || filterdurum == "Hepsi") &&
          filterkategori == "" &&
          filterfirma == "" &&
          baslangic.text == "" &&
          bitis.text == "") {
        yetki == 2
            ? filter = FirebaseFirestore.instance
                .collection('posts')
                .where("sayfa", isEqualTo: 3)
                .where("Scalisanid",
                    isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                .snapshots()
            : yetki == 3
                ? filter = FirebaseFirestore.instance
                    .collection('posts')
                    .where("sayfa", isEqualTo: 3)
                    .snapshots()
                : filter = FirebaseFirestore.instance
                    .collection('posts')
                    .where("sayfa", isEqualTo: 3)
                    .snapshots();
        print(filter);
      } else if (filterdurum != "" &&
          filterkategori == "" &&
          filterdurum != "Hepsi" &&
          filterfirma == "" &&
          baslangic.text == "" &&
          bitis.text == "") {
        print(filterdurum);
        yetki == 2
            ? filter = FirebaseFirestore.instance
                .collection('posts')
                .where("sayfa", isEqualTo: 3)
                .where("Scalisanid",
                    isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                .where("durum", isEqualTo: filterdurum.toString())
                .snapshots()
            : yetki == 3
                ? filter = FirebaseFirestore.instance
                    .collection('posts')
                    .where("sayfa", isEqualTo: 3)
                    .where("durum", isEqualTo: filterdurum.toString())
                    .snapshots()
                : filter = FirebaseFirestore.instance
                    .collection('posts')
                    .where("sayfa", isEqualTo: 3)
                    .snapshots();
      } else if ((filterdurum == "" || filterdurum == "Hepsi") &&
          filterkategori != "" &&
          filterfirma == "" &&
          baslangic.text == "" &&
          bitis.text == "") {
        yetki == 2
            ? filter = FirebaseFirestore.instance
                .collection('posts')
                .where("sayfa", isEqualTo: 3)
                .where("Scalisanid",
                    isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                .where("kategori", isEqualTo: filterkategori.toString())
                .snapshots()
            : yetki == 3
                ? filter = FirebaseFirestore.instance
                    .collection('posts')
                    .where("sayfa", isEqualTo: 3)
                    .where("kategori", isEqualTo: filterkategori.toString())
                    .snapshots()
                : filter = FirebaseFirestore.instance
                    .collection('posts')
                    .where("sayfa", isEqualTo: 3)
                    .snapshots();
      } else if (filterdurum != "" &&
          filterkategori != "" &&
          filterdurum != "Hepsi" &&
          filterfirma == "" &&
          baslangic.text == "" &&
          bitis.text == "") {
        yetki == 2
            ? filter = FirebaseFirestore.instance
                .collection('posts')
                .where("sayfa", isEqualTo: 3)
                .where("Scalisanid",
                    isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                .where("kategori", isEqualTo: filterkategori.toString())
                .where("durum", isEqualTo: filterdurum.toString())
                .snapshots()
            : yetki == 3
                ? filter = FirebaseFirestore.instance
                    .collection('posts')
                    .where("sayfa", isEqualTo: 3)
                    .where("kategori", isEqualTo: filterkategori.toString())
                    .where("durum", isEqualTo: filterdurum.toString())
                    .snapshots()
                : filter = FirebaseFirestore.instance
                    .collection('posts')
                    .where("sayfa", isEqualTo: 3)
                    .snapshots();
      } else if ((filterdurum == "" || filterdurum == "Hepsi") &&
          filterkategori == "" &&
          filterfirma != "" &&
          baslangic.text == "" &&
          bitis.text == "") {
        yetki == 2
            ? filter = FirebaseFirestore.instance
                .collection('posts')
                .where("sayfa", isEqualTo: 3)
                .where("Scalisanid",
                    isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                .where("firma", isEqualTo: filterfirma.toString())
                .snapshots()
            : yetki == 3
                ? filter = FirebaseFirestore.instance
                    .collection('posts')
                    .where("sayfa", isEqualTo: 3)
                    .where("firma", isEqualTo: filterfirma.toString())
                    .snapshots()
                : filter = FirebaseFirestore.instance
                    .collection('posts')
                    .where("sayfa", isEqualTo: 3)
                    .snapshots();
      } else if (filterdurum != "" &&
          filterdurum != "Hepsi" &&
          filterkategori != "" &&
          filterfirma != "" &&
          baslangic.text == "" &&
          bitis.text == "") {
        yetki == 2
            ? filter = FirebaseFirestore.instance
                .collection('posts')
                .where("sayfa", isEqualTo: 3)
                .where("Scalisanid",
                    isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                .where("firma", isEqualTo: filterfirma.toString())
                .where("kategori", isEqualTo: filterkategori.toString())
                .where("durum", isEqualTo: filterdurum.toString())
                .snapshots()
            : yetki == 3
                ? filter = FirebaseFirestore.instance
                    .collection('posts')
                    .where("sayfa", isEqualTo: 3)
                    .where("firma", isEqualTo: filterfirma.toString())
                    .where("kategori", isEqualTo: filterkategori.toString())
                    .where("durum", isEqualTo: filterdurum.toString())
                    .snapshots()
                : filter = FirebaseFirestore.instance
                    .collection('posts')
                    .where("sayfa", isEqualTo: 3)
                    .snapshots();
      } else if ((filterdurum == "" || filterdurum == "Hepsi") &&
          filterkategori != "" &&
          filterfirma != "" &&
          baslangic.text == "" &&
          bitis.text == "") {
        yetki == 2
            ? filter = FirebaseFirestore.instance
                .collection('posts')
                .where("sayfa", isEqualTo: 3)
                .where("Scalisanid",
                    isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                .where("firma", isEqualTo: filterfirma.toString())
                .where("kategori", isEqualTo: filterkategori.toString())
                .snapshots()
            : yetki == 3
                ? filter = FirebaseFirestore.instance
                    .collection('posts')
                    .where("sayfa", isEqualTo: 3)
                    .where("firma", isEqualTo: filterfirma.toString())
                    .where("kategori", isEqualTo: filterkategori.toString())
                    .snapshots()
                : filter = FirebaseFirestore.instance
                    .collection('posts')
                    .where("sayfa", isEqualTo: 3)
                    .snapshots();
      } else if ((filterdurum != "" && filterdurum != "Hepsi") &&
          filterkategori == "" &&
          filterfirma == "" &&
          baslangic.text != "" &&
          bitis.text != "") {
        yetki == 2
            ? filter = FirebaseFirestore.instance
                .collection('posts')
                .where("sayfa", isEqualTo: 3)
                .where("Scalisanid",
                    isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                .where("durum", isEqualTo: filterdurum.toString())
                .where("datePublished", isGreaterThanOrEqualTo: baspickedDate)
                .where("datePublished", isLessThanOrEqualTo: bitpickedDate)
                .snapshots()
            : yetki == 3
                ? filter = FirebaseFirestore.instance
                    .collection('posts')
                    .where("sayfa", isEqualTo: 3)
                    .where("durum", isEqualTo: filterdurum.toString())
                    .where("datePublished",
                        isGreaterThanOrEqualTo: baspickedDate)
                    .where("datePublished", isLessThanOrEqualTo: bitpickedDate)
                    .snapshots()
                : filter = FirebaseFirestore.instance
                    .collection('posts')
                    .where("sayfa", isEqualTo: 3)
                    .snapshots();
      } else if ((filterdurum == "" || filterdurum == "Hepsi") &&
          filterkategori != "" &&
          filterfirma == "" &&
          baslangic.text != "" &&
          bitis.text != "") {
        yetki == 2
            ? filter = FirebaseFirestore.instance
                .collection('posts')
                .where("sayfa", isEqualTo: 3)
                .where("Scalisanid",
                    isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                .where("datePublished", isGreaterThanOrEqualTo: baspickedDate)
                .where("datePublished", isLessThanOrEqualTo: bitpickedDate)
                .where("kategori", isEqualTo: filterkategori.toString())
                .snapshots()
            : yetki == 3
                ? filter = FirebaseFirestore.instance
                    .collection('posts')
                    .where("sayfa", isEqualTo: 3)
                    .where("datePublished",
                        isGreaterThanOrEqualTo: baspickedDate)
                    .where("datePublished", isLessThanOrEqualTo: bitpickedDate)
                    .where("kategori", isEqualTo: filterkategori.toString())
                    .snapshots()
                : filter = FirebaseFirestore.instance
                    .collection('posts')
                    .where("sayfa", isEqualTo: 3)
                    .snapshots();
      } else if ((filterdurum == "" || filterdurum == "Hepsi") &&
          filterkategori == "" &&
          filterfirma != "" &&
          baslangic.text != "" &&
          bitis.text != "") {
        yetki == 2
            ? filter = FirebaseFirestore.instance
                .collection('posts')
                .where("sayfa", isEqualTo: 3)
                .where("Scalisanid",
                    isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                .where("firma", isEqualTo: filterfirma.toString())
                .where("datePublished", isGreaterThanOrEqualTo: baspickedDate)
                .where("datePublished", isLessThanOrEqualTo: bitpickedDate)
                .snapshots()
            : yetki == 3
                ? filter = FirebaseFirestore.instance
                    .collection('posts')
                    .where("sayfa", isEqualTo: 3)
                    .where("firma", isEqualTo: filterfirma.toString())
                    .where("datePublished",
                        isGreaterThanOrEqualTo: baspickedDate)
                    .where("datePublished", isLessThanOrEqualTo: bitpickedDate)
                    .snapshots()
                : filter = FirebaseFirestore.instance
                    .collection('posts')
                    .where("sayfa", isEqualTo: 3)
                    .snapshots();
      } else if ((filterdurum != "" && filterdurum != "Hepsi") &&
          filterkategori != "" &&
          filterfirma == "" &&
          baslangic.text != "" &&
          bitis.text != "") {
        yetki == 2
            ? filter = FirebaseFirestore.instance
                .collection('posts')
                .where("sayfa", isEqualTo: 3)
                .where("Scalisanid",
                    isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                .where("durum", isEqualTo: filterdurum.toString())
                .where("datePublished", isGreaterThanOrEqualTo: baspickedDate)
                .where("datePublished", isLessThanOrEqualTo: bitpickedDate)
                .where("kategori", isEqualTo: filterkategori.toString())
                .snapshots()
            : yetki == 3
                ? filter = FirebaseFirestore.instance
                    .collection('posts')
                    .where("sayfa", isEqualTo: 3)
                    .where("durum", isEqualTo: filterdurum.toString())
                    .where("datePublished",
                        isGreaterThanOrEqualTo: baspickedDate)
                    .where("datePublished", isLessThanOrEqualTo: bitpickedDate)
                    .where("kategori", isEqualTo: filterkategori.toString())
                    .snapshots()
                : filter = FirebaseFirestore.instance
                    .collection('posts')
                    .where("sayfa", isEqualTo: 3)
                    .snapshots();
      } else if ((filterdurum != "" || filterdurum != "Hepsi") &&
          filterkategori == "" &&
          filterfirma != "" &&
          baslangic.text != "" &&
          bitis.text != "") {
        yetki == 2
            ? filter = FirebaseFirestore.instance
                .collection('posts')
                .where("sayfa", isEqualTo: 3)
                .where("Scalisanid",
                    isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                .where("firma", isEqualTo: filterfirma.toString())
                .where("datePublished", isGreaterThanOrEqualTo: baspickedDate)
                .where("datePublished", isLessThanOrEqualTo: bitpickedDate)
                .snapshots()
            : yetki == 3
                ? filter = FirebaseFirestore.instance
                    .collection('posts')
                    .where("sayfa", isEqualTo: 3)
                    .where("firma", isEqualTo: filterfirma.toString())
                    .where("datePublished",
                        isGreaterThanOrEqualTo: baspickedDate)
                    .where("datePublished", isLessThanOrEqualTo: bitpickedDate)
                    .snapshots()
                : filter = FirebaseFirestore.instance
                    .collection('posts')
                    .where("sayfa", isEqualTo: 3)
                    .snapshots();
      } else if ((filterdurum == "" || filterdurum == "Hepsi") &&
          filterkategori != "" &&
          filterfirma != "" &&
          baslangic.text != "" &&
          bitis.text != "") {
        yetki == 2
            ? filter = FirebaseFirestore.instance
                .collection('posts')
                .where("sayfa", isEqualTo: 3)
                .where("Scalisanid",
                    isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                .where("firma", isEqualTo: filterfirma.toString())
                .where("kategori", isEqualTo: filterkategori.toString())
                .where("datePublished", isGreaterThanOrEqualTo: baspickedDate)
                .where("datePublished", isLessThanOrEqualTo: bitpickedDate)
                .snapshots()
            : yetki == 3
                ? filter = FirebaseFirestore.instance
                    .collection('posts')
                    .where("sayfa", isEqualTo: 3)
                    .where("firma", isEqualTo: filterfirma.toString())
                    .where("kategori", isEqualTo: filterkategori.toString())
                    .where("datePublished",
                        isGreaterThanOrEqualTo: baspickedDate)
                    .where("datePublished", isLessThanOrEqualTo: bitpickedDate)
                    .snapshots()
                : filter = FirebaseFirestore.instance
                    .collection('posts')
                    .where("sayfa", isEqualTo: 3)
                    .snapshots();
      } else if ((filterdurum != "" && filterdurum != "Hepsi") &&
          filterkategori != "" &&
          filterfirma != "" &&
          baslangic.text != "" &&
          bitis.text != "") {
        yetki == 2
            ? filter = FirebaseFirestore.instance
                .collection('posts')
                .where("sayfa", isEqualTo: 3)
                .where("Scalisanid",
                    isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                .where("firma", isEqualTo: filterfirma.toString())
                .where("kategori", isEqualTo: filterkategori.toString())
                .where("durum", isEqualTo: filterdurum.toString())
                .where("datePublished", isGreaterThanOrEqualTo: baspickedDate)
                .where("datePublished", isLessThanOrEqualTo: bitpickedDate)
                .snapshots()
            : yetki == 3
                ? filter = FirebaseFirestore.instance
                    .collection('posts')
                    .where("sayfa", isEqualTo: 3)
                    .where("firma", isEqualTo: filterfirma.toString())
                    .where("kategori", isEqualTo: filterkategori.toString())
                    .where("durum", isEqualTo: filterdurum.toString())
                    .where("datePublished",
                        isGreaterThanOrEqualTo: baspickedDate)
                    .where("datePublished", isLessThanOrEqualTo: bitpickedDate)
                    .snapshots()
                : filter = FirebaseFirestore.instance
                    .collection('posts')
                    .where("sayfa", isEqualTo: 3)
                    .snapshots();
      } else if ((filterdurum == "" || filterdurum == "Hepsi") &&
          filterkategori == "" &&
          filterfirma == "" &&
          baslangic.text != "" &&
          bitis.text != "") {
        yetki == 2
            ? filter = FirebaseFirestore.instance
                .collection('posts')
                .where("sayfa", isEqualTo: 3)
                .where("Scalisanid",
                    isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                .where("datePublished", isGreaterThanOrEqualTo: baspickedDate)
                .where("datePublished", isLessThanOrEqualTo: bitpickedDate)
                .snapshots()
            : yetki == 3
                ? filter = FirebaseFirestore.instance
                    .collection('posts')
                    .where("sayfa", isEqualTo: 3)
                    .where("datePublished",
                        isGreaterThanOrEqualTo: baspickedDate)
                    .where("datePublished", isLessThanOrEqualTo: bitpickedDate)
                    .snapshots()
                : filter = FirebaseFirestore.instance
                    .collection('posts')
                    .where("sayfa", isEqualTo: 3)
                    .snapshots();
      }
    }

    setState(() {});
    return filter;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: colors().white,
      body: loading == 0
          ? const Center(child: CircularProgressIndicator())
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
                        itemBuilder: (context, index) => Container(
                          child: PostCard(
                            sayfa: 3,
                            snap: snapshot.data!.docs[index].data(),
                          ),
                        ),
                      ));
                    }),
              ],
            ),
    );
  }

  Future secenekSayfa1yetki23(String postid) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Wrap(
            children: [
              Center(
                child: Icon(
                  Icons.linear_scale_outlined,
                  color: colors().black,
                  size: 25,
                ),
              ),
              ListTile(
                iconColor: colors().green,
                leading: const Icon(
                  Icons.remove_red_eye_sharp,
                ),
                title: TextButton(
                    onPressed: () {
                      Navigator.pop(context);

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => detail_screen(postid: postid),
                          ));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AyrintiGor,
                          style: TextStyle(color: colors().black),
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
  }

  Container filtersystem() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          filterhidden == 1
              ? filtercombo(
                  "kategori", "Kategori Filtrele", filterkategori, "kategori")
              : Container(),
          filterhidden == 1
              ? yetki == 2 || yetki == 3
                  ? filtercombo(
                      "firma", "Firma Filtrele", filterfirma, "firma_name")
                  : Container()
              : Container(),
          filterhidden == 1
              ? Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: (MediaQuery.of(context).size.width / 2) - 20,
                        child: TextField(
                          controller:
                              baslangic, //editing controller of this TextField
                          decoration: InputDecoration(
                              icon: Icon(
                                  Icons.calendar_today), //icon of text field
                              labelText: BasTarih //label text of field
                              ),
                          readOnly:
                              true, //set it true, so that user will not able to edit text
                          onTap: () async {
                            baspickedDate = await DatePicker.showDatePicker(
                                context,
                                showTitleActions: true,
                                minTime: DateTime(2000, 1, 1),
                                maxTime: DateTime(2109, 12, 31),
                                onChanged: (date) {
                              print('change $date');
                            }, onConfirm: (date) {
                              print('confirm $date');
                            },
                                currentTime: DateTime.now(),
                                locale: LocaleType.tr);

                            if (baspickedDate != null) {
                              print(
                                  baspickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                              String formattedDate = DateFormat("dd-MM-yyyy")
                                  .format(baspickedDate!);
                              print(
                                  formattedDate); //formatted date output using intl package =>  2021-03-16
                              //you can implement different kind of Date Format here according to your requirement

                              setState(() {
                                baslangic.text =
                                    formattedDate; //set output date to TextField value.
                              });
                            } else {
                              print("Date is not selected");
                            }
                          },
                        ),
                      ),
                      Container(
                        width: (MediaQuery.of(context).size.width / 2) - 20,
                        child: TextField(
                          controller:
                              bitis, //editing controller of this TextField
                          decoration: InputDecoration(
                              icon: Icon(
                                  Icons.calendar_today), //icon of text field
                              labelText: BitTarih //label text of field
                              ),
                          readOnly:
                              true, //set it true, so that user will not able to edit text
                          onTap: () async {
                            bitpickedDate = await DatePicker.showDatePicker(
                                context,
                                showTitleActions: true,
                                minTime: DateTime(2000, 1, 1),
                                maxTime: DateTime(2109, 12, 31),
                                onChanged: (date) {
                              print('change $date');
                            }, onConfirm: (date) {
                              print('confirm $date');
                            },
                                currentTime: DateTime.now(),
                                locale: LocaleType.tr);

                            if (bitpickedDate != null) {
                              print(
                                  bitpickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                              String formattedDate = DateFormat("dd-MM-yyyy")
                                  .format(bitpickedDate!);
                              print(
                                  formattedDate); //formatted date output using intl package =>  2021-03-16
                              //you can implement different kind of Date Format here according to your requirement

                              setState(() {
                                bitis.text =
                                    formattedDate; //set output date to TextField value.
                              });
                            } else {
                              print("Date is not selected");
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                )
              : Container(),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Color.fromARGB(255, 171, 179, 225)),
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
                    if (baspickedDate != null && bitpickedDate != null) {
                      Duration diff = bitpickedDate!.difference(baspickedDate!);
                      if (diff.isNegative) {
                        showSnackBar(context, yanlistarih);
                      } else {
                        sorgu();
                      }
                    } else {
                      sorgu();
                    }
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
                                  const Color.fromARGB(255, 171, 197, 225)),
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
                                  Color.fromARGB(255, 225, 171, 171)),
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
                              filterkategori = "";
                              filterfirma = "";

                              setState(() {
                                filterhidden;
                                filterdurum;
                                filterkategori;
                                baspickedDate = null;
                                bitpickedDate = null;
                                baslangic.text = "";
                                bitis.text = "";
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
                  color: const Color.fromARGB(255, 242, 242, 242),
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
                    if (filtercolection == "filter") {
                      filterdurum = value.toString();
                    }
                    if (filtercolection == "kategori") {
                      filterkategori = value.toString();
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
