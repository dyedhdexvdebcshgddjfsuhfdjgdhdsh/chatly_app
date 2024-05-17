import 'dart:io';

import 'package:chatly_app/firebase/fire_database.dart';
import 'package:chatly_app/models/chat_user_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

class FireStorage {
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  sendImageToStorage(
      {required File file,
      required String roomId,
      required String userId,
      required BuildContext context,
      required ChatUserModel chatUser}) async {
    String filePath = file.path.split('.').last;
    final ref = firebaseStorage.ref().child(
        'images/$roomId/${DateTime.now().millisecondsSinceEpoch}.$filePath');

    ref.putFile(file);

    String imageUrl = await ref.getDownloadURL();
    print(imageUrl);

    await FireData.sendMessage(
        userid: userId,
        msg: imageUrl,
        roomsId: roomId,
        type: 'image',
        context: context,
        chatuser: chatUser);
  }

  Future updateProfile({required File file}) async {
    String uId = FireData.myId;
    String filePath = file.path.split('.').last;

    final ref = firebaseStorage.ref().child(
        'profiles/$uId/${DateTime.now().millisecondsSinceEpoch}.$filePath');
    ref.putFile(file);

    String imageUrl = await ref.getDownloadURL();
    print(imageUrl);
    await FireData.firestore
        .collection('users')
        .doc(uId)
        .update({'image': imageUrl});
  }
}
