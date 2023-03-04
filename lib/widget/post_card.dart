import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:selective/utils/utils.dart';
import 'package:selective/widget/cards_model.dart';

class PostCard extends StatefulWidget {
  final snap;
  final sayfa;
  const PostCard({Key? key, required this.snap, required this.sayfa})
      : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
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
          .doc(
            FirebaseAuth.instance.currentUser!.uid,
          )
          .get();
      userData = userSnap.data()!;
      yetki = userSnap.data()!['yetki'];

      isLoading = false;
      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return !isLoading
        ? card_model(context, widget.snap, yetki, widget.sayfa)
        : const Center(
            child: CircularProgressIndicator(),
          );
  }
}
