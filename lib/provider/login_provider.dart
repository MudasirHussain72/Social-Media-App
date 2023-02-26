import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive_mind/services/session_manager.dart';
import 'package:hive_mind/utils/routes/route_name.dart';
import 'package:hive_mind/utils/utils.dart';

class LoginProvider with ChangeNotifier {
   FirebaseAuth auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance.collection('users');
  bool _loading = false;
  bool get loading => _loading;
  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

// email login
  void login(BuildContext context, String email, String password) async {
    setLoading(true);
    try {
     auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) {
        SessionController().userId = value.user!.uid.toString();
        setLoading(false);
        Navigator.pushNamedAndRemoveUntil(
            context, RouteName.dashboardView, (route) => false);
        Utils.toastMessage("User login successfully");
        setLoading(false);
      }).onError((error, stackTrace) {
        setLoading(false);
        Utils.toastMessage(error.toString());
      });
    } catch (e) {
      setLoading(false);
      Utils.toastMessage(e.toString());
    }
  }
}