import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hive_mind/model/user_model.dart';
import 'package:hive_mind/resources/color.dart';
import 'package:hive_mind/view/dashboard/chat/chat_screen.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class UserCard extends StatefulWidget {
  final UserModel user;

  const UserCard({super.key, required this.user});

  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () {
          PersistentNavBarNavigator.pushNewScreen(
            context,
            screen: ChatScreen(user: widget.user),
            withNavBar: false,
          );
        },
        leading: Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primaryIconColor)),
            child: widget.user.profileImage == ''
                ? const Icon(Icons.person_outline)
                : ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(50)),
                    child: CachedNetworkImage(
                      imageUrl: widget.user.profileImage.toString(),
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.person),
                    ),
                  )),
        title: Text(
          widget.user.userName.toString(),
        ),
        subtitle: Text(widget.user.email.toString()),
      ),
    );
  }
}
