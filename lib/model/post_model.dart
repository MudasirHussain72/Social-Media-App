import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  String? description;
  String? uid;
  String? userName;
  String? postId;
  var datePublished;
  String? postUrl;
  String? profImage;
  var likes;

  PostModel({
    this.uid,
    this.datePublished,
    this.description,
    this.likes,
    this.postId,
    this.postUrl,
    this.userName,
    this.profImage,
  });

  PostModel.fromJson(Map<String, dynamic> json) {
    uid = json['uid'] ?? '';
    datePublished = json['datePublished'] ?? '';
    description = json['description'] ?? '';
    postId = json['postId'] ?? '';
    likes = json['likes'] ?? '';
    postUrl = json['postUrl'] ?? '';
    userName = json['userName'] ?? '';
    profImage = json['profImage'] ?? '';
  }

  Map<String, dynamic> toJson() {
    // ignore: prefer_collection_literals
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['uid'] = uid;
    data['datePublished'] = datePublished;
    data['description'] = description;
    data['postId'] = postId;
    data['likes'] = likes;
    data['postUrl'] = postUrl;
    data['userName'] = userName;
    data['profImage'] = profImage;
    return data;
  }

  static PostModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return PostModel(
      userName: snapshot['userName'],
      uid: snapshot['uid'],
      profImage: snapshot['profImage'],
      postUrl: snapshot['postUrl'],
      likes: snapshot['likes'],
      postId: snapshot['postId'],
      description: snapshot['description'],
      datePublished: snapshot['datePublished'],
    );
  }
}
