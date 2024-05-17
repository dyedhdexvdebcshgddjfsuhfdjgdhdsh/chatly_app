import 'package:chatly_app/firebase/fire_database.dart';
import 'package:chatly_app/models/chat_user_model.dart';
import 'package:chatly_app/models/group_model.dart';
import 'package:chatly_app/widgets/reusable_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class EditGroupScreen extends StatefulWidget {
  const EditGroupScreen({Key? key, required this.groupModel}) : super(key: key);

  final GroupChatRoomModel groupModel;
  @override
  State<EditGroupScreen> createState() => _EditGroupScreen();
}

class _EditGroupScreen extends State<EditGroupScreen> {
  TextEditingController nameGroupController = TextEditingController();
List members=[];
List myContacts=[];
  @override
  void initState() {
    nameGroupController.text=widget.groupModel.name!;
    super.initState();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Groups'),
      ),
      floatingActionButton:FloatingActionButton.extended(onPressed: (){
        FireData.editGroup(groupId:widget.groupModel.id!, name:nameGroupController.text, members: members).then((value){
         setState(() {
           widget.groupModel.members!.addAll(members);
         });
          Navigator.of(context).pop();
        });
      }, label:Text('Done'),icon:Icon(Iconsax.tick_circle_copy),),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              children: [
                Stack(
                  children: [
                    CircleAvatar(radius: 30),
                    Positioned(
                      bottom:5,
                      right:5,
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.camera_alt),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: CustomTextFormField(
                    editingController: nameGroupController,
                    name:nameGroupController.text,
                    prefixIcon: Iconsax.people,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
            SizedBox(height:30,)
            ,Divider(color: Colors.white,),
            SizedBox(height:18,) ,
            Row(
              children: [
                Text('Members',style:Theme.of(context).textTheme.bodyLarge,),
                Spacer(),
                Text(members.length.toString(),style:Theme.of(context).textTheme.bodyLarge,),
              ],
            ) ,
            SizedBox(height: 10,) ,
            Expanded(
                child: StreamBuilder(
                    stream:FireData.firestore.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).snapshots() ,
                    // getStream() ,
                    builder: (context, snapshot) {
                      Stream<QuerySnapshot<Map<String, dynamic>>?>? streamUser=FireData.firestore.collection('users').where('id', whereIn: myContacts.isEmpty?['']:myContacts).snapshots();

                      if (snapshot.hasData) {
                        myContacts=snapshot.data?.data()?['my_users']??[];
                        return StreamBuilder(
                          stream:streamUser,
                          builder:(context,snapshot){
                            List<ChatUserModel> users = snapshot.data?.docs
                                .map((e) => ChatUserModel.fromJson(e.data())).where((element) => element.id!=FireData.myId).where((element) =>!widget.groupModel.members!.contains(element.id))
                                .toList()??[];
                            users.sort((a, b) =>a.name!.compareTo(b.name!));
                            return ListView.builder(
                              itemCount: users.length,
                              itemBuilder: (context, index) {
                                return   CheckboxListTile(
                                    title:Text(users[index].name!),
                                    checkboxShape:CircleBorder(),
                                    value:members.contains(users[index].id),
                                    onChanged:(value){
                                      setState(() {
                                        if(value==true){
                                          members.add(users[index].id!);
                                        }else{
                                          members.remove(users[index].id!);
                                        }
                                      });
                                    }) ;
                              },
                            );
                          } ,
                        );
                      }else{
                        return CircularProgressIndicator();
                      }
                    }
                ))
          ],
        ),
      ),
    );
  }
}
