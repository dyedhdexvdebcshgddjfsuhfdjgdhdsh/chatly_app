import 'package:chatly_app/firebase/firbase_auth.dart';
import 'package:chatly_app/models/chat_user_model.dart';
import 'package:chatly_app/provider/provider.dart';
import 'package:chatly_app/screens/auth/setup_profile.dart';
import 'package:chatly_app/screens/home/chat_home_screen.dart';
import 'package:chatly_app/screens/home/contacts_screen.dart';
import 'package:chatly_app/screens/home/groups_screen.dart';
import 'package:chatly_app/screens/home/setting_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:provider/provider.dart';

class LayoutApp extends StatefulWidget {
  const LayoutApp({Key? key}) : super(key: key);

  @override
  State<LayoutApp> createState() => _LayoutAppState();
}

class _LayoutAppState extends State<LayoutApp> {
  ChatUserModel? nameProfile;

  @override
  void initState() {
    SystemChannels.lifecycle.setMessageHandler((message)async{
      if(message.toString()=='AppLifecycleState.resumed'){
        await FirebaseAuthontication().updateActivate(online: true);
      }else if(message.toString()=='AppLifecycleState.inactive'||message.toString()=='AppLifecycleState.paused'){
        await FirebaseAuthontication().updateActivate(online: false);
      }
      print(message);
      return  await Future.value(message);
    });
    Provider.of<ProviderApp>(context, listen: false).getUserDetails();
    super.initState();
    nameProfile = Provider.of<ProviderApp>(context, listen: false).me;
   // pageController.dispose();
  }

  int currentIndex = 0;
  PageController pageController=PageController();

  final List<Widget> screens = [
    ChatHomeScreen(),
    GroupHomeScreen(),
    ContactsScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
    //  nameProfile != null && nameProfile!.name!.isNotEmpty ?
      PageView(
        controller: pageController,
        onPageChanged: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        children: screens,
      )
   //        :const Center(child: CircularProgressIndicator()),
      ,
      bottomNavigationBar: NavigationBar(
        elevation: 0,
        selectedIndex: currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            currentIndex = index;
            pageController.jumpToPage(currentIndex);
          });
        },
        destinations: const [
          NavigationDestination(icon: Icon(Iconsax.message), label: 'Chat'),
          NavigationDestination(icon: Icon(Iconsax.messages), label: 'Groups'),
          NavigationDestination(icon: Icon(Iconsax.user), label: 'Contacts'),
          NavigationDestination(icon: Icon(Iconsax.setting), label: 'Settings'),
        ],
      ),
    );
  }
}
