import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:selective/model/message.dart';
import 'package:selective/model/post.dart';
import 'package:selective/notifications/notif.dart';
import 'package:selective/services/storage_methods.dart';

import 'package:uuid/uuid.dart';

class FireStoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _firebaseStorage = FirebaseStorage.instance;

  Future<String> uploadPost(
      String description,
      String uid,
      String username,
      List images,
      String baslik,
      String kategori,
      String firma,
      String Durum,
      int dgr) async {
    // asking uid here because we dont want to make extra calls to firebase auth when we can just get from our state management
    String res = "Some error occurred";
    List<String> photoUrl = [];

    try {
      String postId = const Uuid().v1(); // creates unique id based on time
      print("fordan önce");
      for (var i = 0; i < images.length; i++) {
        print(i);
        String imageid = const Uuid().v1();
        var imageFile = File(images[i]);
        String fileName = imageid;
        FirebaseStorage storage = FirebaseStorage.instance;
        Reference ref =
            storage.ref().child("Post").child("$firma -" + fileName);
        UploadTask uploadTask = ref.putFile(imageFile);
        print(images[i]);
        print("upload kısmında önce");
        await uploadTask.whenComplete(() async {
          var url = await ref.getDownloadURL();
          photoUrl.add(url.toString());
        }).catchError((onError) {
          print(onError);
        });
      }
      print("fordan çıktı");
      Post post = Post(
          description: description,
          uid: uid,
          name: username,
          postId: postId,
          hidden: false,
          datePublished: DateTime.now(),
          finishtime: null,
          atamaTarih: null,
          images: photoUrl,
          baslik: baslik,
          kategori: kategori,
          durum: Durum,
          pervedit: [],
          firma: firma,
          ucret: 0,
          sayfa: 0,
          dgr: Durum == "Firma Onay Bekliyor" ? 0 : 1);
      _firestore.collection('posts').doc(postId).set(post.toJson());
      res = "success";
      String durum1 = "Talep gönderdi";
      String durum = "Talep gönderildi";
      notifpush().dataget(postId, 0, durum);
      notifpush().getselective(postId, durum1);
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> updatepost(
      String description,
      String uid,
      String postId,
      String username,
      List images,
      String baslik,
      String kategori,
      String pervdescription,
      String pervusername,
      String pervbaslik,
      String pervkategori,
      String pervdate,
      String firma) async {
    // asking uid here because we dont want to make extra calls to firebase auth when we can just get from our state management
    String res = "Some error occurred";
    List<String> photoUrl = [];

    try {
      // creates unique id based on time

      _firestore.collection('posts').doc(postId).update({
        "description": description,
        "name": username,
        "datePublished": DateTime.now(),
        "baslik": baslik,
        "kategori": kategori,
        "pervedit": [
          {
            "description": pervdescription,
            "uid": uid,
            "name": pervusername,
            "postId": postId,
            "hidden": false,
            "datePublished": pervdate,
            "finishtime": null,
            "baslik": pervbaslik,
            "kategori": pervkategori,
            "durum": "Onay Bekliyor",
          }
        ]
      });
      String durum1 = firma + "  -  " + username + "  :  Talep Güncelledi";
      String durum = "Talep Güncellendi";
      notifpush().dataget(postId, 0, durum);
      notifpush().getselective(postId, durum1);
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Delete Post
  Future<String> deletePost(String postId) async {
    String res = "Some error occurred";
    try {
      await _firestore.collection('posts').doc(postId).delete();
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> updatedurum(String postId, String durum, int sayfa) async {
    String res = "Some error occurred";
    try {
      if (durum == "İşlem Tamamlandı") {
        await _firestore.collection('posts').doc(postId).update(
            {"durum": durum, "sayfa": sayfa, "finishtime": DateTime.now()});
      } else {
        await _firestore
            .collection('posts')
            .doc(postId)
            .update({"durum": durum, "sayfa": sayfa});
      }

      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> updatedurums(
      String postId, String durum, int sayfa, int dgr) async {
    String res = "Some error occurred";
    try {
      await _firestore
          .collection('posts')
          .doc(postId)
          .update({"durum": durum, "sayfa": sayfa, "dgr": 1});
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> updateuserdurum(String uid, String udurum) async {
    String res = "Some error occurred";
    try {
      await _firestore.collection('users').doc(uid).update({"durum": udurum});
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> updatefirmadurum(
      String uid, String udurum, String firma) async {
    String res = "Some error occurred";
    try {
      List users = [];
      var usersnap = await _firestore
          .collection('users')
          .where("firma", isEqualTo: firma)
          .get()
          .then(
            (QuerySnapshot snapshot) => {
              snapshot.docs.forEach((f) {
                users.add(f.reference.id);
              }),
            },
          );
      for (var i = 0; i < users.length; i++) {
        await _firestore
            .collection('users')
            .doc(users[i])
            .update({"durum": udurum});
      }
      await _firestore.collection('firma').doc(uid).update({"durum": udurum});

      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> updatemoney(String postId, String para) async {
    String res = "Some error occurred";
    try {
      await _firestore.collection('posts').doc(postId).update({"para": para});
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> updatedekont(String postId, List images) async {
    String res = "Some error occurred";
    List<String> photoUrl = [];
    try {
      for (var i = 0; i < images.length; i++) {
        print(i);
        String imageid = const Uuid().v1();
        var imageFile = File(images[i]);
        String fileName = imageid;
        FirebaseStorage storage = FirebaseStorage.instance;
        Reference ref =
            storage.ref().child("Dekont").child("Dekont -" + fileName);
        UploadTask uploadTask = ref.putFile(imageFile);
        print(images[i]);
        print("upload kısmında önce");
        await uploadTask.whenComplete(() async {
          var url = await ref.getDownloadURL();
          photoUrl.add(url.toString());
        }).catchError((onError) {
          print(onError);
        });
      }
      await _firestore
          .collection('posts')
          .doc(postId)
          .update({"dekont": photoUrl});
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> islemata(String postId, String durum, String isim, int sayfa,
      String oncelik) async {
    String res = "Some error occurred";
    String? uid;
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .where("username", isEqualTo: isim)
          .get()
          .then(
            (QuerySnapshot snapshot) => {
              snapshot.docs.forEach((f) {
                uid = f.reference.id;
              }),
            },
          );
    } catch (e) {
      print(e);
    }
    try {
      await _firestore.collection('posts').doc(postId).update({
        "durum": durum,
        "Scalisan": isim,
        "Scalisanid": uid,
        "Satayanid": FirebaseAuth.instance.currentUser!.uid,
        "atamaTarih": DateTime.now(),
        "sayfa": sayfa,
        "oncelik": oncelik
      });
      String Durumatama = "Size İşlem Atandı";
      notifpush().goselective(postId, Durumatama);
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> postComment(
    String postId,
    String text,
    String uid,
    String name,
  ) async {
    String res = "Some error occurred";
    try {
      if (text.isNotEmpty) {
        // if the likes list contains the user uid, we need to remove it
        String commentId = const Uuid().v1();
        _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'username': name,
          'uid': uid,
          "postId": postId,
          // "replyto": replyto,
          'description': text,
          'commentId': commentId,
          'datePublished': DateTime.now(),
        });
        res = 'success';
      } else {
        res = "Please enter text";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> firma_add(
    String firma_name,
    String firma_email,
    String firma_tel,
  ) async {
    String res = "Some error occurred";
    try {
      String firmaid = const Uuid().v1();
      _firestore.collection('firma').doc(firmaid).set({
        'firma_name': firma_name,
        'firma_uid': firmaid,
        "firma_email": firma_email,
        'firma_tel': firma_tel,
        'datePublished': DateTime.now(),
        "durum": "Aktif",
      });
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> firma_update(String firma_name, String firma_email,
      String firma_tel, String firmaid) async {
    String res = "Some error occurred";
    try {
      List users = [];
      var firmasnap = await _firestore.collection("firma").doc(firmaid).get();
      var usersnap = await _firestore
          .collection('users')
          .where("firma", isEqualTo: firmasnap.data()!["firma_name"])
          .get()
          .then(
            (QuerySnapshot snapshot) => {
              snapshot.docs.forEach((f) {
                users.add(f.reference.id);
              }),
            },
          );
      for (var i = 0; i < users.length; i++) {
        await _firestore
            .collection('users')
            .doc(users[i])
            .update({"firma": firma_name});
      }
      _firestore.collection('firma').doc(firmaid).update({
        'firma_name': firma_name,
        "firma_email": firma_email,
        'firma_tel': firma_tel,
      });
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
