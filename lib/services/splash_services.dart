import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive_mind/services/session_manager.dart';
import 'package:hive_mind/utils/routes/route_name.dart';

class SplashServices {
  void isLogin(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    if (user != null) {
      SessionController().userId = user.uid.toString();
      Timer(
          const Duration(seconds: 2),
          // () => Navigator.pushReplacementNamed(context, RouteName.dashboardView),
          () => Navigator.pushNamedAndRemoveUntil(
              context, RouteName.dashboardView, (route) => false));
    } else {
      Timer(
          const Duration(seconds: 2),
          // () => Navigator.pushReplacementNamed(context, RouteName.loginView),
          () => Navigator.pushNamedAndRemoveUntil(
              context, RouteName.loginView, (route) => false));
    }
  }
}