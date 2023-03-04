import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:selective/services/firestore_methods.dart';
import 'package:selective/utils/color.dart';
import 'package:selective/utils/text.dart';

class firma_add_screen extends StatefulWidget {
  const firma_add_screen({super.key});

  @override
  State<firma_add_screen> createState() => _firma_add_screenState();
}

class _firma_add_screenState extends State<firma_add_screen> {
  TextEditingController firma = TextEditingController();
  TextEditingController gorev = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController mail = TextEditingController();
  TextEditingController sifre = TextEditingController();
  TextEditingController telefon = TextEditingController();
  FireStoreMethods _fireStoreMethods = FireStoreMethods();
  PhoneCountryData? _initialCountryData;
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
                Firmakayit,
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
                        // key: ValueKey(_initialCountryData ?? 'country'),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                          hintText: Telgir,
                          hintStyle:
                              TextStyle(color: colors().black.withOpacity(.3)),
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
                            //  defaultCountryCode:
                            //    _initialCountryData?.countryCode,
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
                    _fireStoreMethods.firma_add(
                        firma.text, mail.text, telefon.text);
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
