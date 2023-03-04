import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:selective/notifications/notif.dart';
import 'package:selective/utils/color.dart';
import 'package:selective/utils/text.dart';
import 'package:selective/utils/utils.dart';

class info_scren extends StatefulWidget {
  const info_scren({super.key});

  @override
  State<info_scren> createState() => _info_screnState();
}

class _info_screnState extends State<info_scren> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: colors().mainColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: colors().mainColor,
              radius: 70,
              child: Image(
                image: AssetImage(logo),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              Bizeulas,
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: colors().white),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              decoration: BoxDecoration(
                color: colors().white,
                borderRadius: BorderRadius.all(Radius.circular(20)),
                border: Border.all(
                  color: colors().white,
                ),
                boxShadow: [
                  BoxShadow(
                    color: colors().black.withOpacity(0.2),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(Adres,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                    ),
                    Text(
                      Adresacik,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(telefon,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        Telefonacik,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(Email,
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              decorationStyle: TextDecorationStyle.dashed)),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        Emailacik,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          Text(Banka,
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  decorationStyle: TextDecorationStyle.dashed)),
                          IconButton(
                              onPressed: () {
                                Clipboard.setData(ClipboardData(text: Iban));
                                showSnackBar(context, Ibancpoy);
                              },
                              iconSize: 20,
                              icon: Icon(Icons.copy)),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(Bankaacik),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
