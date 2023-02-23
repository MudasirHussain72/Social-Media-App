import 'package:flutter/material.dart';
import 'package:hive_mind/model/signup/signup_controller.dart';
import 'package:hive_mind/res/components/input_text_field.dart';
import 'package:hive_mind/res/components/round_button.dart';
import 'package:hive_mind/utils/routes/route_name.dart';
import 'package:hive_mind/utils/utils.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formkey = GlobalKey<FormState>();
  final userNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final emailFocusNode = FocusNode();
  final userNameFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  @override
  void dispose() {
    super.dispose();
    userNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    userNameFocusNode.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size * 1;
    return Scaffold(
      // appBar: AppBar(
      //   elevation: 0,
      // ),
      body: SafeArea(
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: ChangeNotifierProvider(
              create: (context) => SignUpController(),
              child: Consumer<SignUpController>(
                builder: (context, provider, child) {
                  return SingleChildScrollView(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // SizedBox(height: size.height * .01),
                          Text("Welcome to",
                              style: Theme.of(context).textTheme.headline3),
                          SizedBox(height: size.height * .001),
                          Center(
                              child: Image(
                            image: const AssetImage('assets/images/logo.png'),
                            width: size.width / 2,
                          )),
                          SizedBox(height: size.height * .04),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text("Register your account",
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.subtitle1),
                          ),
                          Form(
                            key: _formkey,
                            child: Padding(
                              padding: EdgeInsets.only(
                                  top: size.height * .02,
                                  bottom: size.height * .01),
                              child: Column(children: [
                                InputTextField(
                                  myController: userNameController,
                                  focusNode: userNameFocusNode,
                                  onFieldSubmittedValue: (newValue) {
                                    Utils.fieldFocus(context, userNameFocusNode,
                                        emailFocusNode);
                                  },
                                  keyBoardType: TextInputType.name,
                                  hint: "User Name",
                                  obscureText: false,
                                  onValidator: (value) {
                                    return value.isEmpty ? "enter Name" : null;
                                  },
                                ),
                                SizedBox(height: size.height * .01),
                                InputTextField(
                                  myController: emailController,
                                  focusNode: emailFocusNode,
                                  onFieldSubmittedValue: (newValue) {
                                    Utils.fieldFocus(context, emailFocusNode,
                                        passwordFocusNode);
                                  },
                                  keyBoardType: TextInputType.emailAddress,
                                  hint: "Email",
                                  obscureText: false,
                                  onValidator: (value) {
                                    return value.isEmpty ? "enter email" : null;
                                  },
                                ),
                                SizedBox(height: size.height * .01),
                                InputTextField(
                                  myController: passwordController,
                                  focusNode: passwordFocusNode,
                                  onFieldSubmittedValue: (newValue) {},
                                  keyBoardType: TextInputType.emailAddress,
                                  hint: "Password",
                                  obscureText: true,
                                  onValidator: (value) {
                                    return value.isEmpty
                                        ? "enter password"
                                        : null;
                                  },
                                ),
                              ]),
                            ),
                          ),
                          SizedBox(height: size.height * .04),
                          RoundButton(
                            title: "SignUp",
                            loading: provider.loading,
                            onPress: () {
                              if (_formkey.currentState!.validate()) {
                                provider.signup(
                                    context,
                                    userNameController.text.trim().toString(),
                                    emailController.text.trim().toString(),
                                    passwordController.text.trim().toString());
                              }
                            },
                          ),
                          SizedBox(height: size.height * .03),
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, RouteName.loginView);
                            },
                            child: Text.rich(
                              TextSpan(
                                  text: "Already have an account? ",
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1!
                                      .copyWith(fontSize: 15),
                                  children: [
                                    TextSpan(
                                      text: 'Login',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline2!
                                          .copyWith(
                                              fontSize: 15,
                                              decoration:
                                                  TextDecoration.underline),
                                    )
                                  ]),
                            ),
                          )
                        ]),
                  );
                },
              ),
            )),
      ),
    );
  }
}
