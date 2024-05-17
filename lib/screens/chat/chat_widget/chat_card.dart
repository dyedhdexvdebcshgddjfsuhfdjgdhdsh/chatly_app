import 'package:chatly_app/firebase/fire_database.dart';
import 'package:chatly_app/models/chat_user_model.dart';
import 'package:chatly_app/models/message_model.dart';
import 'package:chatly_app/models/room_model.dart';
import 'package:chatly_app/provider/provider.dart';
import 'package:chatly_app/screens/chat/chat_screen.dart';
import 'package:chatly_app/utlis/date_time.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ChatUserCard extends StatefulWidget {
  ChatUserCard({
    Key? key,
    required this.chatRoomModel,
  }) : super(key: key);

  final ChatRoomModel chatRoomModel;

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  @override
  void initState() {
    super.initState();
    Provider.of<ProviderApp>(context, listen: false).getUserDetails();
  }
  @override
  Widget build(BuildContext context) {
    ChatRoomModel roomModel=widget.chatRoomModel;
    String roomId=widget.chatRoomModel.id.toString();

    List members = roomModel.members!
        .where((element) => element != FirebaseAuth.instance.currentUser?.uid)
        .toList();

    String? userId = members.isNotEmpty
        ? FireData.myId
        : members.firstWhere(
            (element) => element == FirebaseAuth.instance.currentUser!.uid,
        orElse: () => null);


    return StreamBuilder(
      stream:  FireData.firestore.collection('users').doc(userId).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          ChatUserModel chatUserData =
          ChatUserModel.fromJson(snapshot.data!.data() ?? {});
                       print(widget.chatRoomModel.lastMessage);
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width:MediaQuery.of(context).size.width*0.9,
                height: MediaQuery.of(context).size.height*0.1 ,
                child: Card(
                  child: ListTile(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(
                            chatRoomId:userId??"",
                            chatUserModel: chatUserData,
                          ),
                        ),
                      );
                    },
                    leading: chatUserData.image == ''
                        ? CircleAvatar(radius: 65)
                        : CircleAvatar(
                      radius: 65,
                      backgroundImage: NetworkImage(
                          chatUserData.image ?? ''),
                    ),
                    title: Consumer<ProviderApp>(
                      builder: (context, provider, child) {
                    //    print(.lastMessage);
                        return StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('rooms')
                              .doc(roomId)
                              .collection('messages')
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Text(chatUserData.name ?? '');
                            } else {
                              return Container();
                            }
                          },
                        );
                      },
                    ),
                    subtitle: Consumer<ProviderApp>(
                      builder: (context, provider, child) {
                        print(roomModel.lastMessageTime);
                        return StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('rooms')
                              .doc(roomModel.id)
                              .collection('messages')
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              print(roomModel.lastMessage);
                              return Text(
                                '${roomModel.lastMessage == "" ? chatUserData.about :roomModel.lastMessage}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              );
                            } else {
                              return Container();
                            }
                          },
                        );
                      },
                    ),
                    trailing: FittedBox(
                      fit: BoxFit.fitHeight,
                      alignment:Alignment.centerRight,
                      child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('rooms')
                            .doc(roomModel.id)
                            .collection('messages')
                            .snapshots(),
                        builder: (context, snapshot) {
                          final unreadMessagesList = snapshot.data?.docs
                              .map((message) => MessageModel.fromJson(message.data()))
                              .where((element) => element.read == "")
                              .where((element) =>
                          element.fromId != FirebaseAuth.instance.currentUser?.uid)
                              .toList() ?? [];

                          return unreadMessagesList.isNotEmpty?Text(MyDateTime.dateAndTime(time:roomModel.lastMessageTime.toString()).toString()): Badge(
                            label: Text(
                              unreadMessagesList.length.toString(),
                              style: TextStyle(color: Colors.white),
                            ),
                            child: Icon(Icons.message),
                          );
                        },
                      ),
                    ),
                    ),
                 ),
               ),
             ],
           );
        } else if (snapshot.hasError) {
          return const Text('');
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
