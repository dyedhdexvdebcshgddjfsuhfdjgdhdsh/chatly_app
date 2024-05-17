import 'package:chatly_app/firebase/fire_database.dart';
import 'package:chatly_app/models/chat_user_model.dart';
import 'package:chatly_app/screens/chat/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
class ContactCard extends StatefulWidget {
  const ContactCard({
    super.key, required this.chatUserModel
  });
final ChatUserModel chatUserModel;
  @override

  State<ContactCard> createState() => _ContactCardState();
}

class _ContactCardState extends State<ContactCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading:CircleAvatar(),
        subtitle:Text(widget.chatUserModel.about!,maxLines: 1,overflow:TextOverflow.ellipsis),
        title:Text('${widget.chatUserModel.name}',),
        trailing:IconButton(onPressed:(){
          List<String> members=[widget.chatUserModel.id!, FireData.myId]..sort((a, b) =>a.compareTo(b),);

          FireData.createRoom(email: widget.chatUserModel.email!).then((value){
            Navigator.of(context).push(MaterialPageRoute(builder:(context){
              return ChatScreen(chatRoomId:members.toString(),chatUserModel:widget.chatUserModel);
            }));
          });

        } ,icon:Icon(Iconsax.message_copy),),
      ),
    );
  }
}
