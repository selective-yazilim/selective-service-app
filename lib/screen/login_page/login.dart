import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:selective/navigator.dart';
import 'package:selective/services/auth.dart';
import 'package:selective/utils/color.dart';
import 'package:selective/utils/text.dart';
import 'package:selective/utils/utils.dart';

class login_screen extends StatefulWidget {
  const login_screen({super.key});

  @override
  State<login_screen> createState() => _login_screenState();
}

class _login_screenState extends State<login_screen> {
  String res = "";
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  int isloading = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            color: colors().mainColor,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 80,
                    ),
                    CircleAvatar(
                      backgroundColor: colors().mainColor,
                      backgroundImage: AssetImage(logo),
                      radius: 100,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 10),
                      padding: const EdgeInsets.only(left: 10),
                      decoration: BoxDecoration(
                        color: colors().secondWhite,
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Icon(Icons.person_outline),
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.only(left: 10),
                              child: TextFormField(
                                controller: username,
                                maxLines: 1,
                                decoration: InputDecoration(
                                  label: Text(UserName),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 10),
                      padding: const EdgeInsets.only(left: 10),
                      decoration: BoxDecoration(
                        color: colors().secondWhite,
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Icon(Icons.lock_outline),
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.only(left: 10),
                              child: TextFormField(
                                controller: password,
                                maxLines: 1,
                                decoration: InputDecoration(
                                  label: Text(PassWord),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: 300,
                      height: 40,
                      child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  colors().secondColor),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30)),
                                ),
                              )),
                          onPressed: () async {
                            isloading = 1;
                            setState(() {});
                            res = (await authservices().giris(
                                    username.text.toLowerCase(), password.text))
                                as String;

                            if (res == Succes) {
                              isloading = 0;
                              setState(() {});
                              // ignore: use_build_context_synchronously
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => navigator_screen(
                                        uid: FirebaseAuth
                                            .instance.currentUser!.uid),
                                  ));
                            } else {
                              isloading = 0;
                              setState(() {});
                              // ignore: use_build_context_synchronously
                              showSnackBar(context, res);
                            }
                          },
                          child: isloading == 0
                              ? Text(
                                  Login,
                                  style: TextStyle(
                                      color: colors().white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                )
                              : Center(
                                  child: CircularProgressIndicator(),
                                )),
                    ),
                  ],
                ),
              ),
            )));
  }
}
