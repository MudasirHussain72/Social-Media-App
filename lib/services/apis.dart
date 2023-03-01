import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive_mind/model/message_model.dart';
import 'package:hive_mind/model/user_model.dart';

class Apis {
  // static User get user=>
  static get user => FirebaseAuth.instance.currentUser!.uid;
  // usefull for getting conversatiomn id
  static String getConvesationId(String id) =>
      // ignore: unnecessary_brace_in_string_interps
      user.hashCode <= id.hashCode ? '${user}_$id' : '${id}_${user}';
// for getting all messages of a speccific conversation from db
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
      UserModel user) {
    return FirebaseFirestore.instance
        .collection('chats/${getConvesationId(user.uid.toString())}/messages/')
        .snapshots();
  }

  // for sending messages
  static Future<void> sendMessage(UserModel chatUser, String msg) async {
    //message sednding time (also used as id)
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    //message to send
    final MessageModel message = MessageModel(
        read: '',
        toId: chatUser.uid.toString(),
        type: Type.text,
        msg: msg,
        sent: time,
        fromId: user);
    final ref = FirebaseFirestore.instance.collection(
        'chats/${getConvesationId(chatUser.uid.toString())}/messages/');
    await ref.doc(time).set(message.toJson());
  }
}
