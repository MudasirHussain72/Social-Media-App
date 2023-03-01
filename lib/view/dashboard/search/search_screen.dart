import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hive_mind/resources/color.dart';
import 'package:hive_mind/view/dashboard/chat/chat_screen.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:hive_mind/model/user_model.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late UserModel user;

  bool isShowUsers = false;
  final searchController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: TextFormField(
            decoration: InputDecoration(labelText: 'Search for a post'),
            onFieldSubmitted: (String _) {
              setState(() {
                isShowUsers = true;
              });
              print(_);
            },
          ),
        ),
        body: isShowUsers
            ? FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .where('userName',
                        isGreaterThanOrEqualTo: searchController.text)
                    .get(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return ListView.builder(
                    itemCount: (snapshot.data! as dynamic).docs.length,
                    itemBuilder: (context, index) {
                      // return ListTile(
                      //     leading: CircleAvatar(
                      //       backgroundImage: NetworkImage(
                      // (snapshot.data! as dynamic)
                      //     .docs[index]['profileImage']
                      //               .toString()),
                      //     ),
                      //     title: Text(
                      //       (snapshot.data! as dynamic).docs[index]['userName'],
                      //     ));
                      return Card(
                        child: ListTile(
                          onTap: () {
                            // PersistentNavBarNavigator.pushNewScreen(
                            //   context,
                            //   screen: ChatScreen(user: user),
                            //   withNavBar: false,
                            // );
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //       builder: (context) => ChatScreen(user: user),
                            //     ));
                          },
                          leading: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: AppColors.primaryIconColor)),
                              child: (snapshot.data! as dynamic).docs[index]
                                          ['profileImage'] ==
                                      ''
                                  ? const Icon(Icons.person_outline)
                                  : ClipRRect(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(50)),
                                      child: CachedNetworkImage(
                                        imageUrl: (snapshot.data! as dynamic)
                                            .docs[index]['profileImage']
                                            .toString(),
                                        placeholder: (context, url) =>
                                            const CircularProgressIndicator(),
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.person),
                                      ),
                                    )),
                          title: Text(
                            (snapshot.data! as dynamic).docs[index]['userName'],
                          ),
                          subtitle: Text(
                              (snapshot.data! as dynamic).docs[index]['email']),
                        ),
                      );
                    },
                  );
                },
              )
            : FutureBuilder(
                future: FirebaseFirestore.instance.collection('posts').get(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return StaggeredGridView.countBuilder(
                    crossAxisCount: 3,
                    itemCount: (snapshot.data! as dynamic).docs.length,
                    itemBuilder: (context, index) => Image.network(
                      (snapshot.data! as dynamic).docs[index]['postUrl'],
                    ),
                    staggeredTileBuilder: (index) => StaggeredTile.count(
                        (index % 7 == 0) ? 2 : 1, (index % 7 == 0) ? 2 : 1),
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                  );
                },
              ));
  }
}
