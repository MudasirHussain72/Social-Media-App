import 'package:flutter/material.dart';
import 'package:hive_mind/model/services/splash_services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SplashServices services = SplashServices();
  @override
  void initState() {
    super.initState();
    services.isLogin(context);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size * 1;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Center(
              child: Image(
        image: const AssetImage('assets/images/logo.png'),
        width: size.width / 2,
      ))),
    );
  }
}
