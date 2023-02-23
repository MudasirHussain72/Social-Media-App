import 'package:flutter/material.dart';
import 'package:hive_mind/utils/routes/route_name.dart';
import 'package:hive_mind/view/dashboard/dashboard_screen.dart';
import 'package:hive_mind/view/forgot_password/forgot_password.dart';
import 'package:hive_mind/view/login/login_screen.dart';
import 'package:hive_mind/view/signup/sign_up_screen.dart';
import 'package:hive_mind/view/splash/splash_screen.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // ignore: unused_local_variable
    final arguments = settings.arguments;
    switch (settings.name) {
      case RouteName.splashScreen:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case RouteName.loginView:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case RouteName.signupView:
        return MaterialPageRoute(builder: (_) => const SignUpScreen());
      case RouteName.forgotPasswordView:
        return MaterialPageRoute(builder: (_) => const ForgotPasseordScreen());
      case RouteName.dashboardView:
        return MaterialPageRoute(builder: (_) => const DashboardScreen());

      default:
        return MaterialPageRoute(builder: (_) {
          return Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          );
        });
    }
  }
}
