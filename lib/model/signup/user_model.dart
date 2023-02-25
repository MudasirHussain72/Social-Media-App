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
    userName = json['UserModelName'] ?? '';
    email = json['email'] ?? '';
    pushToken = json['push_token'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this.uid;
    data['about'] = this.about;
    data['created_at'] = this.createdAt;
    data['profileImage'] = this.profileImage;
    data['last_active'] = this.lastActive;
    data['is_online'] = this.isOnline;
    data['userName'] = this.userName;
    data['email'] = this.email;
    data['push_token'] = this.pushToken;
    return data;
  }
}
