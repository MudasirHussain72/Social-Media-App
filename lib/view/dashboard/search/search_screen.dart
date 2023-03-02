import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hive_mind/resources/color.dart';
import 'package:hive_mind/model/user_model.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late UserModel user;
  // for storing search status
  bool _isSearching = false;
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
          title: _isSearching
              ? TextFormField(
                  decoration:
                      const InputDecoration(labelText: 'Search for a post'),
                  onFieldSubmitted: (String _) {
                    setState(() {
                      isShowUsers = true;
                    });
                    if (kDebugMode) {
                      print(_);
                    }
                  },
                )
              : const Text('Hive Mind'),
          actions: [
            IconButton(
                onPressed: () {
                  _isSearching = !_isSearching;
                  setState(() {
                    isShowUsers = false;
                  });
                },
                icon: Icon(
                  _isSearching
                      ? CupertinoIcons.clear_circled_solid
                      : Icons.search,
                  color: AppColors.primaryColor,
                ))
          ],
        ),
        body: isShowUsers
            ? FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection('posts')
                    .where('description',
                        isGreaterThanOrEqualTo: searchController.text)
                    .get(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return ListView.builder(
                    itemCount: (snapshot.data! as dynamic).docs.length,
                    itemBuilder: (context, index) {
                      return Image.network(
                        (snapshot.data! as dynamic).docs[index]['postUrl'],
                      );
                    },
                  );
                },
              )
            : FutureBuilder(
                future: FirebaseFirestore.instance.collection('posts').get(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return StaggeredGridView.countBuilder(
                    crossAxisCount: 3,
                    itemCount: (snapshot.data! as dynamic).docs.length,
                    itemBuilder: (context, index) => Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                              image: NetworkImage(
                                (snapshot.data! as dynamic)
                                    .docs[index]['postUrl']
                                    .toString(),
                              ),
                              fit: BoxFit.cover)),
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
