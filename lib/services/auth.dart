import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class authservices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseStorage storage = FirebaseStorage.instance;

  Future<String?> giris(String email, String password) async {
    String res = "Some error Occurred";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        String? userid;
        var usersnap = await _firestore
            .collection('users')
            .where("username", isEqualTo: email)
            .get()
            .then(
              (QuerySnapshot snapshot) => {
                snapshot.docs.forEach((f) {
                  userid = f.reference.id;
                }),
              },
            );

        var users = await _firestore.collection('users').doc(userid).get();

        if (users.data()!["durum"] != "Pasif") {
          var user = await _auth.signInWithEmailAndPassword(
              email: users.data()!["email"], password: password);
          final status = await OneSignal.shared.getDeviceState();
          final String? osUserID = status?.userId;
          FirebaseFirestore.instance
              .collection('users')
              .doc(
                userid,
              )
              .update({"OneSignalid": osUserID});
          print(osUserID);
          res = "Success";
        } else {
          res = "Hesabınız Dondurulmuştur...";
        }
      } else {
        res = "Lütfen Tüm Alanları Doldurunuz";
      }
    } catch (err) {
      return res = "Kullanıcı Adı ve Şifrenizi Kontrol Ediniz";
    }

    return res;
  }

  Future<String> signUpUser({
    required String firma,
    required String username,
    required String gorev,
    required String email,
    required String password,
    required String telefon,
    required int yetki,
  }) async {
    String res = "Some error Occurred";
    try {
      // registering user in auth with email and password
      //UserCredential cred = await _auth.createUserWithEmailAndPassword(
      //  email: email,
      //  password: password,
      //);
      FirebaseApp tempApp = await Firebase.initializeApp(
          name: 'Selective', options: Firebase.app().options);
      UserCredential userCredential =
          await FirebaseAuth.instanceFor(app: tempApp)
              .createUserWithEmailAndPassword(email: email, password: password);
      Map<String, dynamic> _user = {
        'sUID': userCredential.user!.uid,
        'sName': username,
        'sEmail': email,
      };
      // adding user in our database
      await _firestore.collection("users").doc(userCredential.user!.uid).set({
        "firma": firma,
        "username": username,
        "gorev": gorev,
        "email": email,
        "password": password,
        "telefon": telefon,
        "yetki": yetki,
        "uid": userCredential.user!.uid,
        "durum": "Aktif",
      });

      res = "success";
    } catch (err) {
      return err.toString();
    }
    return res;
  }

  Future<String> updateuser({
    required String firma,
    required String username,
    required String gorev,
    required String email,
    required String password,
    required String telefon,
    required int yetki,
    required String uid,
  }) async {
    String res = "Some error Occurred";
    try {
      // registering user in auth with email and password
      //UserCredential cred = await _auth.createUserWithEmailAndPassword(
      //  email: email,
      //  password: password,
      //);
      //  FirebaseApp tempApp = await Firebase.initializeApp(
      //     name: 'Selective', options: Firebase.app().options);
      //  UserCredential userCredential =
      //      await FirebaseAuth.instanceFor(app: tempApp)
      //         .createUserWithEmailAndPassword(email: email, password: password);
      //  Map<String, dynamic> _user = {
      //    'sUID': userCredential.user!.uid,
      //  'sName': username,
      //   'sEmail': email,
      // };
      // adding user in our database
      await _firestore.collection("users").doc(uid).update({
        "firma": firma,
        "username": username,
        "gorev": gorev,
        "email": email,
        "password": password,
        "telefon": telefon,
        "yetki": yetki,
      });

      res = "success";
    } catch (err) {
      return err.toString();
    }
    return res;
  }

  Future<String?> changePassword(String oldPassword, String newPassword) async {
    User user = FirebaseAuth.instance.currentUser!;
    AuthCredential credential =
        EmailAuthProvider.credential(email: user.email!, password: oldPassword);

    Map<String, String?> codeResponses = {
      // Re-auth responses
      "user-mismatch": null,
      "user-not-found": null,
      "invalid-credential": null,
      "invalid-email": null,
      "wrong-password": null,
      "invalid-verification-code": null,
      "invalid-verification-id": null,
      // Update password error codes
      "weak-password": null,
      "requires-recent-login": null
    };

    try {
      await user.reauthenticateWithCredential(credential);
      await user.updatePassword(newPassword);
      return null;
    } on FirebaseAuthException catch (error) {
      return codeResponses[error.code] ?? "Unknown";
    }
  }
}
