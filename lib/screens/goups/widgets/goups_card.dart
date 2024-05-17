
import 'package:chatly_app/models/group_model.dart';
import 'package:chatly_app/provider/provider.dart';
import 'package:chatly_app/screens/goups/widgets/group_screen.dart';
import 'package:chatly_app/utlis/date_time.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class GroupsCard extends StatefulWidget {
  const GroupsCard({
    super.key, required this.groupModel, required this.nameGroup,
  });
final GroupChatRoomModel groupModel;
final String nameGroup;
  @override
  State<GroupsCard> createState() => _GroupsCardState();
}

class _GroupsCardState extends State<GroupsCard> {
  ProviderApp? providerApp;
  void initState() {
  // Provider.of<ProviderApp>(context,listen: false).nameGroup;
    super.initState();
  }
  Widget build(BuildContext context) {
    providerApp?.nameGroup=widget.groupModel.name;
    return Card(
      child: ListTile(
        onTap:(){
          Navigator.of(context).push(MaterialPageRoute(builder:(context){
           print('name:${providerApp?.nameGroup.toString()}');
            return GroupScreen(groupModel:widget.groupModel,);
          }));
        },
        leading:CircleAvatar(child:Text(style:TextStyle(color:Colors.white),widget.groupModel.name!.isNotEmpty?widget.groupModel.name!.characters.first
              :'',
        ),) ,
        title: Text(providerApp?.nameGroup.toString()??"Name Group"),
        subtitle:Text(widget.groupModel.lastMessage==""?"send first message":widget.groupModel.lastMessage.toString(),maxLines:1,) ,
        trailing:Text(MyDateTime.dateTime(widget.groupModel.lastMessageTime.toString()).toString())

      //  Text(DateFormat.yMEd().format(DateTime(int.parse(widget.groupModel.lastMessageTime.toString()))).toString())
      ),
    );
  }
}
