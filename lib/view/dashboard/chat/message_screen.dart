import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive_mind/model/dashboard/chat/message_screen_controller.dart';
import 'package:hive_mind/model/services/session_manager.dart';
import 'package:hive_mind/res/color.dart';
import 'package:hive_mind/utils/utils.dart';

// ignore: must_be_immutable
class MessageScreen extends StatefulWidget {
  String name, email, image, recieverUid;
  MessageScreen({
    super.key,
    required this.name,
    required this.recieverUid,
    required this.email,
    required this.image,
  });

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final messageController = TextEditingController();

  final messageFocusNode = FocusNode();

  @override
  void dispose() {
    messageController.dispose();
    messageFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
        leading: GestureDetector(
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              StreamBuilder<QuerySnapshot>(
                stream: MessageScreenController()
                    .db
                    .doc(
                        "${SessionController().userId}${widget.recieverUid.toString()}")
                    .collection('chats')
                    .orderBy('timestamp')
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text("Loading");
                  }

                  return snapshot.hasData
                      ? Expanded(
                          child: ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              return BubbleSpecialThree(
                                text: snapshot.data!.docs[index]['message'],
                                color: Color(0xFFE8E8EE),
                                tail: false,
                                isSender: MessageScreenController()
                                    .checkMessageSender(snapshot
                                        .data!.docs[index]['senderUid']),
                              );
                            },
                          ),
                        )
                      : Container();
                },
              ),
              Row(
                children: [
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: messageController,
                      focusNode: messageFocusNode,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2!
                          .copyWith(fontSize: 19),
                      decoration: InputDecoration(
                        suffixIcon: Padding(
                          padding: const EdgeInsets.only(right: 15),
                          child: InkWell(
                            onTap: () {
                              if (messageController.text.isEmpty) {
                                Utils.toastMessage('Message can not be empty');
                              } else {
                                MessageScreenController().sendMessage(
                                    widget.name,
                                    widget.email,
                                    widget.image,
                                    widget.recieverUid,
                                    messageController);
                              }
                            },
                            child: const CircleAvatar(
                              backgroundColor: AppColors.secondaryColor,
                              child: Icon(
                                Icons.send,
                                color: AppColors.whiteColor,
                              ),
                            ),
                          ),
                        ),
                        hintText: 'Message',
                        // enabled: enable,
                        contentPadding: const EdgeInsets.all(15),
                        hintStyle: Theme.of(context)
                            .textTheme
                            .bodyText2!
                            .copyWith(color: AppColors.primaryTextTextColor),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(
                              color: AppColors.textFieldDefaultFocus),
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                              color: AppColors.textFieldDefaultFocus),
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                        ),
                        errorBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.alertColor),
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                              color: AppColors.textFieldDefaultBorderColor),
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                        ),
                      ),
                    ),
                  )),
                ],
              )
            ]),
      ),
    );
  }
}
