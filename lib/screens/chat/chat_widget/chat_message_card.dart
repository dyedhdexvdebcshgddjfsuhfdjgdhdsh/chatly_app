import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatly_app/firebase/fire_database.dart';
import 'package:chatly_app/models/message_model.dart';
import 'package:chatly_app/utlis/photo_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:intl/intl.dart';

class ChatMessageCard extends StatefulWidget {
  const ChatMessageCard({
    super.key,
    required this.index,
    required this.messageModel, required this.roomId, required this.selected,
  });

  @override
  final int index;
  final MessageModel messageModel;
  final bool selected;
  final String  roomId;
  @override
  State<ChatMessageCard> createState() => _ChatMessageCardState();
}

class _ChatMessageCardState extends State<ChatMessageCard> {
  @override
  void initState() {
   if(widget.messageModel.toId==FirebaseAuth.instance.currentUser!.uid){
     FireData().readMessage(roomId:widget.roomId, msgId:widget.messageModel.id!);
   }
    super.initState();
  }
  Widget build(BuildContext context) {
    bool isMe = widget.messageModel.fromId == FirebaseAuth.instance.currentUser!.uid;
    return Container(
      decoration:BoxDecoration(
        color:widget.selected?Colors.white:Colors.red ,borderRadius:BorderRadius.circular(12)
      ),
      margin:EdgeInsets.symmetric(vertical:5),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          isMe
              ? IconButton(
                  onPressed: () {}, icon: Icon(Iconsax.message_edit_copy))
              : SizedBox(),
          Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(isMe ? 16 : 0),
                    bottomRight: Radius.circular(isMe ? 0 : 16),
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12))),
            color:isMe
                ? Theme.of(context).colorScheme.primaryContainer
                : Theme.of(context).colorScheme.background,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width / 2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // crossAxisAlignment:CrossAxisAlignment.start,
                  children: [
              //      isMe ? Text(messageModel.message.toString()) : SizedBox(),
                    widget.messageModel.message=='image'?GestureDetector(

                      child: Container(child:CachedNetworkImage(imageUrl:widget.messageModel.message.toString(),placeholder:(context,url){
                        return CircularProgressIndicator();
                      },)),
                   onTap:(){
                        Navigator.of(context).push(MaterialPageRoute(builder:(context){
                          return PhotoViewScreen(img:widget.messageModel.message!);
                        }));
                   },
                    ) : Text(widget.messageModel.message.toString(),style:TextStyle(fontSize: 20),) ,
                  SizedBox(height: 6,) ,
                    Row(
                      children: [
                        Text(
                          DateFormat.yMMMEd().format(DateTime.now()),
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        isMe
                            ? Icon(
                                Iconsax.tick_circle,
                                size: 18,
                                color:widget.messageModel.read==""? Colors.grey: Colors.green,
                              )
                            : SizedBox()
                      ],
                      mainAxisSize: MainAxisSize.min,
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
