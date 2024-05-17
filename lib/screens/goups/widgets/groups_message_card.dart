import 'package:chatly_app/firebase/fire_database.dart';
import 'package:chatly_app/models/message_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class GroupsMessageCard extends StatefulWidget {
  const GroupsMessageCard({
    Key? key,
    required this.index,
    required this.messageModel,
  }) : super(key: key);

  final int index;
  final MessageModel messageModel;

  @override
  State<GroupsMessageCard> createState() => _GroupsMessageCardState();
}

class _GroupsMessageCardState extends State<GroupsMessageCard> {
  @override
  Widget build(BuildContext context) {
    bool isMe = widget.messageModel.fromId == FireData.myId;
    return StreamBuilder(
      stream: FireData.firestore.collection('users').doc(widget.messageModel.fromId).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              isMe ? SizedBox() : IconButton(
                onPressed: () {},
                icon: Icon(Iconsax.message_edit_copy),
              ),
              Expanded(
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(isMe ? 16 : 0),
                      bottomRight: Radius.circular(isMe ? 0 : 16),
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                  ),
                  color: isMe ? Theme.of(context).colorScheme.primaryContainer : Theme.of(context).colorScheme.background,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 2),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          !isMe ? Text(
                            snapshot.data!['name'],
                            style: Theme.of(context).textTheme.labelLarge,
                          ) : SizedBox(),
                          Text(widget.messageModel.message!),
                          SizedBox(height: 10),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              isMe ? SizedBox() : Icon(
                                Iconsax.tick_circle,
                                size: 18,
                                color: Colors.green,
                              ),
                              SizedBox(width: 5),
                              Text(
                                widget.messageModel.createdAt.toString(),
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        } else {
          return Container();
        }
      },
    );
  }
}
