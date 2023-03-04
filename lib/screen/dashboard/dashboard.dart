import 'package:animated_pie_chart/animated_pie_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:selective/utils/color.dart';
import 'package:selective/utils/text.dart';
import 'package:selective/utils/utils.dart';

class dasboard_screen extends StatefulWidget {
  const dasboard_screen({super.key});

  @override
  State<dasboard_screen> createState() => _dasboard_screenState();
}

class _dasboard_screenState extends State<dasboard_screen> {
  TextEditingController baslangic = TextEditingController();
  TextEditingController bitis = TextEditingController();
  DateTime? baspickedDate;
  DateTime? bitpickedDate;
  int touchedIndex = -1;
  int loading = 0;
  int postuzunluk = 0;
  List firmaid = [];
  List firmaNames = [];
  List firmapostuzunluk = [];
  List<MdPieChart> pieChartList = [];
  late int k1, k2, k3, k4, k5;
  getdata() async {
    loading = 1;
    postuzunluk = 0;
    firmapostuzunluk.clear();
    firmaNames.clear();
    firmaid.clear();
    pieChartList.clear();
    k1 = 0;
    k2 = 0;
    k3 = 0;
    k4 = 0;
    k5 = 0;
    setState(() {});
    if (baslangic.text == "" && baslangic.text == "") {
      var postSnap = await FirebaseFirestore.instance.collection('posts').get();
      postuzunluk = postSnap.docs.length;
      var firmaSnap =
          await FirebaseFirestore.instance.collection("firma").get().then(
                (QuerySnapshot snapshot) => {
                  snapshot.docs.forEach((f) {
                    firmaid.add(f.reference.id);
                  }),
                },
              );
      for (var i = 0; i < firmaid.length; i++) {
        var firmaName = await FirebaseFirestore.instance
            .collection("firma")
            .doc(firmaid[i])
            .get();
        firmaNames.add(firmaName.data()!['firma_name']);
        print(firmaNames[i]);
      }
      firmaNames.remove("Selective");
      for (var i = 0; i < firmaNames.length; i++) {
        var firmaPuzunluk = await FirebaseFirestore.instance
            .collection("posts")
            .where("firma", isEqualTo: firmaNames[i])
            .get();
        firmapostuzunluk.add(firmaPuzunluk.docs.length);

//

        var Girisnouzunluk = await FirebaseFirestore.instance
            .collection("posts")
            .where("firma", isEqualTo: firmaNames[i])
            .where("kategori", isEqualTo: 'Selective Giriş Yapamıyorum')
            .get();
        k1 = Girisnouzunluk.docs.length;
        var istekuzunluk = await FirebaseFirestore.instance
            .collection("posts")
            .where("firma", isEqualTo: firmaNames[i])
            .where("kategori", isEqualTo: 'İstek Talebi')
            .get();
        k2 = istekuzunluk.docs.length;
        var egitimuzunluk = await FirebaseFirestore.instance
            .collection("posts")
            .where("firma", isEqualTo: firmaNames[i])
            .where("kategori", isEqualTo: 'Eğitim Talebi')
            .get();
        k3 = egitimuzunluk.docs.length;
        var digeruzunluk = await FirebaseFirestore.instance
            .collection("posts")
            .where("firma", isEqualTo: firmaNames[i])
            .where("kategori", isEqualTo: 'Diğer')
            .get();
        k4 = digeruzunluk.docs.length;
        var kurulumuzunluk = await FirebaseFirestore.instance
            .collection("posts")
            .where("firma", isEqualTo: firmaNames[i])
            .where("kategori", isEqualTo: 'Selective Kurulum Talebi')
            .get();
        k5 = kurulumuzunluk.docs.length;
//
        print(firmapostuzunluk.length);
        print(postuzunluk);
        int yuzde = ((firmapostuzunluk[i].floor() * 100) / postuzunluk).toInt();
        print(yuzde);

        pieChartList.add(MdPieChart(
            value: yuzde,
            name: firmaNames[i] +
                " - " +
                firmapostuzunluk[i].toString() +
                "  Adet \n Taplepte Bulundu"));
      }
    } else if (baslangic.text != "" && baslangic.text != "") {
      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where("datePublished", isGreaterThanOrEqualTo: baspickedDate)
          .where("datePublished", isLessThanOrEqualTo: bitpickedDate)
          .get();
      postuzunluk = postSnap.docs.length;
      var firmaSnap =
          await FirebaseFirestore.instance.collection("firma").get().then(
                (QuerySnapshot snapshot) => {
                  snapshot.docs.forEach((f) {
                    firmaid.add(f.reference.id);
                  }),
                },
              );
      for (var i = 0; i < firmaid.length; i++) {
        var firmaName = await FirebaseFirestore.instance
            .collection("firma")
            .doc(firmaid[i])
            .get();
        firmaNames.add(firmaName.data()!['firma_name']);
        print(firmaNames[i]);
      }
      firmaNames.remove("Selective");
      for (var i = 0; i < firmaNames.length; i++) {
        var firmaPuzunluk = await FirebaseFirestore.instance
            .collection("posts")
            .where("firma", isEqualTo: firmaNames[i])
            .where("datePublished", isGreaterThanOrEqualTo: baspickedDate)
            .where("datePublished", isLessThanOrEqualTo: bitpickedDate)
            .get();

//

        var Girisnouzunluk = await FirebaseFirestore.instance
            .collection("posts")
            .where("firma", isEqualTo: firmaNames[i])
            .where("datePublished", isGreaterThanOrEqualTo: baspickedDate)
            .where("datePublished", isLessThanOrEqualTo: bitpickedDate)
            .where("kategori", isEqualTo: 'Selective Giriş Yapamıyorum')
            .get();
        k1 = Girisnouzunluk.docs.length;
        var istekuzunluk = await FirebaseFirestore.instance
            .collection("posts")
            .where("firma", isEqualTo: firmaNames[i])
            .where("datePublished", isGreaterThanOrEqualTo: baspickedDate)
            .where("datePublished", isLessThanOrEqualTo: bitpickedDate)
            .where("kategori", isEqualTo: 'İstek Talebi')
            .get();
        k2 = istekuzunluk.docs.length;
        var egitimuzunluk = await FirebaseFirestore.instance
            .collection("posts")
            .where("firma", isEqualTo: firmaNames[i])
            .where("datePublished", isGreaterThanOrEqualTo: baspickedDate)
            .where("datePublished", isLessThanOrEqualTo: bitpickedDate)
            .where("kategori", isEqualTo: 'Eğitim Talebi')
            .get();
        k3 = egitimuzunluk.docs.length;
        var digeruzunluk = await FirebaseFirestore.instance
            .collection("posts")
            .where("firma", isEqualTo: firmaNames[i])
            .where("datePublished", isGreaterThanOrEqualTo: baspickedDate)
            .where("datePublished", isLessThanOrEqualTo: bitpickedDate)
            .where("kategori", isEqualTo: 'Diğer')
            .get();
        k4 = digeruzunluk.docs.length;
        var kurulumuzunluk = await FirebaseFirestore.instance
            .collection("posts")
            .where("firma", isEqualTo: firmaNames[i])
            .where("datePublished", isGreaterThanOrEqualTo: baspickedDate)
            .where("datePublished", isLessThanOrEqualTo: bitpickedDate)
            .where("kategori", isEqualTo: 'Selective Kurulum Talebi')
            .get();
        k5 = kurulumuzunluk.docs.length;
//
        firmapostuzunluk.add(firmaPuzunluk.docs.length);
        print(firmapostuzunluk.length);
        print(postuzunluk);
        if (postuzunluk == 0) {
          postuzunluk = 1;
        }
        int yuzde = ((firmapostuzunluk[i].floor() * 100) / postuzunluk).toInt();
        print(yuzde);

        pieChartList.add(MdPieChart(
            value: yuzde,
            name: firmaNames[i] +
                " " +
                firmapostuzunluk[i].toString() +
                "  Adet Taplepte Bulundu"));
      }
    }

    loading = 0;
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
  }

  Container TarihAralik() {
    return Container(
      color: Color.fromARGB(255, 248, 247, 247),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: (MediaQuery.of(context).size.width / 2) - 20,
            child: TextField(
              textAlign: TextAlign.center,
              controller: baslangic, //editing controller of this TextField
              decoration: InputDecoration(
                  border: InputBorder.none,
                  // icon: Icon(Icons.calendar_today), //icon of text field
                  labelText: BasTarih //label text of field
                  ),
              readOnly:
                  true, //set it true, so that user will not able to edit text
              onTap: () async {
                baspickedDate = await DatePicker.showDatePicker(context,
                    showTitleActions: true,
                    minTime: DateTime(2000, 1, 1),
                    maxTime: DateTime(2109, 12, 31), onChanged: (date) {
                  print('change $date');
                }, onConfirm: (date) {
                  print('confirm $date');
                }, currentTime: DateTime.now(), locale: LocaleType.tr);

                if (baspickedDate != null) {
                  print(
                      baspickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                  String formattedDate =
                      DateFormat("dd-MM-yyyy").format(baspickedDate!);
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
              textAlign: TextAlign.center,
              controller: bitis, //editing controller of this TextField
              decoration: InputDecoration(
                  border: InputBorder.none,
                  //   icon: Icon(Icons.calendar_today), //icon of text field
                  labelText: BitTarih //label text of field
                  ),
              readOnly:
                  true, //set it true, so that user will not able to edit text
              onTap: () async {
                bitpickedDate = await DatePicker.showDatePicker(context,
                    showTitleActions: true,
                    minTime: DateTime(2000, 1, 1),
                    maxTime: DateTime(2109, 12, 31), onChanged: (date) {
                  print('change $date');
                }, onConfirm: (date) {
                  print('confirm $date');
                }, currentTime: DateTime.now(), locale: LocaleType.tr);

                if (bitpickedDate != null) {
                  print(
                      bitpickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                  String formattedDate =
                      DateFormat("dd-MM-yyyy").format(bitpickedDate!);
                  print(
                      formattedDate); //formatted date output using intl package =>  2021-03-16
                  //you can implement different kind of Date Format here according to your requirement
                  Duration diff = bitpickedDate!.difference(baspickedDate!);
                  if (diff.isNegative) {
                    showSnackBar(context, yanlistarih);
                  } else {
                    setState(() {
                      bitis.text = formattedDate;
                      //set output date to TextField value.
                    });
                    getdata();
                  }
                } else {
                  print("Date is not selected");
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: loading == 1
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  TarihAralik(),
                  Container(
                    height: 600,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: AnimatedPieChart(
                            sort: true,
                            stokeWidth: 8.0,
                            padding: 4.0,
                            animatedSpeed: 800,
                            pieRadius: 70.0,
                            colorsList: [
                              Colors.indigo,
                              Colors.brown,
                              Colors.purple,
                              Colors.red,
                              Colors.yellow,
                              Colors.green,
                              Colors.black,
                              Colors.cyan,
                              Colors.orange,
                              Colors.pinkAccent,
                            ],
                            pieData: [
                              for (int i = 0; i < pieChartList.length; i++)
                                MdPieChart(
                                    value: pieChartList[i].value,
                                    name: pieChartList[i].name)
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
