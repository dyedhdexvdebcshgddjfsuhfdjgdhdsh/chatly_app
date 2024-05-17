import 'package:chatly_app/firebase/fire_database.dart';
import 'package:chatly_app/models/group_model.dart';
import 'package:chatly_app/models/message_model.dart';
import 'package:chatly_app/screens/goups/group_members_screens.dart';
import 'package:chatly_app/screens/goups/widgets/groups_message_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class GroupScreen extends StatefulWidget {
  const GroupScreen({super.key,required this.groupModel});

  final GroupChatRoomModel groupModel;
  @override
  State<GroupScreen> createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  TextEditingController msgCon = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: IconButton(
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return MembersGroupScreen(groupModel:widget.groupModel,);
                  }));
                },
                icon: Icon(
                  Iconsax.people_copy,
                )),
          ),
        ],
        title: ListTile(
          leading: CircleAvatar(),
          title: Text(widget.groupModel.name.toString()),
          subtitle: StreamBuilder(
              stream:FireData.firestore.collection('users').where('id',whereIn:widget.groupModel.members).snapshots(),
              builder:(context,snaphot){
                if(snaphot.hasData){
                  List memebersNames=[];
                  for(var element in snaphot.data!.docs){
                    memebersNames.add(element.data()['name']);
                  }
                  return Text(memebersNames.join(','),style:Theme.of(context).textTheme.labelLarge,);
                }
              return Container();
              } ,
              ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        child: Column(
          children: [
            Expanded(
                child: StreamBuilder(
              stream: FireData.firestore
                  .collection('groups')
                  .doc(widget.groupModel.id)
                  .collection('messages')
                  .snapshots(),
              builder: (context, snapshot){
                if (snapshot.hasData) {
                  final List<MessageModel> messages = snapshot.data!.docs
                      .map((e) => MessageModel.fromJson(e.data()))
                      .toList()
                    ..sort((a, b) => b.createdAt!.compareTo(a.createdAt!));

                  if (messages.isEmpty) {
                    return Expanded(
                        child: Center(
                      child: GestureDetector(
                        onTap:(){
                       setState(() {
                         FireData.sendGroupMsg(msg:msgCon.text, groupId:widget.groupModel.id!,context:context,chatGroup:widget.groupModel);
                       });
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
                                  style:
                                      Theme.of(context).textTheme.displayLarge,
                                ),
                                SizedBox(
                                  height: 16,
                                ),
                                Text(
                                  'Hello ,Friend',
                                  style: Theme.of(context).textTheme.titleLarge,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ));
                  }else{
                    return ListView.builder(
                      reverse: true,
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        return GroupsMessageCard(index: index, messageModel: messages[index],);
                      },
                    );
                  }
                }else{
                  return Container();
                }
              },
            )),
            /*
            Expanded(
                child: Center(
                  child: GestureDetector(
                    child: Card(
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '👋',
                              style: Theme.of(context).textTheme.displayLarge,
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            Text(
                              'Hello ,Friend',
                              style: Theme.of(context).textTheme.titleLarge,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                )),
            */
            Center(
              child: GestureDetector(
                onTap:(){
                  FireData.sendGroupMsg(msg: 'welcome 👋', groupId: widget.groupModel.id!,context:context,chatGroup:widget.groupModel);
                },
                child: Row(
                  children: [
                    Expanded(
                        child: Card(
                      child: TextField(
                        controller: msgCon,
                        maxLines: 5,
                        minLines: 1,
                        decoration: InputDecoration(
                            suffixIcon: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                    onPressed: () {},
                                    icon: Icon(Iconsax.emoji_normal)),
                                IconButton(
                                    onPressed: () {}, icon: Icon(Icons.camera_alt))
                              ],
                            ),
                            border: InputBorder.none,
                            hintText: 'Write Message...',
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 16, vertical: 12)),
                      ),
                    )),
                    IconButton.filled(
                        onPressed: () {
                          if (msgCon.text.isNotEmpty) {
                            FireData.sendGroupMsg(
                            context:context,chatGroup:widget.groupModel ,
                                    msg: msgCon.text,
                                    groupId: widget.groupModel.id!)
                                .then((value) {
                              msgCon.text = "";
                              msgCon.clear();
                              setState(() {
                              });
                            });
                          }
                        },
                        icon: Icon(Iconsax.send_1))
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
