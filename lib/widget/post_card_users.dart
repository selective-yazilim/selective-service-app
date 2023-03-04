import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:selective/utils/utils.dart';
import 'package:selective/widget/cards_model.dart';
import 'package:selective/widget/cards_model_users.dart';

class PostCard_user extends StatefulWidget {
  final snap;
  final sayfa;
  const PostCard_user({Key? key, required this.snap, required this.sayfa})
      : super(key: key);

  @override
  State<PostCard_user> createState() => _PostCard_userState();
}

class _PostCard_userState extends State<PostCard_user> {
  void initState() {
    super.initState();
    getData();
  }

  var userData = {};
  var yetki = 0;
  bool isLoading = false;
  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.snap["uid"])
          .get();

      userData = userSnap.data()!;

      yetki = userSnap.data()!['yetki'];
      print("yetki");
      isLoading = false;
      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return !isLoading
        ? card_model_users(context, widget.snap, yetki, widget.sayfa)
        : Center(
            child: CircularProgressIndicator(),
          );
  }
}
