import 'package:chatly_app/firebase/fire_database.dart';
import 'package:chatly_app/models/chat_user_model.dart';
import 'package:chatly_app/models/room_model.dart';
import 'package:chatly_app/screens/chat/chat_screen.dart';
import 'package:chatly_app/screens/chat/chat_widget/chat_card.dart';
import 'package:chatly_app/widgets/reusable_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class ChatHomeScreen extends StatefulWidget {
  const ChatHomeScreen({Key? key}) : super(key: key);

  @override
  State<ChatHomeScreen> createState() => _ChatHomeScreenState();
}

class _ChatHomeScreenState extends State<ChatHomeScreen> {
  TextEditingController friendEmController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  ChatUserModel? chatUserModel;
  ChatRoomModel? roomModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              await FireData.firestore
                  .collection('rooms')
                  .doc(roomModel!.id)
                  .get();
            },
            icon: Icon(Iconsax.refresh_2),
          )
        ],
        title: Text(
          'Chat',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showBottomSheet(
            context: context,
            builder: (context) {
              return Container(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Enter Friend Email',
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            Spacer(),
                            IconButton(
                              onPressed: () {},
                              icon: Icon(Iconsax.scan_barcode_copy),
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: CustomTextFormField(
                            editingController: friendEmController,
                            name: 'Email',
                            prefixIcon: Iconsax.direct,
                            validation: (value) {
                              if (value!.isEmpty) {
                                return 'FriendEmail is Required';
                              }
                              return null;
                            },
                          ),
                        ),
                        Center(
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.04,
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: ElevatedButton(
                              onPressed: () async {
                                if (formKey.currentState!.validate()) {
                                  await FireData.createRoom(
                                    email: friendEmController.text,
                                  ).then((value) {
                                    setState(() {
                                      friendEmController.text = "";
                                    });
                                    Navigator.pop(context);
                                  }).onError((error, stackTrace) {
                                    return;
                                  });
                                }
                              },
                              child: Text('Create Chat'),
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.all(4), backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
        child: Icon(Iconsax.message_add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize:MainAxisSize.min,
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FireData.firestore
                    .collection('rooms')
                    .where('members',
                    arrayContains: FirebaseAuth.instance.currentUser!.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<ChatRoomModel> chatRooms = snapshot.data!.docs
                        .map((roomData) =>ChatRoomModel.fromJson(roomData.data() as Map<String,dynamic>))
                        .toList()
                      ..sort((a, b) => b.lastMessageTime!
                          .compareTo(a.lastMessageTime!));
                    return ListView.builder(
                      itemCount: chatRooms.length,
                      itemBuilder: (context, index) {
                        print(chatRooms.length);
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) {
                                return ChatScreen(
                                  chatRoomId: chatRooms[index].id!,
                                  chatUserModel:chatUserModel!,
                                );
                              },
                            ));
                          },
                          child: ChatUserCard(
                            chatRoomModel: chatRooms[index],

                          ),
                        );
                      },
                    );
                  } else{
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}