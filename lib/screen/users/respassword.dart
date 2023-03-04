import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:selective/services/auth.dart';
import 'package:selective/utils/color.dart';
import 'package:selective/utils/text.dart';
import 'package:selective/utils/utils.dart';

class respassword_screen extends StatefulWidget {
  const respassword_screen({super.key});

  @override
  State<respassword_screen> createState() => _respassword_screenState();
}

class _respassword_screenState extends State<respassword_screen> {
  @override
  Widget build(BuildContext context) {
    TextEditingController _password = TextEditingController();
    String esifre = "";
    int loading = 0;
    getData() async {
      try {
        loading = 1;
        var userSnap = await FirebaseFirestore.instance
            .collection('users')
            .doc(
              FirebaseAuth.instance.currentUser!.uid, //doc id
            )
            .get();

        esifre = userSnap.data()!['password'];

        loading = 0;
        setState(() {});
      } catch (e) {
        print(e);
      }
    }

    authservices _auth = authservices();
    return Scaffold(
      body: loading == 1
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              color: colors().white,
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  textfield(_password, "Yeni Şifre", Icons.lock, 60, false),
                  Container(
                    width: 300,
                    child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Color.fromARGB(255, 171, 179, 225)),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30)),
                              ),
                            )),
                        onPressed: () async {
                          if (_password.text.length < 6) {
                            showSnackBar(context, Sifreuzun);
                          } else {
                            _auth.changePassword(
                                esifre.toString(), _password.text);
                            showSnackBar(context, Sifredegisti);
                          }
                        },
                        child: Text(
                          Kaydet,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        )),
                  )
                ],
              ),
            ),
    );
  }

  Padding textfield(TextEditingController controller, String hinttext,
      IconData icon, int max, bool yaz) {
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
            readOnly: yaz,
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
