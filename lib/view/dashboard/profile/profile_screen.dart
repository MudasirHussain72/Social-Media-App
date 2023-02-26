import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive_mind/provider/user_profile_provider.dart';
import 'package:hive_mind/services/session_manager.dart';
import 'package:hive_mind/resources/color.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final firestore = FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size * 1;
    return Scaffold(
        appBar: AppBar(title: const Text('Profile Screen')),
        body: ChangeNotifierProvider(
          create: (context) => UserProfileProvider(),
          child: Consumer<UserProfileProvider>(
            builder: (context, provider, child) {
              return SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: StreamBuilder(
                        stream: firestore
                            .doc(SessionController().userId.toString())
                            .snapshots(),
                        builder: (context, AsyncSnapshot snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasData) {
                            var document = snapshot.data;
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(height: size.height * .02),
                                Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: size.height * .01),
                                      child: Center(
                                        child: Container(
                                          height: size.width / 4,
                                          width: size.width / 4,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                  color: AppColors.primaryColor,
                                                  width: 2)),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            child: provider.image == null
                                                // ignore: unrelated_type_equality_checks
                                                ? document['profileImage']
                                                            .toString ==
                                                        ""
                                                    ? const Icon(Icons.person)
                                                    : Image(
                                                        fit: BoxFit.cover,
                                                        image: NetworkImage(
                                                            document![
                                                                    'profileImage']
                                                                .toString()),
                                                        loadingBuilder: (context,
                                                            child,
                                                            loadingProgress) {
                                                          if (loadingProgress ==
                                                              null)
                                                            // ignore: curly_braces_in_flow_control_structures
                                                            return child;
                                                          return const Center(
                                                              child:
                                                                  CircularProgressIndicator());
                                                        },
                                                        errorBuilder: (context,
                                                            object, stack) {
                                                          return const Icon(
                                                            Icons.error_outline,
                                                            color: AppColors
                                                                .alertColor,
                                                          );
                                                        })
                                                : Stack(
                                                    children: [
                                                      Image.file(File(provider
                                                              .image!.path)
                                                          .absolute),
                                                      const Center(
                                                        child:
                                                            CircularProgressIndicator(),
                                                      )
                                                    ],
                                                  ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        log('clicked');
                                        provider.pickImage(context);
                                      },
                                      child: CircleAvatar(
                                        radius: size.width * .04,
                                        backgroundColor:
                                            AppColors.primaryIconColor,
                                        child: const Icon(Icons.add,
                                            color: AppColors.whiteColor),
                                      ),
                                    )
                                  ],
                                ),
                                InkWell(
                                  onTap: () {
                                    UserProfileProvider()
                                        .updateUserInfoDialogAlert(context,
                                            document['userName'], 'userName');
                                  },
                                  child: ReusableRow(
                                      title: 'Name',
                                      value: document['userName'] == ''
                                          ? 'xxx-xxx-xxx'
                                          : document['userName'],
                                      iconData: Icons.person),
                                ),
                                InkWell(
                                  // onTap: () {
                                  //   ProfileController()
                                  //       .updateUserInfoDialogAlert(context,
                                  //           document['email'], 'email');
                                  // },
                                  child: ReusableRow(
                                      title: '',
                                      value: document['email'] == ''
                                          ? 'xxx-xxx-xxx'
                                          : document['email'],
                                      iconData: Icons.alternate_email),
                                ),
                              ],
                            );
                          } else {
                            return Center(
                              child: Text(
                                'Something went wrong',
                                style: Theme.of(context).textTheme.subtitle1,
                              ),
                            );
                          }
                        },
                      )),
                ),
              );
            },
          ),
        ));
  }
}

// reusable row
class ReusableRow extends StatelessWidget {
  final String title, value;
  final IconData iconData;
  const ReusableRow(
      {super.key,
      required this.title,
      required this.value,
      required this.iconData});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(title),
          leading: Icon(iconData),
          trailing: Text(value),
        ),
        const Divider()
      ],
    );
  }
}
