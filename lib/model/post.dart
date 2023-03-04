import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String description;
  final String uid;
  final String name;
  final String postId;
  final DateTime datePublished;
  final DateTime? finishtime;
  final DateTime? atamaTarih;
  final bool hidden;
  final images;
  final String kategori;
  final String baslik;
  final String durum;
  final String firma;
  final pervedit;
  final int ucret;
  final int sayfa;
  final int dgr;

  const Post({
    required this.description,
    required this.uid,
    required this.name,
    required this.postId,
    required this.datePublished,
    required this.finishtime,
    required this.hidden,
    required this.images,
    required this.kategori,
    required this.baslik,
    required this.durum,
    required this.firma,
    required this.pervedit,
    required this.atamaTarih,
    required this.ucret,
    required this.sayfa,
    required this.dgr,
  });

  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Post(
        description: snapshot["description"],
        uid: snapshot["uid"],
        postId: snapshot["postId"],
        datePublished: snapshot["datePublished"],
        name: snapshot["name"],
        finishtime: snapshot["finishtime"],
        atamaTarih: snapshot["atamaTarih"],
        hidden: snapshot["hidden"],
        kategori: snapshot["kategori"],
        baslik: snapshot["baslik"],
        images: snapshot["images"],
        durum: snapshot["durum"],
        firma: snapshot["firma"],
        pervedit: snapshot["pervedit"],
        ucret: snapshot["ucret"],
        sayfa: snapshot["sayfa"],
        dgr: snapshot["dgr"]);
  }

  Map<String, dynamic> toJson() => {
        "description": description,
        "uid": uid,
        "name": name,
        "postId": postId,
        "datePublished": datePublished,
        "finishtime": finishtime,
        "hidden": hidden,
        "images": images,
        "kategori": kategori,
        "baslik": baslik,
        "durum": durum,
        "pervedit": pervedit,
        "firma": firma,
        "atamaTarih": atamaTarih,
        "ucret": ucret,
        "sayfa": sayfa,
        "dgr": dgr,
      };
}
