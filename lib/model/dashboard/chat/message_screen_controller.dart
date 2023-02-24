// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive_mind/model/services/session_manager.dart';

class MessageScreenController with ChangeNotifier {
  final db = FirebaseFirestore.instance.collection('messages');
  checkMessageSender(data) {
    if (data == SessionController().userId) {
      return true;
    } else {
      return false;
    }
  }

  var currentUserName;
  var currentUserEmail;
  var currentUserProfileImage;
  Future<void> getuserData() async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(SessionController().userId)
        .get()
        .then((event) {
      // you can access the values by
      currentUserName = event['userName'];
      currentUserEmail = event['email'];
      currentUserProfileImage = event['profileImage'];
    });
  }

  sendMessage(String name, email, image, recieverUid,
      TextEditingController controller) async {
    await getuserData();
    await db.doc("${SessionController().userId}${recieverUid.toString()}").set({
      'recieverName': name,
      'recieverEmail': email,
      'recieverImage': image,
      'chatArray': [SessionController().userId, recieverUid],
      'lastChat': controller.text.trim().toString(),
      'roomId': "${SessionController().userId}${recieverUid.toString()}",
      'senderName': currentUserName,
      'senderEmail': currentUserEmail,
      'senderImage': currentUserProfileImage,
    }).then((value) {
      db
          .doc("${SessionController().userId}${recieverUid.toString()}")
          .collection('chats')
          .add({
        'message': controller.text.trim().toString(),
        'senderUid': SessionController().userId,
        'timestamp': DateTime.now().microsecondsSinceEpoch,
      });
    }).then((value) => {controller.clear()});
  }
}
