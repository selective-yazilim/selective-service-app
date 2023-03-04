import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:selective/notifications/notif.dart';
import 'package:selective/services/firestore_methods.dart';
import 'package:selective/utils/color.dart';
import 'package:selective/utils/text.dart';
import 'package:selective/widget/post_comment_card.dart';

import '../../../utils/utils.dart';

class CommentsScreen extends StatefulWidget {
  final postId;
  const CommentsScreen({Key? key, required this.postId}) : super(key: key);

  @override
  _CommentsScreenState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final TextEditingController commentEditingController =
      TextEditingController();
  var userData = {};
  bool isLoading = false;

  getdata() async {
    isLoading = false;
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      userData = userSnap.data()!;
      isLoading = true;
    } catch (e) {
      print(e);
    }

    // setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getdata();
  }

  void postComment(
    String uid,
    String name,
  ) async {
    try {
      String res = await FireStoreMethods().postComment(
        widget.postId,
        commentEditingController.text,
        uid,
        name,
      );

      if (res == 'success') {
        String durum = name + aciklamaeklendi + commentEditingController.text;
        notifpush().dataget(widget.postId, 0, durum);
        notifpush().getselective(widget.postId, durum);
      }
      setState(() {
        commentEditingController.text = "";
      });
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
      appBar: AppBar(
        backgroundColor: colors().mainColor,
        title: Text(
          EkAciklama,
        ),
        centerTitle: false,
      ),
      body: !isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('posts')
                  .doc(widget.postId)
                  .collection('comments')
                  .snapshots(),
              builder: (context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (ctx, index) => postCommentcard(
                    snap: snapshot.data!.docs[index],
                  ),
                );
              },
            ),
      // text input
      bottomNavigationBar: SafeArea(
        child: Container(
          height: kToolbarHeight,
          margin:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          padding: const EdgeInsets.only(left: 16, right: 8),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child: TextField(
                    autofocus: true,
                    controller: commentEditingController,
                    decoration: InputDecoration(
                      hintText:
                          'Açıklama ekleyin ${userData['username'].toString()}',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () => postComment(
                  userData['uid'].toString(),
                  userData['username'].toString(),
                ),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  child: Text(
                    Ekle,
                    style: TextStyle(color: colors().blue),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
