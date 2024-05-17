import 'dart:io';
import 'dart:ui';

import 'package:chatly_app/firebase/fire_database.dart';
import 'package:chatly_app/firebase/firebase_storage.dart';
import 'package:chatly_app/models/chat_user_model.dart';
import 'package:chatly_app/provider/provider.dart';
import 'package:chatly_app/utlis/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String img='';
  TextEditingController nameController = TextEditingController();
  TextEditingController aboutController = TextEditingController();
  ChatUserModel? me;
  ProviderApp? provider;
  bool nameEdit=false;
  bool aboutEdit=false;
  @override
  void initState() {
    provider?.getUserDetails();
    me=Provider.of<ProviderApp>(context,listen:false).me;
    nameController.text =me?.name??'';
    aboutController.text=me?.about??'';
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Center(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                   img==''?me?.image==""? CircleAvatar(
                      radius: 65,
                    ):CircleAvatar(radius:70,backgroundImage:NetworkImage(me!.image.toString()),):CircleAvatar(radius:70,backgroundImage:FileImage(File(img)),),
                    Positioned(
                        bottom: 0,
                        right: 5,
                        child: IconButton.filled(
                          onPressed: () async{
                            ImagePicker imagePicker=ImagePicker();
                            XFile? image=await imagePicker.pickImage(source: ImageSource.gallery);
                            if(image!=null){
                              setState(() {
                                img=image.path;
                              });
                              await FireStorage().updateProfile(file:File(image.path));
                              print(image.path);
                            }


                          },
                          icon: Icon(Iconsax.edit_copy),
                        ))
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Card(
                  child: ListTile(
                trailing: IconButton(
                  onPressed: (){
                    setState(() {
                      nameEdit=true;
                    });
                  },
                  icon: Icon(Iconsax.edit_copy),
                ),
                title: TextField(
                  enabled: nameEdit,
                  //  autofocus: true,
                  controller: nameController,
                  decoration: InputDecoration(
                      labelText: "Name",
                      hintText: nameController.text,
                      contentPadding: EdgeInsets.all(16),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)))),
                ),
                leading: Icon((Iconsax.user_octagon_copy),),
              )),
              SizedBox(
                height: 15,
              ),
              Card(
                  child: ListTile(
                trailing: IconButton(
                  onPressed: () {
                    setState(() {
                      aboutEdit=true;
                    });
                  },
                  icon: Icon(Iconsax.edit_copy),
                ),
                title: TextField(
                  enabled: aboutEdit,
                  //  autofocus: true,
                  controller: aboutController,
                  decoration: InputDecoration(
                      labelText: "About",
                      contentPadding: EdgeInsets.all(16),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)))),
                ),
                leading: Icon(Iconsax.information_copy),
              )),
              SizedBox(
                height: 15,
              ),
              Card(
                child: ListTile(
                  //  trailing:IconButton(onPressed:(){},icon:Icon(Iconsax.edit_copy),),
                  title: Text('Email'), subtitle: Text(me?.email??''),
                  leading: Icon(Iconsax.direct_copy),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Card(
                  child: ListTile(
                //  trailing:IconButton(onPressed:(){},icon:Icon(Iconsax.edit_copy),),
                title: Text('Joined since'), subtitle: Text(me?.createdAt??''),
                leading: Icon(Iconsax.clock_copy),
              )),
              SizedBox(
                height: 15,
              ),
              Center(
                  child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  onPressed: () {
                    if(nameController.text.isNotEmpty &&aboutController.text.isNotEmpty){
                      FireData().editProfile(name:nameController.text, about: aboutController.text).then((value){
                        setState(() {
                          nameEdit=false;
                          aboutEdit=false;
                        });
                      });
                    }
                  },
                  child: Text('Save'.toUpperCase()),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryColor,
                      padding: const EdgeInsets.all(16.0),
                      textStyle:TextStyle(color:Theme.of(context).colorScheme.onPrimaryContainer) ,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12))),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
