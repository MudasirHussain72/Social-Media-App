import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? uid;
  String? about;
  String? createdAt;
  String? profileImage;
  String? lastActive;
  bool? isOnline;
  String? userName;
  String? email;
  String? pushToken;

  UserModel(
      {this.uid,
      this.about,
      this.createdAt,
      this.profileImage,
      this.lastActive,
      this.isOnline,
      this.userName,
      this.email,
      this.pushToken});

  UserModel.fromJson(Map<String, dynamic> json) {
    uid = json['uid'] ?? '';
    about = json['about'] ?? '';
    createdAt = json['created_at'] ?? '';
    profileImage = json['profileImage'] ?? '';
    lastActive = json['last_active'] ?? '';
    isOnline = json['is_online'] ?? '';
    userName = json['userName'] ?? '';
    email = json['email'] ?? '';
    pushToken = json['push_token'] ?? '';
  }

  Map<String, dynamic> toJson() {
    // ignore: prefer_collection_literals
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['uid'] = uid;
    data['about'] = about;
    data['created_at'] = createdAt;
    data['profileImage'] = profileImage;
    data['last_active'] = lastActive;
    data['is_online'] = isOnline;
    data['userName'] = userName;
    data['email'] = email;
    data['push_token'] = pushToken;
    return data;
  }

  static UserModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return UserModel(
      userName: snapshot['userName'],
      about: snapshot['about'],
      createdAt: snapshot['created_at'],
      email: snapshot['email'],
      isOnline: snapshot['is_online'],
      lastActive: snapshot['last_active'],
      profileImage: snapshot['profileImage'],
      pushToken: snapshot['push_token'],
      uid: snapshot['uid'],
    );
  }
}
