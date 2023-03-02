import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_mind/model/message_model.dart';
import 'package:hive_mind/model/user_model.dart';
import 'package:hive_mind/resources/color.dart';
import 'package:hive_mind/services/apis.dart';
import 'package:hive_mind/services/session_manager.dart';
import 'package:hive_mind/utils/utils.dart';

class ChatScreen extends StatefulWidget {
  final UserModel user;
  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<MessageModel> list = [];
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
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Scaffold(
        appBar: AppBar(
          systemOverlayStyle:
              SystemUiOverlayStyle(statusBarColor: Colors.white),
          automaticallyImplyLeading: false,
          flexibleSpace: _appBar(),
        ),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: StreamBuilder(
                  stream: Apis.getAllMessages(widget.user),
                  builder: (BuildContext context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                      case ConnectionState.none:
                      // return const Center(child: CircularProgressIndicator());
                      case ConnectionState.active:
                      case ConnectionState.done:
                        final data = snapshot.data?.docs;
                        list = data
                                ?.map((e) => MessageModel.fromJson(e.data()))
                                .toList() ??
                            [];
                        if (list.isNotEmpty) {
                          return ListView.builder(
                            itemCount: list.length,
                            itemBuilder: (context, index) {
                              return BubbleSpecialThree(
                                text: list[index].msg.toString(),
                                color: const Color(0xFFE8E8EE),
                                tail: false,
                                isSender:
                                    checkMessageSender(list[index].fromId),
                              );
                            },
                          );
                        } else {
                          return const Center(child: Text('Say Hi! 👋'));
                        }
                    }
                  },
                ),
              ),
              Row(
                children: [
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: messageController,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2!
                          .copyWith(fontSize: 19),
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        suffixIcon: Padding(
                          padding: const EdgeInsets.only(right: 15),
                          child: InkWell(
                            onTap: () {
                              if (messageController.text.isEmpty) {
                                Utils.toastMessage('Message can not be empty');
                              } else {
                                Apis.sendMessage(
                                    widget.user, messageController.text.trim());
                                messageController.text = '';
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

  checkMessageSender(data) {
    if (data == SessionController().userId) {
      return true;
    } else {
      return false;
    }
  }

  Widget _appBar() {
    return InkWell(
      onTap: () {},
      child: Row(
        children: [
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: AppColors.secondaryColor,
              )),
          Container(
            height: 40,
            width: 40,
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(50)),
              child: CachedNetworkImage(
                imageUrl: widget.user.profileImage.toString(),
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.person),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(widget.user.userName.toString()),
              const Text('Last seen not available')
            ],
          )
        ],
      ),
    );
  }
}
