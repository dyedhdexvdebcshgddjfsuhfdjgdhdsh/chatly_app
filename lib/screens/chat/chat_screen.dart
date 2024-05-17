import 'dart:io';
import 'package:chatly_app/firebase/fire_database.dart';
import 'package:chatly_app/firebase/firebase_storage.dart';
import 'package:chatly_app/models/chat_user_model.dart';
import 'package:chatly_app/models/message_model.dart';
import 'package:chatly_app/provider/provider.dart';
import 'package:chatly_app/screens/chat/chat_widget/chat_message_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen({super.key, required this.chatRoomId,required this.chatUserModel});

  TextEditingController msgCon = TextEditingController();
  final String chatRoomId;
  final ChatUserModel chatUserModel;
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  List<String> selectedMsg = [];
  List<String> copydMsg = [];
  @override
  void initState() {
    Provider.of<ProviderApp>(context,listen: false).getUserDetails();
    super.initState();
  }

  Widget build(BuildContext context) {
  ProviderApp? provider;
String? roomId=widget.chatRoomId;
    return Scaffold(
      appBar: AppBar(
        actions: [
          selectedMsg.isNotEmpty
              ? IconButton(
                  onPressed: () {
                    FireData.deleteMsg(
                        msgId: widget.chatRoomId, messages: selectedMsg);
                    setState(() {
                      copydMsg.clear();
                      selectedMsg.clear();
                    });
                  },
                  icon: Icon(
                    Iconsax.trash,
                  ))
              : Container(),
          IconButton(
              onPressed: () {
                Clipboard.setData(ClipboardData(text:copydMsg.join(' \n')));
               setState(() {
                 copydMsg.clear();
                 selectedMsg.clear();
               });
              },
              icon: selectedMsg.isNotEmpty
                  ? Icon(
                      Iconsax.copy,
                    )
                  : Container())
        ],
        title: ListTile(
          leading: CircleAvatar(),
          title: Consumer<ProviderApp>(
            builder:(context,provider,wid){
              return  StreamBuilder(
                  stream: FireData.firestore
                      .collection('users')
                      .doc(roomId)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if(snapshot.hasData){
                   return Text(widget.chatUserModel.name.toString());
                    //  return Text(provider.me?.name??'');
                    }else{
                      return Container();
                    }
                  }
              );
            },
          ),
          subtitle:Consumer<ProviderApp>(
              builder: (context, provider, child) {
                return StreamBuilder(
                  stream: FireData.firestore
                      .collection('users')
                      .doc(roomId)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Text(
                        snapshot.data!.data()?['online']== true
                            ? 'Online 🟢'
                            : 'Last Seen at: ${provider.me!.lastActivated.toString()}',
                      );
                    } else {
                      return Container();
                    }
                  },
                );
              },
            ),
      )),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        child: Column(
          children: [
            Expanded(
                child: StreamBuilder(
              stream: FireData.firestore
                  .collection('rooms')
                  .doc(roomId)
                  .collection('messages')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<MessageModel> messages = snapshot.data!.docs
                      .map((e) => MessageModel.fromJson(e.data()))
                      .toList()
                    ..sort((a, b) =>b.createdAt!.compareTo(a.createdAt!));
                  return messages.isNotEmpty
                      ? ListView.builder(
                          reverse: true,
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                //--------delete-----
                                selectedMsg.isNotEmpty
                                    ? selectedMsg.contains(messages[index].id)
                                        ? selectedMsg.remove(messages[index].id)
                                        : selectedMsg.add(messages[index].id!)
                                    : null;
                                //---------copy--------
                                selectedMsg.isNotEmpty
                                    ? selectedMsg.contains(messages[index].id)
                                        ? selectedMsg.remove(messages[index].id)
                                        : selectedMsg.add(messages[index].id!)
                                    : null;
                              },
                              onLongPress: () {
                                setState(() {
                                  selectedMsg.contains(messages[index].id)
                                      ? selectedMsg.remove(messages[index].id)
                                      : selectedMsg.add(messages[index].id!);
                                  //--------------------
                                  print(selectedMsg);
                                  copydMsg.isNotEmpty?
                                  messages[index].type=='text'?
                                  copydMsg.contains(messages[index].message)
                                      ? copydMsg
                                          .remove(messages[index].message!)
                                      : copydMsg.add(messages[index].message!):null:null;
                               print(copydMsg);
                                });
                              },
                              child: ChatMessageCard(
                                roomId: widget.chatRoomId,
                                index: index,
                                messageModel: messages[index],
                                selected:
                                    selectedMsg.contains(messages[index].id),
                              ),
                            );
                            // ListTile(title:Text(messages[index].message.toString()),);
                          },
                        )
                      : Expanded(
                          child: Center(
                          child: GestureDetector(
                            onTap: () {
                               FireData.sendMessage(
                                  userid: widget.chatUserModel.id.toString(),
                                  msg: 'Welcome 👋',
                                  roomsId: widget.chatRoomId, context: context, chatuser: widget.chatUserModel,);
                            },
                            child: Card(
                              child: Padding(
                                padding: EdgeInsets.all(12),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '👋',
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayLarge,
                                    ),
                                    SizedBox(
                                      height: 16,
                                    ),
                                    Text(
                                      'Hello ,Friend',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ));
                }
                return Container();
              },
            )),
            Row(
              children: [
                Expanded(
                    child: Card(
                  child: TextField(
                    controller: widget.msgCon,
                    maxLines: 5,
                    minLines: 1,
                    decoration: InputDecoration(
                        suffixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton.filled(
                                onPressed: () {},
                                icon: Icon(Iconsax.emoji_normal)),
                            IconButton.filled(
                                onPressed: () async {
                                  final ImagePicker picker = ImagePicker();
                                  XFile? image = await picker.pickImage(
                                      source: ImageSource.gallery);

                                  if (image != null) {
                                    print(image.path);
                                    await FireStorage().sendImageToStorage(
                                      chatUser:widget.chatUserModel,
                                        context:context,
                                        file: File(image.path),
                                        roomId: widget.chatRoomId,
                                        userId: widget.chatUserModel.id!);
                                  }
                                },
                                icon: Icon(Icons.camera_alt))
                          ],
                        ),
                        border: InputBorder.none,
                        hintText: 'Write Message...',
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 12)),
                  ),
                )),
                IconButton.filled(
                    onPressed: () async {
                      if (widget.msgCon.text.isNotEmpty) {
                        await FireData.sendMessage(
                          chatuser:widget.chatUserModel,
                                userid: widget.chatUserModel.id!,
                                msg: widget.msgCon.text,
                                roomsId: widget.chatRoomId, context: context,)
                            .then((value) {
                          setState(() {
                            widget.msgCon.text = "";
                          });
                        });
                      }
                    },
                    icon: Icon(Iconsax.send_1))
              ],
            )
          ],
        ),
      ),
    );
  }
}
