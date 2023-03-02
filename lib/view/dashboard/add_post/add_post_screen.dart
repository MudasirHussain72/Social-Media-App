// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_mind/model/user_model.dart' as model;
import 'package:hive_mind/provider/add_post_provider.dart';
import 'package:hive_mind/provider/current_user_provider.dart';
import 'package:hive_mind/utils/utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  bool isLoading = false;
  static String? profileImage;
  TextEditingController captionController = TextEditingController();
  Uint8List? _file;
  _selectImage(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text('Create a Post'),
          children: [
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text('Take a photo'),
              onPressed: () async {
                Navigator.of(context).pop();
                Uint8List file = await pickImage(ImageSource.camera);
                setState(() {
                  _file = file;
                });
              },
            ),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text('Choose from gallery'),
              onPressed: () async {
                Navigator.of(context).pop();
                Uint8List file = await pickImage(ImageSource.gallery);
                setState(() {
                  _file = file;
                });
              },
            ),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

// func for post image on db
  void postImage(
    String uid,
    String userName,
    String profileImage,
  ) async {
    setState(() {
      isLoading = true;
    });
    try {
      String res = await AddPostProvider().uploadPost(
          captionController.text.trim(), _file!, uid, userName, profileImage);
      if (res == 'success') {
        setState(() {
          isLoading = false;
        });
        Utils.toastMessage('Posted');
        clearImage();
      } else {
        setState(() {
          isLoading = false;
        });
        Utils.toastMessage(res);
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      Utils.toastMessage(e.toString());
    }
  }

  void clearImage() {
    setState(() {
      _file = null;
    });
  }

  showDisplayName() async {
    var collection = FirebaseFirestore.instance.collection('users');
    var docSnapshot =
        await collection.doc(FirebaseAuth.instance.currentUser!.uid).get();
    Map<String, dynamic> data = docSnapshot.data()!;
    profileImage = data['profileImage'];
  }

  @override
  void dispose() {
    super.dispose();
    captionController.dispose();
  }

  @override
  void initState() {
    showDisplayName();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    model.UserModel user = Provider.of<CurrentUserProvider>(context).getUser;
    return _file == null
        ? Center(
            child: IconButton(
                onPressed: () {
                  _selectImage(context);
                },
                icon: const Icon(Icons.upload)),
          )
        : Scaffold(
            appBar: AppBar(
              leading: IconButton(
                  onPressed: () {
                    clearImage();
                  },
                  icon: const Icon(Icons.arrow_back_ios)),
              title: const Text('Post to'),
              centerTitle: false,
              actions: [
                TextButton(
                    onPressed: () {
                      postImage(
                        user.uid.toString(),
                        user.userName.toString(),
                        profileImage.toString(),
                      );
                    },
                    child: const Text('Post'))
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Column(children: [
                isLoading ? const LinearProgressIndicator() : Container(),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                        backgroundImage:
                            NetworkImage(user.profileImage.toString())),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: TextField(
                          controller: captionController,
                          maxLines: 8,
                          decoration: const InputDecoration(
                              hintText: 'Write a caption',
                              border: InputBorder.none)),
                    ),
                    SizedBox(
                      height: 45,
                      width: 45,
                      child: AspectRatio(
                          aspectRatio: 487 / 451,
                          child: Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: MemoryImage(_file!),
                                    fit: BoxFit.fill,
                                    alignment: FractionalOffset.topCenter)),
                          )),
                    ),
                    const Divider()
                  ],
                )
              ]),
            ),
          );
  }
}

//
pickImage(ImageSource source) async {
  final ImagePicker _imagePicker = ImagePicker();
  XFile? _file = await _imagePicker.pickImage(source: source);
  if (_file != null) {
    return await _file.readAsBytes();
  }
  if (kDebugMode) {
    print('NO image selected');
  }
}
