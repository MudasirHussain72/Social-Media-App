import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive_mind/model/services/session_manager.dart';
import 'package:hive_mind/utils/routes/route_name.dart';
import 'package:hive_mind/utils/utils.dart';

class SignUpController with ChangeNotifier {
  FirebaseAuth auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance.collection('users');
  bool _loading = false;
  bool get loading => _loading;
  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void signup(
    BuildContext context,
    String username,
    String email,
    String password,
  ) async {
    setLoading(true);
    try {
      // ignore: unused_local_variable
      final user = await auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) {
        SessionController().userId = value.user!.uid.toString();
        firestore.doc(value.user!.uid.toString()).set({
          'uid': value.user!.uid.toString(),
          'email': value.user!.email.toString(),
          'onlineStatus': 'noOne',
          'userName': username,
          'profileImage': '',
        }).then((value) {
          setLoading(false);
          // Navigator.pushNamed(context, RouteName.dashboardView);
          Navigator.pushNamedAndRemoveUntil(
              context, RouteName.dashboardView, (route) => false);
        }).onError((error, stackTrace) {
          setLoading(false);
          Utils.toastMessage(error.toString());
        });
        Utils.toastMessage("User created successfully");
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
