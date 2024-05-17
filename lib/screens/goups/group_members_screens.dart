import 'package:chatly_app/firebase/fire_database.dart';
import 'package:chatly_app/models/chat_user_model.dart';
import 'package:chatly_app/models/group_model.dart';
import 'package:chatly_app/screens/goups/widgets/group_edit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class MembersGroupScreen extends StatefulWidget {
  const MembersGroupScreen({Key? key, required this.groupModel});

  final GroupChatRoomModel groupModel;

  @override
  State<MembersGroupScreen> createState() => _MembersGroupScreenState();
}

class _MembersGroupScreenState extends State<MembersGroupScreen> {
  @override
  Widget build(BuildContext context) {
    bool isAdmin = widget.groupModel.admin!.contains(FireData.myId);
    String myId = FireData.myId;

    return Scaffold(
      appBar: AppBar(
        title: Text('Group Members'),
        actions: [
          isAdmin
              ? IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return EditGroupScreen(groupModel: widget.groupModel);
                  },
                ),
              );
            },
            icon: Icon(Iconsax.user_edit),
          )
              : Container(),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FireData.firestore.collection('users').where('id', whereIn: widget.groupModel.members).snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<ChatUserModel> users = snapshot.data!.docs.map((e) => ChatUserModel.fromJson(e.data())).toList();
                    return ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        bool admin = widget.groupModel.admin!.contains(users[index].id); //
                        return ListTile(
                          title: Text(users[index].name!),
                          subtitle: admin? Text("admin", style: TextStyle(color: Colors.green)) : Text('member'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              (isAdmin && myId != users[index].id)
                                  ? IconButton(
                                onPressed: () {
                                  admin
                                      ? FireData.removeAdmin(groupId: widget.groupModel.id!, memberId: users[index].id!).then((value) {
                                    setState(() {
                                      widget.groupModel.admin!.remove(users[index].id);
                                    });
                                  })
                                      : FireData.promotAdmin(groupId: widget.groupModel.id!, memberId: users[index].id!).then((value) {
                                    setState(() {
                                      widget.groupModel.admin!.add(users[index].id);
                                    });
                                  });
                                },
                                icon: Icon(Iconsax.user_tick_copy),
                              )
                                  : Container(),
                              (isAdmin && myId != users[index].id)
                                  ? IconButton(
                                onPressed: () {
                                  FireData.removeMembers(groupId: widget.groupModel.id!, memberId: users[index].id!).then((value) {
                                    setState(() {
                                      widget.groupModel.members!.remove(users[index].id);
                                    });
                                  });
                                },
                                icon: Icon(Iconsax.trash),
                              )
                                  : Container(),
                            ],
                          ),
                        );
                      },
                    );
                  } else {
                    return CircularProgressIndicator();
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
