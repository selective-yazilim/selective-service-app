import 'package:cloud_firestore/cloud_firestore.dart';

class messageroom {
  final String messageroomuid;
  final List messageroompeaple;
  final bool blocked;
  final String lastmessage;
  final DateTime lastmessagetime;
  final String receivermail;
  final String receiverprofileimage;
  final String receiveruid;
  final String receiverusername;
  final String sendermail;
  final String senderprofileimage;
  final String senderusername;
  final String senderuid;

  const messageroom({
    required this.messageroomuid,
    required this.messageroompeaple,
    required this.blocked,
    required this.lastmessage,
    required this.lastmessagetime,
    required this.receivermail,
    required this.receiverprofileimage,
    required this.receiveruid,
    required this.receiverusername,
    required this.sendermail,
    required this.senderprofileimage,
    required this.senderusername,
    required this.senderuid,
  });

  static messageroom fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return messageroom(
      messageroomuid: snapshot["messageroomuid"],
      messageroompeaple: snapshot["messageroompeaple"],
      blocked: snapshot["blocked"],
      lastmessage: snapshot["lastmessage"],
      lastmessagetime: snapshot["lastmessagetime"],
      receivermail: snapshot["receivermail"],
      receiverprofileimage: snapshot["receiverprofileimage"],
      receiveruid: snapshot['receiveruid'],
      receiverusername: snapshot["receiverusername"],
      sendermail: snapshot["sendermail"],
      senderprofileimage: snapshot["senderprofileimage"],
      senderusername: snapshot["senderusername"],
      senderuid: snapshot["senderuid"],
    );
  }

  Map<String, dynamic> toJson() => {
        "messageroomuid": messageroomuid,
        "messageroompeaple": messageroompeaple,
        "blocked": blocked,
        "lastmessage": lastmessage,
        "lastmessagetime": lastmessagetime,
        "receivermail": receivermail,
        "receiverprofileimage": receiverprofileimage,
        "receiveruid": receiveruid,
        "receiverusername": receiverusername,
        'sendermail': sendermail,
        'senderprofileimage': senderprofileimage,
        'senderusername': senderusername,
        'senderuid': senderuid,
      };
}

class ChatMessage {
  final String id;
  final String message;
  final String messageOwnerMail;
  final String messageOwnerUsername;
  final DateTime timeToSent;

  const ChatMessage({
    required this.id,
    required this.message,
    required this.messageOwnerMail,
    required this.messageOwnerUsername,
    required this.timeToSent,
  });

  static ChatMessage fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return ChatMessage(
      id: snapshot["id"],
      message: snapshot["message"],
      messageOwnerMail: snapshot['messageOwnerMail'],
      messageOwnerUsername: snapshot["messageOwnerUsername"],
      timeToSent: snapshot["timeToSent"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "message": message,
        "messageOwnerMail": messageOwnerMail,
        "messageOwnerUsername": messageOwnerUsername,
        'timeToSent': timeToSent,
      };
}
