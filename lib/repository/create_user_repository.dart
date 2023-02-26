import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive_mind/model/user_model.dart';

abstract class CreateUserRepository {
  createUser(UserModel user);
}

class FirebaseCreateUserRepository implements CreateUserRepository {
  FirebaseFirestore db = FirebaseFirestore.instance;
  @override
  Future createUser(UserModel user) async {
    db.collection('users').doc(user.uid).set(user.toJson());
  }
}
