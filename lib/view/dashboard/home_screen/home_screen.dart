import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive_mind/services/session_manager.dart';
import 'package:hive_mind/utils/routes/route_name.dart';
import 'package:hive_mind/view/login/login_screen.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(SessionController().userId.toString()),
        actions: [
          IconButton(
              color: Colors.black,
              onPressed: () {
                FirebaseAuth auth = FirebaseAuth.instance;
                auth.signOut().then((value) {
                  SessionController().userId = '';
                  PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
                    context,
                    settings: const RouteSettings(name: RouteName.loginView),
                    screen: const LoginScreen(),
                    withNavBar: false,
                    pageTransitionAnimation: PageTransitionAnimation.cupertino,
                  );
                });
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: const Center(child: Text('Home screen')),
    );
  }
}
