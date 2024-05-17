import 'dart:async';
import 'dart:convert';

import 'package:chatly_app/models/chat_user_model.dart';
import 'package:chatly_app/models/group_model.dart';
import 'package:chatly_app/models/message_model.dart';
import 'package:chatly_app/models/room_model.dart';
import 'package:chatly_app/provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

class FireData {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static String myId = FirebaseAuth.instance.currentUser!.uid;
  String dateNow = DateTime.now().millisecondsSinceEpoch.toString();

  static Future createRoom({required String email}) async {
    QuerySnapshot? userEmail = await firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .get();
    if (userEmail.docs.isNotEmpty) {
      String? userID = userEmail.docs.first.id;
      List<String> myMembers = [myId, userID]..sort((a, b) => a.compareTo(b));
      QuerySnapshot roomExit = await firestore
          .collection('rooms')
          .where('members', isEqualTo: myMembers)
          .get();
      if (roomExit.docs.isEmpty) {
        ChatRoomModel chatRoomModel = ChatRoomModel(
            id: myMembers.toString(),
            members: myMembers,
            lastMessage: "",
            lastMessageTime: DateTime.now().toString(),
            createdAt: DateTime.now().toString());
        // create chatRoom between two user
        firestore
            .collection('rooms')
            .doc(myMembers.toString())
            .set(chatRoomModel.toJson());
      }
    }
  }

  Future addContact({required String email}) async {
    QuerySnapshot<Map<String, dynamic>> userEmail = await firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .get();

    if (userEmail.docs.isNotEmpty) {
      String userID = userEmail.docs.first.id;
      firestore.collection('users').doc(myId).update({
        'my_users': FieldValue.arrayUnion([userID])
      });
    }
  }

  static Future sendMessage(
      {required String userid,
      required BuildContext context,
      required String msg,
      required ChatUserModel chatuser,
      required String roomsId,
      String? type}) async {
    String msgid = Uuid().v1();
    MessageModel message = MessageModel(
        id: msgid,
        fromId: myId,
        toId: userid,
        message: msg,
        createdAt: DateTime.now().toString(),
        type: type ?? 'text',
        read: '');

    await FireData.firestore
        .collection('rooms')
        .doc(roomsId)
        .collection('messages')
        .doc(msgid)
        .set(message.toJson(), SetOptions(merge: true));
    firestore.collection('rooms').doc(roomsId).update({
      'last_message': type ?? msg,
      'last_message_time': DateTime.now().millisecondsSinceEpoch.toString()
    }).then((value) async {
      await sendNotification(
        chatUser: chatuser,
        context: context,
        msg: type ?? msg,
      );
    });
  }

  static Future sendGroupMsg(
      {required String msg,
      required GroupChatRoomModel chatGroup,
      required String groupId,
      required BuildContext context,
      String? type}) async {
    String msgid = Uuid().v1();
    MessageModel message = MessageModel(
        id: msgid,
        fromId: myId,
        toId: '',
        message: msg,
        createdAt: DateTime.now().toString(),
        type: type ?? 'text',
        read: '');

    List<ChatUserModel> chatUsers = [];
    chatGroup.members!= chatGroup.members?.where((element) => element != myId).toList();
    firestore
        .collection('users')
        .where('id', whereIn: chatGroup.members)
        .get()
        .then((value) {
      chatUsers.addAll(
          value.docs.map((e) => ChatUserModel.fromJson(e.data())).toList());
    });
    await FireData.firestore
        .collection('groups')
        .doc(groupId)
        .collection('messages')
        .doc(msgid)
        .set(message.toJson())
        .then((value) async {
      for (var element in chatUsers) {
        await sendNotification(
            chatUser: element, context: context, msg: type ?? msg,groupName:chatGroup.name);
      }
    });
    await firestore.collection('groups').doc(groupId).update({
      'last_message': type ?? msg,
      'last_message_time': DateTime.now().millisecondsSinceEpoch.toString()
    });
  }

  Future createGroup({required String nameGroup, required List members}) async {
    String groupId = Uuid().v1();
    members.add(myId);
    GroupChatRoomModel groupModel = GroupChatRoomModel(
        name: nameGroup,
        image: '',
        admin: [myId],
        id: groupId,
        members: members,
        lastMessage: '',
        lastMessageTime: dateNow,
        createdAt: dateNow);
    await firestore.collection('groups').doc(groupId).set(groupModel.toJson());
  }

  Future readMessage({required String roomId, required String msgId}) async {
    await firestore
        .collection('rooms')
        .doc(roomId)
        .collection('messages')
        .doc(msgId)
        .update({'read': DateTime.now().millisecondsSinceEpoch.toString()});
  }

  static Future deleteMsg(
      {required String msgId, required List<String> messages}) async {
    if (messages.length == 1) {
      for (var msg in messages) {
        await firestore
            .collection('rooms')
            .doc(msgId)
            .collection('messages')
            .doc(messages.first)
            .delete();
      }
    } else {
      for (var msg in messages) {
        await firestore
            .collection('rooms')
            .doc(msgId)
            .collection('messages')
            .doc(msg)
            .delete();
      }
    }
  }

  static Future editGroup(
      {required String groupId,
      required String name,
      required List members}) async {
    await firestore
        .collection('groups')
        .doc(groupId)
        .update({'name': name, 'members': FieldValue.arrayUnion(members)});
  }

  static Future removeMembers(
      {required String groupId, required String memberId}) async {
    await firestore.collection('groups').doc().update({
      'members': FieldValue.arrayUnion([memberId])
    });
  }

  static Future promotAdmin(
      {required String groupId, required String memberId}) async {
    await firestore.collection('groups').doc().update({
      'admins_id': FieldValue.arrayUnion([memberId])
    });
  }

  static Future removeAdmin(
      {required String groupId, required String memberId}) async {
    await firestore.collection('groups').doc().update({
      'admins_id': FieldValue.arrayUnion([memberId])
    });
  }

  Future editProfile({required String name, required String about}) async {
    await firestore
        .collection('users')
        .doc(myId)
        .update({'name': name, 'about': about});
  }

  static Future sendNotification(
      {required ChatUserModel chatUser,
      required BuildContext context,
      required String msg,
      String? groupName}) async {
    final headers = {
      'Content-Type': 'application/json',
      'Authorization':
          'key=AAAAAxBnkvU:APA91bHsijfKKlptuwTJIE3D2rAwkMDOFpgR2YfvZ0YUnJ_tlDhLiuAAAdKfUp98wmobj5-smanODeaiaUVb0_sIH5v8IrO5HBUOdO1Q41CPG6P1NWd2uJHSvPKOMTVxUlbHXhy-JW5j'
    };
    final body = {
      'to': chatUser.pushToken,
      "notification": {
        "title": groupName == null
            ? Provider.of<ProviderApp>(context, listen: false).me!.name
            : 'Group Name : ' +
                '${Provider.of<ProviderApp>(context, listen: false).me!.name}',
        "body": msg,
      }
    };
    final request = await http.post(
        Uri.parse(
          'https://fcm.googleapis.com/fcm/send',
        ),
        headers: headers,
        body: jsonEncode(body));
    print(request.statusCode);
  }
}
