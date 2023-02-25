import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive_mind/model/services/session_manager.dart';
import 'package:hive_mind/resources/color.dart';
import 'package:hive_mind/view/dashboard/chat/message_screen.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final db = FirebaseFirestore.instance.collection('users');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('User List')),
        body: StreamBuilder(
          stream: db.snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.connectionState == ConnectionState.active ||
                snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              } else if (snapshot.hasData) {
                var document = snapshot.data;
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    if (SessionController().userId.toString() ==
                        document!.docs[index].get('uid')) {
                      return Container();
                    } else {
                      return Card(
                        child: ListTile(
                          onTap: () {
                            PersistentNavBarNavigator.pushNewScreen(context,
                                screen: MessageScreen(
                                    name: document.docs[index].get('userName'),
                                    email: document.docs[index].get('email'),
                                    image: document.docs[index]
                                        .get('profileImage'),
                                    recieverUid: document.docs[index].get('uid')),
                                withNavBar: false);
                          },
                          leading: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: AppColors.primaryIconColor)),
                              child:
                                  document.docs[index].get('profileImage') == ''
                                      ? const Icon(Icons.person_outline)
                                      : ClipRRect(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(50)),
                                          child: Image(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(
                                              document.docs[index]
                                                  .get('profileImage'),
                                            ),
                                          ),
                                        )),
                          title: Text(
                            document.docs[index].get('userName'),
                          ),
                          subtitle: Text(
                            document.docs[index].get('email'),
                          ),
                        ),
                      );
                    }
                    // return
                  },
                );
              } else {
                return const Text('Something went wrong');
              }
            } else {
              return const Text('Something went wrong');
            }
          },
        ));
  }
}
