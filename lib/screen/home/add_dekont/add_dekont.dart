import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker_view/multi_image_picker_view.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:selective/services/firestore_methods.dart';
import 'package:selective/utils/utils.dart';

class add_dekont_screen extends StatefulWidget {
  final String uid;
  const add_dekont_screen({super.key, required this.uid});

  @override
  State<add_dekont_screen> createState() => _add_dekont_screenState();
}

class _add_dekont_screenState extends State<add_dekont_screen> {
  FireStoreMethods _fireStoreMethods = FireStoreMethods();
  TextEditingController _controller_aciklama = TextEditingController();
  TextEditingController _controller_diger = TextEditingController();
  TextEditingController _controller_name = TextEditingController();

  List<String> imageslist = [];
  String selectedValue = "Eğitim Talebi";
  String durum = "";

  int diger = 1;
  final controller = MultiImagePickerController(
      maxImages: 2,
      allowedImageTypes: ['png', 'jpg', 'jpeg'],
      withData: true,
      withReadStream: true,
      images: <ImageFile>[] // array of pre/default selected images
      );
  updatedurum(String postId, String durum) async {
    try {
      await FireStoreMethods().updatedurum(postId, durum, 0);
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40.0),
        child: AppBar(
          title: const Text("Dekont Yükleme Ekranı"),
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
                  child: MultiImagePickerView(
                    controller: controller,
                    padding: const EdgeInsets.all(10),
                  ),
                ),
                ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            const Color.fromARGB(255, 171, 197, 225)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                          ),
                        )),
                    onPressed: () async {
                      final images = controller.images;

                      for (final image in images) {
                        if (image.hasPath) {
                          imageslist.add(image.path!);
                          _fireStoreMethods.updatedekont(
                              widget.uid, imageslist);
                          durum = "Servis Bedeli Ödendi";
                          updatedurum(widget.uid, durum);
                          Navigator.pop(context);
                        } else {
                          print("object");
                        }
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text("Gönder"),
                        SizedBox(
                          width: 5,
                        ),
                        Icon(Icons.send),
                      ],
                    ))
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
      shadowColor: Colors.black87,
      color: Colors.white,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        height: height,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(30))),
        width: MediaQuery.of(context).size.width,
        child: TextField(
          controller: control,
          cursorColor: Colors.white,
          maxLines: maxline,
          maxLength: maxLengh,
          decoration: InputDecoration(
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none),
            hintText: hinttext,
            counterText: '',
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      ),
    );
  }
}
