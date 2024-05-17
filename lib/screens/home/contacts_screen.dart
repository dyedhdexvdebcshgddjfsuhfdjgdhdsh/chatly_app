import 'package:chatly_app/firebase/fire_database.dart';
import 'package:chatly_app/models/chat_user_model.dart';
import 'package:chatly_app/screens/contact/contact_widget/contact_card.dart';
import 'package:chatly_app/widgets/reusable_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});

  @override
  State<ContactsScreen> createState() => _ContactsScreen();
}

class _ContactsScreen extends State<ContactsScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController searchController = TextEditingController();

  bool isSearched = true;
  List myContacts = [];

  static void errorData(String error){
    ErrorWidget('$error');
  }

 // Stream<QuerySnapshot<Map<String, dynamic>>>?getUserStream(){
     Future<void> getMyContacts() async {
      final contacts = await FireData.firestore
          .collection('users')
          .doc(FireData.myId)
          .get();
      if (contacts.exists) {
        setState(() {
          myContacts = List<String>.from(contacts.data()?['my_users'] ?? []);
        });
      }
      print(myContacts);
    }
  Stream<QuerySnapshot<Map<String, dynamic>>>?getUserStreamLoading(){
       Future.delayed(Duration(seconds:1),(){
         return CircularProgressIndicator();
       });
  }

  @override

  void initState() {
    getMyContacts();
    super.initState();
  }

  Widget build(BuildContext context) {
    Stream<QuerySnapshot<Map<String, dynamic>>> streamUser=FireData.firestore.collection('users').where('id', whereIn: myContacts.isEmpty?['']:myContacts).snapshots();
  //  Stream<QuerySnapshot<Map<String, dynamic>>>? streamError=FireData.firestore.collection('users').where('id', whereIn: myContacts).snapshots().handleError(getUserStreamLoading());

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showBottomSheet(
              context: context,
              builder: (context) {
                return Container(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Enter Friend Contact',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            Spacer(),
                            IconButton.filled(
                                onPressed: () {}, icon: Icon(Iconsax.barcode))
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: CustomTextFormField(
                            editingController: emailController,
                            name: 'Email',
                            prefixIcon: Iconsax.direct,
                          ),
                        ),
                        Center(
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.04,
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: ElevatedButton(
                              onPressed: () async {
                                await FireData()
                                    .addContact(email: emailController.text)
                                    .then((value) {
                                  setState(() {
                                    emailController.text = "";
                                  });
                                  Navigator.pop(context);
                                });
                              },
                              child: Text('Add Contact'),
                              style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.all(4),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4)),
                                  backgroundColor: Theme.of(context)
                                      .colorScheme
                                      .primaryContainer),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              });
        },
        child: Icon(Iconsax.user_cirlce_add),
      ),
      appBar: AppBar(
        actions: [
          isSearched
              ? Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: IconButton.filledTonal(
                      onPressed: () {
                        setState(() {
                          isSearched = false;
                          searchController.text='';
                        });
                      },
                      icon: Icon(Iconsax.close_circle)),
                )
              : Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: IconButton.filledTonal(
                      onPressed: () {
                        setState(() {
                          isSearched = true;
                        });
                      },
                      icon: Icon(Iconsax.search_normal_1_copy)),
                )
        ],
        title: isSearched
            ? Row(
                children: [
                  Expanded(
                      child: TextField(
                        onChanged:(value){
                          setState(() {
                            searchController.text=value;
                          });
                        },
                    autofocus: true,
                    controller: searchController,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(16),
                        hintText: 'Search by Name',
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20)))),
                  )),
                ],
              )
            : Text('Contacts'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
         //   List contacts=FireData.firestore.collection('users').where('id', whereIn: myContacts)
            Expanded(
              child: StreamBuilder(
                stream:FireData.firestore.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).snapshots() ,
               // getStream() ,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    myContacts=snapshot.data?.data()?['my_users']??[];
                    return StreamBuilder(
                      stream:streamUser,
                      builder:(context,snapshot){
                         List<ChatUserModel> users = snapshot.data?.docs
                            .map((e) => ChatUserModel.fromJson(e.data())).where((element) =>element.name!.toLowerCase().contains(searchController.text.toLowerCase()))
                            .toList()??[];
                         users.sort((a, b) =>a.name!.compareTo(b.name!));
                        return ListView.builder(
                          itemCount: users.length,
                          itemBuilder: (context, index) {
                            return ContactCard(chatUserModel:users[index],);
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
