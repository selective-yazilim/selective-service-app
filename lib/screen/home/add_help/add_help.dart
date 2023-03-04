import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker_view/multi_image_picker_view.dart';
import 'package:selective/services/firestore_methods.dart';
import 'package:selective/utils/color.dart';
import 'package:selective/utils/text.dart';
import 'package:selective/utils/utils.dart';

class add_post_screen extends StatefulWidget {
  final String uid;
  const add_post_screen({super.key, required this.uid});

  @override
  State<add_post_screen> createState() => _add_post_screenState();
}

class _add_post_screenState extends State<add_post_screen> {
  FireStoreMethods _fireStoreMethods = FireStoreMethods();
  TextEditingController _controller_aciklama = TextEditingController();
  TextEditingController _controller_diger = TextEditingController();
  TextEditingController _controller_name = TextEditingController();

  List<String> imageslist = [];
  String selectedValue = "Eğitim Talebi";
  String durum = "";

  int diger = 1;
  final controller = MultiImagePickerController(
      maxImages: 3,
      allowedImageTypes: ['png', 'jpg', 'jpeg'],
      withData: true,
      withReadStream: true,
      images: <ImageFile>[] // array of pre/default selected images
      );

  FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    getData();
  }

  var userData = {};
  var username = "";
  var firma = "";
  var yetki;

  bool isLoading = false;
  bool _isLoading = false;
  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();

      userData = userSnap.data()!;

      username = userSnap.data()!['username'];
      firma = userSnap.data()!['firma'];
      yetki = userSnap.data()!["yetki"];
      _controller_name.text = username;
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

  int dgr = 0;
  void sendToPost() async {
    setState(() {
      _isLoading = true;
    });
    yetki == 0 ? durum = FirmaOnaybekliyor : durum = SelectivedenOnaybekliyor;
    yetki == 0 ? dgr = 0 : dgr = 1;
    _fireStoreMethods.uploadPost(
        _controller_aciklama.text,
        widget.uid,
        _controller_name.text,
        imageslist,
        _controller_diger.text,
        selectedValue,
        firma,
        durum,
        dgr);

    Navigator.pop(context);
    isLoading = false;
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
                title: Text(Nasilyardimci),
                centerTitle: true,
              ),
            ),
            body: SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Container(
                        height: 150,
                        child: MultiImagePickerView(
                          controller: controller,
                          padding: const EdgeInsets.all(10),
                        ),
                      ),
                      Row(children: [
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection('kategori')
                                    .snapshots(includeMetadataChanges: true),
                                builder: (context,
                                    AsyncSnapshot<
                                            QuerySnapshot<Map<String, dynamic>>>
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
                                            color: colors().white,
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
                                                labelText: Kategorisec,
                                                border: InputBorder.none,
                                              ),
                                            ),
                                            items: snapshot.data!.docs
                                                .map((DocumentSnapshot
                                                    document) {
                                                  Map<String, dynamic> data =
                                                      document.data()! as Map<
                                                          String, dynamic>;

                                                  return data["kategori"];
                                                })
                                                .toList()
                                                .cast<String>(),
                                            onChanged: (value) {
                                              selectedValue = value!;

                                              if (selectedValue == "Diğer") {
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
                                colors().mainColor),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30)),
                              ),
                            )),
                        onPressed: () async {
                          final images = controller.images;

                          for (final image in images) {
                            if (image.hasPath) {
                              imageslist.add(image.path!);
                            } else {
                              print("object");
                            }
                          }
                          try {
                            if (selectedValue == "Diğer") {
                              if (_controller_diger.text != "" &&
                                  _controller_aciklama.text != "" &&
                                  _controller_name.text != "") {
                                sendToPost();
                                imageslist = [];
                              } else {
                                showSnackBar(context, bosbirakma);
                              }
                            } else {
                              if (_controller_aciklama.text != "" &&
                                  _controller_name.text != "") {
                                sendToPost();

                                imageslist = [];
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

List<DropdownMenuItem<String>> get dropdownItems {
  List<DropdownMenuItem<String>> timeitems = [
    const DropdownMenuItem(
        value: "Eğitim Talebi",
        child: Text(
          "Eğitim Talebi",
          style: TextStyle(fontSize: 14),
        )),
    const DropdownMenuItem(
        value: "Selective Giriş Yapamıyorum ",
        child: Text(
          "Selective Giriş Yapamıyorum ",
          style: TextStyle(fontSize: 14),
        )),
    const DropdownMenuItem(
        value: "İstek Talebi",
        child: Text(
          "İstek Talebi",
          style: TextStyle(fontSize: 14),
        )),
    const DropdownMenuItem(
        value: "Diğer",
        child: Text(
          "Diğer",
          style: TextStyle(fontSize: 14),
        )),
  ];
  return timeitems;
}
