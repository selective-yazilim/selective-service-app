import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:multi_image_picker_view/multi_image_picker_view.dart';
import 'package:selective/services/firestore_methods.dart';
import 'package:selective/utils/color.dart';
import 'package:selective/utils/text.dart';
import 'package:selective/utils/utils.dart';

class edit_screen extends StatefulWidget {
  final String uid;
  final String postuid;
  const edit_screen({super.key, required this.uid, required this.postuid});

  @override
  State<edit_screen> createState() => _edit_screenState();
}

class _edit_screenState extends State<edit_screen> {
  FireStoreMethods _fireStoreMethods = FireStoreMethods();
  TextEditingController _controller_aciklama = TextEditingController();
  TextEditingController _controller_diger = TextEditingController();
  TextEditingController _controller_name = TextEditingController();
  late ImageFile resim;

  List<String> imageslist = [];
  String selectedValue = "Eğitim Talebi";
  int diger = 1;

  FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    getData();
  }

  var userData = {};
  String pervdescription = "";
  String pervusername = "";
  String pervbaslik = "";
  String pervkategori = "";
  String pervdate = "";
  var firma = "";

  var username = "";
  bool isLoading = false;
  bool _isLoading = false;
  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.postuid)
          .get();

      userData = userSnap.data()!;
      username = userSnap.data()!['username'];
      _controller_aciklama.text = postSnap.data()!["description"];
      _controller_diger.text = postSnap.data()!["baslik"];
      _controller_name.text = username;
      pervdescription = postSnap.data()!["description"].toString();
      pervusername = postSnap.data()!["name"].toString();
      pervbaslik = postSnap.data()!["baslik"].toString();
      pervkategori = postSnap.data()!["kategori"].toString();
      selectedValue = postSnap.data()!["kategori"].toString();
      pervdate = DateFormat.yMMMMd()
          .format(postSnap.data()!["datePublished"].toDate());
      if (selectedValue == "Diğer") {
        diger = 2;
      } else {
        diger = 1;
      }
      setState(() {});
    } catch (e) {
      showSnackBar(
        context,
        e.toString(),
      );
      print(e);
    }
    setState(() {
      isLoading = false;
    });
  }

  void sendToPost() async {
    setState(() {
      _isLoading = true;
    });
    Future<String> res = _fireStoreMethods.updatepost(
        _controller_aciklama.text,
        widget.uid,
        widget.postuid,
        _controller_name.text,
        imageslist,
        _controller_diger.text,
        selectedValue,
        pervdescription,
        pervusername,
        pervbaslik,
        pervkategori,
        pervdate,
        firma);

    if (res == "success") {
      print("başarılı");

      setState(() {
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(40.0),
              child: AppBar(
                title: Text(PostDuzenle),
                centerTitle: true,
              ),
            ),
            body: SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Row(children: [
                            Container(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  StreamBuilder(
                                    stream: FirebaseFirestore.instance
                                        .collection('kategori')
                                        .snapshots(
                                            includeMetadataChanges: true),
                                    builder: (context,
                                        AsyncSnapshot<
                                                QuerySnapshot<
                                                    Map<String, dynamic>>>
                                            snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }

                                      return Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  60,
                                              decoration: BoxDecoration(
                                                color: colors().secondWhite,
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(40)),
                                                border: Border.all(
                                                  color: colors().white,
                                                ),
                                              ),
                                              child: DropdownSearch<String>(
                                                selectedItem: selectedValue,
                                                dropdownDecoratorProps:
                                                    DropDownDecoratorProps(
                                                  dropdownSearchDecoration:
                                                      InputDecoration(
                                                    border: InputBorder.none,
                                                    labelText: Kategorisec,
                                                  ),
                                                ),
                                                items: snapshot.data!.docs
                                                    .map((DocumentSnapshot
                                                        document) {
                                                      Map<String, dynamic>
                                                          data =
                                                          document.data()!
                                                              as Map<String,
                                                                  dynamic>;

                                                      return data["kategori"];
                                                    })
                                                    .toList()
                                                    .cast<String>(),
                                                onChanged: (value) {
                                                  selectedValue = value!;

                                                  if (selectedValue ==
                                                      "Diğer") {
                                                    diger = 2;
                                                  } else {
                                                    diger = 1;
                                                  }
                                                  setState(() {
                                                    diger;
                                                    selectedValue;
                                                  });
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ]),
                        ],
                      ),
                      Container(
                        height: 360,
                        child: ListView.builder(
                          itemCount: 1,
                          itemBuilder: (context, index) => diger == 1
                              ? Column(
                                  children: [
                                    textfields(_controller_aciklama, 300, 40,
                                        900, Sorunacik),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    textfields(
                                        _controller_name, 50, 1, 40, Adyaz)
                                  ],
                                )
                              : Column(
                                  children: [
                                    textfields(_controller_diger, 50, 1, 40,
                                        SorunAdyaz),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    textfields(_controller_aciklama, 240, 30,
                                        400, Sorunacik),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    textfields(
                                        _controller_name, 50, 1, 40, Adyaz)
                                  ],
                                ),
                        ),
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                              colors().mainColor,
                            ),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30)),
                              ),
                            )),
                        onPressed: () async {
                          try {
                            if (selectedValue == "Diğer") {
                              if (_controller_diger.text != "" &&
                                  _controller_aciklama.text != "" &&
                                  _controller_name.text != "") {
                                sendToPost();
                                imageslist = [];
                                Navigator.pop(context);
                              } else {
                                showSnackBar(context, bosbirakma);
                              }
                            } else {
                              if (_controller_aciklama.text != "" &&
                                  _controller_name.text != "") {
                                sendToPost();
                                imageslist = [];
                                Navigator.pop(context);
                              } else {
                                showSnackBar(context, bosbirakma);
                              }
                            }
                          } catch (e) {
                            print(e);
                          }
                        },
                        child: !_isLoading
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(Gonder),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Icon(Icons.send),
                                ],
                              )
                            : Center(child: CircularProgressIndicator()),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
  }

  Widget textfields(
    TextEditingController control,
    double height,
    int maxline,
    int maxLengh,
    String hinttext,
  ) {
    return Material(
      elevation: 8,
      shadowColor: colors().black,
      color: colors().white,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        height: height,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(30))),
        width: MediaQuery.of(context).size.width,
        child: TextField(
          controller: control,
          cursorColor: colors().white,
          maxLines: maxline,
          maxLength: maxLengh,
          decoration: InputDecoration(
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none),
            hintText: hinttext,
            counterText: '',
            filled: true,
            fillColor: colors().white,
          ),
        ),
      ),
    );
  }
}
