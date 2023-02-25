import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_mind/firebase_options.dart';
import 'package:hive_mind/resources/color.dart';
import 'package:hive_mind/resources/fonts.dart';
import 'package:hive_mind/utils/routes/route_name.dart';
import 'package:hive_mind/utils/routes/routes.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light));
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      title: 'HiveMind',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: AppColors.primaryMaterialColor,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
            color: AppColors.whiteColor,
            centerTitle: true,
            titleTextStyle: TextStyle(
                fontSize: 22,
                fontFamily: AppFonts.sfProDisplayMedium,
                color: AppColors.primaryTextTextColor)),
        textTheme: const TextTheme(
          headline1: TextStyle(
              fontSize: 40,
              fontFamily: AppFonts.sfProDisplayMedium,
              color: AppColors.primaryTextTextColor,
              fontWeight: FontWeight.w500,
              height: 1.6),
          headline2: TextStyle(
              fontSize: 32,
              fontFamily: AppFonts.sfProDisplayMedium,
              color: AppColors.primaryTextTextColor,
              fontWeight: FontWeight.w500,
              height: 1.6),
          headline3: TextStyle(
              fontSize: 28,
              fontFamily: AppFonts.sfProDisplayMedium,
              color: AppColors.primaryTextTextColor,
              fontWeight: FontWeight.w500,
              height: 1.9),
          headline4: TextStyle(
              fontSize: 24,
              fontFamily: AppFonts.sfProDisplayMedium,
              color: AppColors.primaryTextTextColor,
              fontWeight: FontWeight.w500,
              height: 1.6),
          headline5: TextStyle(
              fontSize: 20,
              fontFamily: AppFonts.sfProDisplayMedium,
              color: AppColors.primaryTextTextColor,
              fontWeight: FontWeight.w500,
              height: 1.6),
          headline6: TextStyle(
              fontSize: 17,
              fontFamily: AppFonts.sfProDisplayBold,
              color: AppColors.primaryTextTextColor,
              fontWeight: FontWeight.w700,
              height: 1.6),
          bodyText1: TextStyle(
              fontSize: 17,
              fontFamily: AppFonts.sfProDisplayBold,
              color: AppColors.primaryTextTextColor,
              fontWeight: FontWeight.w700,
              height: 1.6),
          bodyText2: TextStyle(
              fontSize: 14,
              fontFamily: AppFonts.sfProDisplayRegular,
              color: AppColors.primaryTextTextColor,
              height: 1.6),
          caption: TextStyle(
              fontSize: 12,
              fontFamily: AppFonts.sfProDisplayBold,
              color: AppColors.primaryTextTextColor,
              height: 2.26),
        ),
      ),
      // home: const SplashScreen(),
      initialRoute: RouteName.splashScreen,
      onGenerateRoute: Routes.generateRoute,
    );
  }
}
