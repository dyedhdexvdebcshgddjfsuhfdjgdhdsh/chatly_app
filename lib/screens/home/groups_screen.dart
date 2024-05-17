import 'package:chatly_app/firebase/fire_database.dart';
import 'package:chatly_app/models/group_model.dart';
import 'package:chatly_app/screens/goups/widgets/create_groups.dart';
import 'package:chatly_app/screens/goups/widgets/goups_card.dart';
import 'package:chatly_app/screens/goups/widgets/group_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class GroupHomeScreen extends StatefulWidget {
  final GroupChatRoomModel? roomModel;

  GroupHomeScreen({Key? key, this.roomModel}) : super(key: key);

  @override
  State<GroupHomeScreen> createState() => _GroupHomeScreenState();
}

class _GroupHomeScreenState extends State<GroupHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Groups'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return CreateGroupScreen(groupRoomModel:widget.roomModel!);
          }));
        },
        child: Icon(Iconsax.message_add_1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: FireData.firestore
                    .collection('groups')
                    .where('members', arrayContains: FireData.myId)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<GroupChatRoomModel> groupsItems = snapshot.data!.docs
                        .map((e) => GroupChatRoomModel.fromJson(e.data()))
                        .toList()
                      ..sort((a, b) =>
                          b.lastMessageTime!.compareTo(a.lastMessageTime!));
                    return ListView.builder(
                      itemCount: groupsItems.length,
                      itemBuilder: (context, index) {
                      //  print('${groupsItems[index].name.toString()}');
                        return GestureDetector(
                          onTap: () {
                            print(groupsItems[index].name);
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) {
                                return GroupScreen(
                                  groupModel: groupsItems[index],
                                );
                              },
                            ));
                          },
                          child: GroupsCard(
                            groupModel: groupsItems[index],
                            nameGroup: groupsItems[index].name.toString(),
                          ),
                        );
                      },
                    );
                  } else {
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