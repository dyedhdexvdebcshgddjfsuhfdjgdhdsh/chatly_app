import 'package:chatly_app/firebase/fire_database.dart';
import 'package:chatly_app/models/chat_user_model.dart';
import 'package:chatly_app/models/group_model.dart';
import 'package:chatly_app/models/room_model.dart';
import 'package:chatly_app/provider/provider.dart';
import 'package:chatly_app/screens/chat/chat_screen.dart';
import 'package:chatly_app/screens/chat/chat_widget/chat_card.dart';
import 'package:chatly_app/screens/contact/contact_widget/contact_card.dart';
import 'package:chatly_app/screens/goups/widgets/goups_card.dart';
import 'package:chatly_app/screens/home/groups_screen.dart';
import 'package:chatly_app/widgets/reusable_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({Key? key, required this.groupRoomModel }) : super(key: key);
     final GroupChatRoomModel groupRoomModel;

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreen();
}

class _CreateGroupScreen extends State<CreateGroupScreen> {
   String nameGroup='';
  ProviderApp? providerApp;
  TextEditingController nameGroupController = TextEditingController();
  List<String> members=[];
  List myContacts=[];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [IconButton(onPressed:(){
          setState(() {

          });
        }, icon:Icon(Iconsax.refresh))],
        title: Text('Create Groups'),
      ),
      floatingActionButton:members.isNotEmpty?FloatingActionButton.extended(onPressed: (){
        FireData().createGroup(nameGroup:nameGroupController.text, members:members).then((value){
          widget.groupRoomModel.name!=nameGroupController.text;
          // providerApp?.nameGroup=nameGroupController.text;
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder:(context){
            return GroupHomeScreen();
          }), (route) => false);
          setState(() {
            nameGroupController.clear();
            members=[];
          });
        });
      }, label:Text('Done'),icon:IconButton(icon:Icon(Iconsax.tick_circle_copy),onPressed:(){
         GroupsCard(nameGroup:nameGroup,groupModel:widget.groupRoomModel);
      },),):Container(),
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
                        providerApp?.nameGroup=nameGroupController.text;
                        myContacts=snapshot.data?.data()?['my_users']??[];
                        return StreamBuilder(
                          stream:streamUser,
                          builder:(context,snapshot){
                            List<ChatUserModel> users = snapshot.data?.docs
                                .map((e) => ChatUserModel.fromJson(e.data())).where((element) => element.id!=FireData.myId)
                                .toList()??[];
                            users.sort((a, b) =>a.name!.compareTo(b.name!));
                            return ListView.builder(
                              itemCount: users.length,
                              itemBuilder: (context, index) {
                                return CheckboxListTile(
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
            /*
            ,Expanded(
              child: ListView(children: [
                CheckboxListTile(
                  title:Text('Ahmed'),
                    checkboxShape:CircleBorder(),
                    value:true, onChanged:(value){}) ,
                CheckboxListTile(
                    title:Text('Nasser'),
                    checkboxShape:CircleBorder(),
                    value:false, onChanged:(value){})
              ],),
            )

             */
          ],
        ),
      ),
    );
  }
}
