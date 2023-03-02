// ignore_for_file: empty_catches, prefer_typing_uninitialized_variables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive_mind/resources/color.dart';
import 'package:hive_mind/services/session_manager.dart';
import 'package:intl/intl.dart';

class PostCard extends StatelessWidget {
  final snap;
  const PostCard({super.key, required this.snap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(children: [
        //image section
        Container(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10)
              .copyWith(right: 0),
          child: Row(children: [
            CircleAvatar(
              radius: 16,
              backgroundImage: NetworkImage(
                snap['profImage'],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      snap['userName'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ),
            IconButton(onPressed: () {}, icon: const Icon(Icons.more_horiz))
          ]),
        ),
        //image section
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 40)
              .copyWith(right: 0),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                image: DecorationImage(
                  image: NetworkImage(
                    snap['postUrl'].toString(),
                  ),
                  fit: BoxFit.cover,
                )),
            height: MediaQuery.of(context).size.height * 0.35,
            width: double.infinity,
            // child: Image.network(
            //   snap['postUrl'],
            //   fit: BoxFit.cover,
            // ),
          ),
        ),
        //like comment section
        Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: 30).copyWith(right: 0),
          child: Row(
            children: [
              IconButton(
                  onPressed: () {
                    likePost(snap['postId'],
                        SessionController().userId.toString(), snap['likes']);
                  },
                  icon: snap['likes'].contains(SessionController().userId)
                      ? const Icon(
                          Icons.favorite,
                          color: Colors.red,
                        )
                      : const Icon(Icons.favorite_outline)),
              IconButton(
                  onPressed: () {}, icon: const Icon(Icons.comment_outlined)),
              IconButton(
                  onPressed: () {}, icon: const Icon(Icons.send_rounded)),
              Expanded(
                  child: Align(
                alignment: Alignment.bottomRight,
                child: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.bookmark_border_rounded)),
              )),
            ],
          ),
        ),
        //description & number of comments
        Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 40).copyWith(right: 0),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${snap['likes'].length} Likes',
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 8),
                  child: RichText(
                    text: TextSpan(
                        style: const TextStyle(
                            color: AppColors.primaryTextTextColor),
                        children: [
                          TextSpan(
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            text: '${snap['userName']} : ',
                          ),
                          TextSpan(
                            style: Theme.of(context).textTheme.caption,
                            text: ' ${snap['description']}',
                          )
                        ]),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 4)
                      .copyWith(bottom: 0),
                  child: Text(
                    DateFormat.yMMMd().format(snap['datePublished'].toDate()),
                    style: const TextStyle(
                        fontSize: 16, color: AppColors.secondaryColor),
                  ),
                )
              ]),
        )
      ]),
    );
  }

  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await FirebaseFirestore.instance
            .collection('posts')
            .doc(postId)
            .update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        await FirebaseFirestore.instance
            .collection('posts')
            .doc(postId)
            .update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
    } catch (e) {}
  }
}
