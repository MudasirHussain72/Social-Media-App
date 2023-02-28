import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive_mind/model/user_model.dart';
import 'package:hive_mind/services/session_manager.dart';

class CurrentUserProvider with ChangeNotifier {
  Future<UserModel> getUserDetails() async {
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(SessionController().userId)
        .get();
    return UserModel.fromSnap(snap);
  }

  UserModel? _user;
  UserModel get getUser => _user!;
  Future<void> refreshUser() async {
    UserModel user = await getUserDetails();
    _user = user;
    notifyListeners();
  }
}
