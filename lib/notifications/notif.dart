import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:selective/services/firestore_methods.dart';

class notifpush {
  void dataget(String Postid, int control, String aciklama) async {
    List<String> userlist = [];
    List<String> yuid = [];
    String tmp;
    var postsnap =
        await FirebaseFirestore.instance.collection('posts').doc(Postid).get();

    var postuseruid = postsnap.data()!['uid'];
    var control = await FirebaseFirestore.instance
        .collection("users")
        .doc(postuseruid)
        .get();
    if (control.data()!["yetki"] == 1) {
      userlist.clear();
      userlist.add(control.data()!["OneSignalid"]);
      push(userlist, aciklama);
    } else if (control.data()!["yetki"] == 0) {
      userlist.clear();
      var getyetkili = await FirebaseFirestore.instance
          .collection("users")
          .where("firma", isEqualTo: control.data()!["firma"])
          .where("yetki", isEqualTo: 1)
          .get()
          .then(
            (QuerySnapshot snapshot) => {
              snapshot.docs.forEach((f) {
                yuid.add(f.reference.id);
              }),
            },
          );
      if (control == 0) {
        for (var i = 0; i < yuid.length; i++) {
          var getsignaluid = await FirebaseFirestore.instance
              .collection("users")
              .doc(yuid[i])
              .get();
          tmp = getsignaluid.data()!["OneSignalid"];
          userlist.add(tmp);
        }
      }

      push(userlist, aciklama);
    }
  }

  void getselective(String postid, String aciklama) async {
    List<String> yuid = [];
    List<String> userlist = [];
    var postsnap =
        await FirebaseFirestore.instance.collection('posts').doc(postid).get();
    var getyetkili = await FirebaseFirestore.instance
        .collection("users")
        .where("yetki", isEqualTo: 3)
        .get()
        .then(
          (QuerySnapshot snapshot) => {
            snapshot.docs.forEach((f) {
              yuid.add(f.reference.id);
            }),
          },
        );
    for (var i = 0; i < yuid.length; i++) {
      var getsignaluid = await FirebaseFirestore.instance
          .collection("users")
          .doc(yuid[i])
          .get();
      String tmp = getsignaluid.data()!["OneSignalid"];
      userlist.add(tmp);
    }
    String acik = postsnap.data()!['firma'] + " -  " + aciklama;
    push(userlist, acik);
  }

  void goselective(String postid, String aciklama) async {
    List<String> yuid = [];
    List<String> userlist = [];
    var postsnap =
        await FirebaseFirestore.instance.collection('posts').doc(postid).get();

    var getsignaluid = await FirebaseFirestore.instance
        .collection("users")
        .doc(postsnap.data()!["Scalisanid"])
        .get();
    String tmp = getsignaluid.data()!["OneSignalid"];
    userlist.add(tmp);

    String acik = postsnap.data()!['firma'] + " -  " + aciklama;
    push(userlist, acik);
  }

  void push(List<String> playerid, String? aciklama) async {
    var status = await OneSignal.shared.getDeviceState();
    try {
      await OneSignal.shared.postNotification(OSCreateNotification(
        playerIds: playerid,
        content: aciklama,
        heading: "Selective",
        sendAfter: DateTime.now().toUtc(),
      ));
      print(status!.userId);
    } catch (e) {print(e);}
  }
}
