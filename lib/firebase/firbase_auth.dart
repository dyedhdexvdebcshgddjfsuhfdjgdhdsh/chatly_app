import 'dart:ui';

import 'package:chatly_app/models/chat_user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthontication {
  static FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  static FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  static User? user = firebaseAuth.currentUser;

  static Future<void> createUser() async {
    ChatUserModel chatUserModel = ChatUserModel(
        id: user!.uid,
        name: user?.displayName ?? "",
        email: user?.email ?? "",
        about: "Hello , I'm Ahmed Assem develop Chat App",
        image: '',
        createdAt: DateTime.now().toString(),
        lastActivated: DateTime.now().toString(),
        pushToken: '',
        online: false, myUsers: []);

    await firebaseFirestore
        .collection('users')
        .doc(user!.uid)
        .set(chatUserModel.toJson());
  }

  static Future getToken({required String token}) async {
    await firebaseFirestore.collection('users').doc(FirebaseAuth.instance.currentUser!.uid.toString()).update({'push_token':token});
  }

  Future updateActivate({required bool online})async{
    await firebaseFirestore.collection('users').doc(user!.uid).update({'online':online,'last_activated':DateTime.now().millisecondsSinceEpoch.toString()});
  }
}
