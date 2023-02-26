import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive_mind/services/session_manager.dart';
import 'package:hive_mind/model/user_model.dart';
import 'package:hive_mind/repository/create_user_repository.dart';
import 'package:hive_mind/utils/routes/route_name.dart';
import 'package:hive_mind/utils/utils.dart';

class UserProvider with ChangeNotifier {
  FirebaseAuth auth = FirebaseAuth.instance;

  List<User> users = [];
  bool _loading = false;
  bool get loading => _loading;
  setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  final CreateUserRepository _userRepository = FirebaseCreateUserRepository();

  void signUpUser(
    BuildContext context,
    String username,
    String email,
    String password,
  ) async {
    setLoading(true);
    try {
      // ignore: unused_local_variable
      auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) {
        UserModel user = UserModel(
          userName: username,
          email: value.user!.email,
          isOnline: true,
          lastActive: DateTime.now().toString(),
          profileImage: '',
          uid: value.user!.uid,
          about: 'Available',
          createdAt: DateTime.now().toString(),
        );
        SessionController().userId = value.user!.uid.toString();
        _userRepository.createUser(user);
        //
        setLoading(false);
        Navigator.pushNamedAndRemoveUntil(
            context, RouteName.dashboardView, (route) => false);
      }).onError((error, stackTrace) {
        setLoading(false);
        Utils.toastMessage(error.toString());
        //
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

  @override
  notifyListeners();
}
