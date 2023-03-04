import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:selective/utils/text.dart';
import 'package:selective/widget/post_card.dart';
import 'package:selective/widget/post_comment_card.dart';

class detail_screen extends StatefulWidget {
  final postid;
  const detail_screen({super.key, required this.postid});

  @override
  State<detail_screen> createState() => _detail_screenState();
}

class _detail_screenState extends State<detail_screen> {
  var userData = {};
  var postData = {};
  bool isLoading = false;

  // ignore: prefer_typing_uninitialized_variables
  var postSnap;
  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.postid)
          .get();

      userData = userSnap.data()!;

      setState(() {});
    } catch (e) {
      print(e);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return !isLoading
        ? Scaffold(
            appBar: AppBar(),
            body: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('posts')
                  .where("postId", isEqualTo: widget.postid)
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
                  itemBuilder: (ctx, index) => Container(
                      child: Column(
                    children: [
                      PostCard(
                        sayfa: 1,
                        snap: snapshot.data!.docs[index].data(),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            EkAciklama,
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Container(
                        height: 400,
                        child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('posts')
                              .doc(widget.postid)
                              .collection('comments')
                              .snapshots(),
                          builder: (context,
                              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                                  snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
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
                      ),
                    ],
                  )),
                );
              },
            ),
          )
        : const Center(
            child: CircularProgressIndicator(),
          );
  }
}
