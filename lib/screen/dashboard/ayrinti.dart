import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:selective/utils/text.dart';
import 'package:selective/utils/utils.dart';

class ayrinti_scrren extends StatefulWidget {
  const ayrinti_scrren({super.key});

  @override
  State<ayrinti_scrren> createState() => _ayrinti_scrrenState();
}

class _ayrinti_scrrenState extends State<ayrinti_scrren> {
  TextEditingController baslangic = TextEditingController();
  TextEditingController bitis = TextEditingController();
  DateTime? baspickedDate;
  DateTime? bitpickedDate;
  late Stream filter;
  int loading = 0;
  int postuzunluk = 0;
  List firmaid = [];
  List firmaNames = [];
  List firmapostuzunluk = [];

  List<int> k1 = [];
  List<int> k2 = [];
  List<int> k3 = [];
  List<int> k4 = [];
  List<int> k5 = [];

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
                    sorgu();
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

  sorgu() async {
    loading = 1;
    setState(() {});
    postuzunluk = 0;
    firmapostuzunluk.clear();
    firmaNames.clear();
    firmaid.clear();
    k1.clear();
    k2.clear();
    k3.clear();
    k4.clear();
    k5.clear();

//
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
        k1.add(Girisnouzunluk.docs.length);
        var istekuzunluk = await FirebaseFirestore.instance
            .collection("posts")
            .where("firma", isEqualTo: firmaNames[i])
            .where("kategori", isEqualTo: 'İstek Talebi')
            .get();
        k2.add(istekuzunluk.docs.length);
        var egitimuzunluk = await FirebaseFirestore.instance
            .collection("posts")
            .where("firma", isEqualTo: firmaNames[i])
            .where("kategori", isEqualTo: 'Eğitim Talebi')
            .get();
        k3.add(egitimuzunluk.docs.length);
        var digeruzunluk = await FirebaseFirestore.instance
            .collection("posts")
            .where("firma", isEqualTo: firmaNames[i])
            .where("kategori", isEqualTo: 'Diğer')
            .get();
        k4.add(digeruzunluk.docs.length);
        var kurulumuzunluk = await FirebaseFirestore.instance
            .collection("posts")
            .where("firma", isEqualTo: firmaNames[i])
            .where("kategori", isEqualTo: 'Selective Kurulum Talebi')
            .get();
        k5.add(kurulumuzunluk.docs.length);
        //   filter = (await FirebaseFirestore.instance
        //      .collection("firma")
        //      .where("firma_name", isEqualTo: firmaNames[i])
        //      .get()) as Future;
      }
      loading = 0;
    } else {
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
        k1.add(Girisnouzunluk.docs.length);
        var istekuzunluk = await FirebaseFirestore.instance
            .collection("posts")
            .where("firma", isEqualTo: firmaNames[i])
            .where("datePublished", isGreaterThanOrEqualTo: baspickedDate)
            .where("datePublished", isLessThanOrEqualTo: bitpickedDate)
            .where("kategori", isEqualTo: 'İstek Talebi')
            .get();
        k2.add(istekuzunluk.docs.length);
        var egitimuzunluk = await FirebaseFirestore.instance
            .collection("posts")
            .where("firma", isEqualTo: firmaNames[i])
            .where("datePublished", isGreaterThanOrEqualTo: baspickedDate)
            .where("datePublished", isLessThanOrEqualTo: bitpickedDate)
            .where("kategori", isEqualTo: 'Eğitim Talebi')
            .get();
        k3.add(egitimuzunluk.docs.length);
        var digeruzunluk = await FirebaseFirestore.instance
            .collection("posts")
            .where("firma", isEqualTo: firmaNames[i])
            .where("datePublished", isGreaterThanOrEqualTo: baspickedDate)
            .where("datePublished", isLessThanOrEqualTo: bitpickedDate)
            .where("kategori", isEqualTo: 'Diğer')
            .get();
        k4.add(digeruzunluk.docs.length);
        var kurulumuzunluk = await FirebaseFirestore.instance
            .collection("posts")
            .where("firma", isEqualTo: firmaNames[i])
            .where("datePublished", isGreaterThanOrEqualTo: baspickedDate)
            .where("datePublished", isLessThanOrEqualTo: bitpickedDate)
            .where("kategori", isEqualTo: 'Selective Kurulum Talebi')
            .get();
        k5.add(kurulumuzunluk.docs.length);
        //  filter = (await FirebaseFirestore.instance
        //      .collection("firma")
        //      .where("firma_name", isEqualTo: firmaNames[i])
        //      .get()) as Future;

      }
    }
    print(firmaNames.length);
    loading = 0;

    setState(() {
      loading;
      print("loading $loading");
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sorgu();
  }

  @override
  Widget build(BuildContext context) {
    return loading == 1
        ? Center(
            child: CircularProgressIndicator(),
          )
        : SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                TarihAralik(),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("firma")
                        .snapshots(),
                    builder: (context,
                        AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                            snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      return Container(
                        height: MediaQuery.of(context).size.height - 20,
                        child: DataTable(
                          showCheckboxColumn: false,
                          columns: [
                            DataColumn(label: Text('Firma')),
                            DataColumn(
                                label: Text('Selective Giriş Yapamıyorum')),
                            DataColumn(label: Text('İstek Talebi')),
                            DataColumn(label: Text('Eğitim Talebi')),
                            DataColumn(label: Text('Diğer')),
                            DataColumn(label: Text('Selective Kurulum Talebi')),
                          ],
                          rows: List<DataRow>.generate(
                            firmaNames.length,
                            (index) {
                              print(snapshot.data!.docs[index]
                                  .data()["firma_name"]
                                  .toString());
                              return DataRow(
                                  color: index % 2 == 0
                                      ? MaterialStateColor.resolveWith(
                                          (states) => Color.fromARGB(
                                              255, 171, 197, 225))
                                      : MaterialStateColor.resolveWith(
                                          (states) => Color.fromARGB(
                                              255, 255, 255, 255)),
                                  cells: [
                                    DataCell(Text(
                                      snapshot.data!.docs[index]
                                          .data()["firma_name"]
                                          .toString(),
                                    )),
                                    DataCell(Text("${k1[index]}")),
                                    DataCell(Text("${k2[index]}")),
                                    DataCell(Text("${k3[index]}")),
                                    DataCell(Text("${k4[index]}")),
                                    DataCell(Text("${k5[index]}")),
                                  ]);
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ));
  }
}
