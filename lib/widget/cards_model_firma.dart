import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:selective/screen/users/firma_edit.dart';
import 'package:selective/services/firestore_methods.dart';
import 'package:selective/utils/text.dart';
import 'package:selective/utils/utils.dart';

class cards_model_firma extends StatefulWidget {
  final snap;
  const cards_model_firma({super.key, required this.snap});

  @override
  State<cards_model_firma> createState() => _cards_model_firmaState();
}

class _cards_model_firmaState extends State<cards_model_firma> {
  late String userdurum;
  pasiffirma(String uid, String udurum, String firma) async {
    try {
      await FireStoreMethods().updatefirmadurum(uid, udurum, firma);
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
                                  builder: (context) => firma_edit_screen(
                                      firmaid: widget.snap['firma_uid']),
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
                    widget.snap['durum'] == "Aktif"
                        ? ListTile(
                            iconColor: Colors.red,
                            leading: const Icon(
                              Icons.pause_circle_outline_sharp,
                            ),
                            title: TextButton(
                                onPressed: () {
                                  pasiffirma(widget.snap['firma_uid'], "Pasif",
                                      widget.snap['firma_name']);
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
                              Icons.play_circle_outline_sharp,
                            ),
                            title: TextButton(
                                onPressed: () {
                                  pasiffirma(widget.snap['firma_uid'], "Aktif",
                                      widget.snap['firma_name']);
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
                          )
                  ],
                );
              });
        },
        child: Container(
          // boundary needed for web
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(30)),
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
                                                  widget.snap['firma_name']
                                                      .toString(),
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
                                          text: 'E-mail : ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      TextSpan(
                                        text: ' ${widget.snap['firma_email']}',
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
                                          text:
                                              'Telefon : ${widget.snap['firma_tel']}',
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
                                              'Oluşturulma Tarihi : ${DateFormat.yMMMMd().format(widget.snap['datePublished'].toDate())}',
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
}
