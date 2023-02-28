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
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(children: [
        //image section
        Container(
          padding: EdgeInsets.symmetric(vertical: 4, horizontal: 16)
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
                padding: EdgeInsets.only(left: 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      snap['userName'],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ),
            IconButton(onPressed: () {}, icon: Icon(Icons.more_horiz))
          ]),
        ),
        //image section
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.35,
          width: double.infinity,
          child: Image.network(
            snap['postUrl'],
            fit: BoxFit.cover,
          ),
        ),
        //like comment section
        Row(
          children: [
            IconButton(
                onPressed: () {
                  likePost(snap['postId'],
                      SessionController().userId.toString(), snap['likes']);
                },
                icon: snap['likes'].contains(SessionController().userId)
                    ? Icon(
                        Icons.favorite,
                        color: Colors.red,
                      )
                    : Icon(Icons.favorite_outline)),
            IconButton(onPressed: () {}, icon: Icon(Icons.comment_outlined)),
            IconButton(onPressed: () {}, icon: Icon(Icons.send_rounded)),
            Expanded(
                child: Align(
              alignment: Alignment.bottomRight,
              child: IconButton(
                  onPressed: () {}, icon: Icon(Icons.bookmark_border_rounded)),
            )),
          ],
        ),
        //description & number of comments
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${snap['likes'].length} Likes',
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(top: 8),
                  child: RichText(
                    text: TextSpan(
                        style: TextStyle(color: AppColors.primaryColor),
                        children: [
                          TextSpan(
                            style: TextStyle(fontWeight: FontWeight.bold),
                            text: snap['userName'],
                          ),
                          TextSpan(
                            style: TextStyle(fontWeight: FontWeight.bold),
                            text: ' ${snap['description']}',
                          )
                        ]),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    DateFormat.yMMMd().format(snap['datePublished'].toDate()),
                    style: TextStyle(
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
