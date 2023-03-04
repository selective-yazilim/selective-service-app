import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:selective/services/firestore_methods.dart';
import 'package:selective/utils/color.dart';
import 'package:selective/utils/text.dart';

class firma_edit_screen extends StatefulWidget {
  final String firmaid;
  const firma_edit_screen({super.key, required this.firmaid});

  @override
  State<firma_edit_screen> createState() => _firma_edit_screenState();
}

class _firma_edit_screenState extends State<firma_edit_screen> {
  TextEditingController firma = TextEditingController();

  TextEditingController username = TextEditingController();
  TextEditingController mail = TextEditingController();
  TextEditingController telefon = TextEditingController();
  FireStoreMethods _fireStoreMethods = FireStoreMethods();
  PhoneCountryData? _initialCountryData;

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
      var usersnap = await FirebaseFirestore.instance
          .collection('firma')
          .doc(widget.firmaid)
          .get();
      firma.text = usersnap.data()!['firma_name'];
      mail.text = usersnap.data()!['firma_email'];
      telefon.text = usersnap.data()!['firma_tel'].toString();

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
        backgroundColor: colors().mainColor,
        centerTitle: false,
        title: Row(
          children: [
            SizedBox(
              width: 50,
            ),
            CircleAvatar(
              backgroundColor: colors().mainColor,
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
      body: PageView(children: [
        Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            children: [
              Text(
                FirmaDuzenle,
                style: TextStyle(fontSize: 30),
              ),
              textfield(firma, "Firma Adı", Icons.account_balance_sharp, 40),
              textfield(mail, "E-mail", Icons.mail_outline, 40),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: TextFormField(
                        controller: telefon,
                        //  key: ValueKey(_initialCountryData ?? 'country'),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                          hintText: Telgir,
                          //      _initialCountryData?.phoneMaskWithoutCountryCode,
                          hintStyle:
                              TextStyle(color: Colors.black.withOpacity(.3)),
                          errorStyle: TextStyle(
                            color: Colors.red,
                          ),
                          filled: true,
                          fillColor: colors().white,
                        ),
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          PhoneInputFormatter(
                            allowEndlessPhone: false,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 50,
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  onPressed: () async {
                    _fireStoreMethods.firma_update(
                        firma.text, mail.text, telefon.text, widget.firmaid);
                    Navigator.pop(context);
                  },
                  child: Text(Kaydet),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        colors().mainColor,
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
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
}
