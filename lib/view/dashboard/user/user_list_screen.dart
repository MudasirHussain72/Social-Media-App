import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_mind/model/user_model.dart';
import 'package:hive_mind/resources/components/user_card.dart';
import 'package:hive_mind/services/session_manager.dart';
import 'package:hive_mind/resources/color.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final db = FirebaseFirestore.instance.collection('users');
  List<UserModel> list = [];
  // for storing searched items
  final List<UserModel> _searchlist = [];
  // for storing search status
  bool _isSearching = false;
  //
  String? search = "";
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: _isSearching
              ? TextField(
                  controller: searchController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Name....',
                  ),
                  autofocus: true,
                  onChanged: (value) {
                    _searchlist.clear();
                    for (var i in list) {
                      if (i.userName
                          .toString()
                          .toLowerCase()
                          .contains(value.toLowerCase())) {
                        _searchlist.add(i);
                        setState(() {
                          _searchlist;
                        });
                      }
                    }
                  },
                )
              : const Text('Hive Mind'),
          actions: [
            IconButton(
                onPressed: () {
                  _isSearching = !_isSearching;
                  setState(() {});
                },
                icon: Icon(
                  _isSearching
                      ? CupertinoIcons.clear_circled_solid
                      : Icons.search,
                  color: AppColors.primaryColor,
                ))
          ],
        ),
        body: StreamBuilder(
          stream: db
              .where('uid', isNotEqualTo: SessionController().userId)
              .snapshots(),
          builder: (BuildContext context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
              case ConnectionState.none:
                return const Center(child: CircularProgressIndicator());
              case ConnectionState.active:
              case ConnectionState.done:
                final data = snapshot.data?.docs;

                list =
                    data?.map((e) => UserModel.fromJson(e.data())).toList() ??
                        [];
                if (list.isNotEmpty) {
                  return ListView.builder(
                    itemCount: _isSearching ? _searchlist.length : list.length,
                    itemBuilder: (context, index) {
                      return UserCard(
                          user:
                              _isSearching ? _searchlist[index] : list[index]);
                    },
                  );
                } else {
                  return const Text('No connections found');
                }
            }
          },
        ));
  }
}
