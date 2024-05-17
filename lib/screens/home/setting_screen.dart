import 'package:chatly_app/firebase/fire_database.dart';
import 'package:chatly_app/provider/provider.dart';
import 'package:chatly_app/screens/auth/login_screen.dart';
import 'package:chatly_app/screens/settings/profile_screen.dart';
import 'package:chatly_app/screens/settings/qr_code.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Color pickerColor = Color(0xff443a49);
  Color currentColor = Color(0xff443a49);

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<ProviderApp>(context, listen: false);
   String name=provider.me?.name??'';
    return Scaffold(
      floatingActionButton:FloatingActionButton(
        onPressed:(){
       //   FirebaseMessaging.instance.requestPermission();
       //   FirebaseMessaging.instance.getToken().then((value) =>print(value));
      FireData.sendNotification(chatUser:provider.me!, context: context, msg: 'msg');
         },
      ),
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            ListTile(
              title: Text(name),
              trailing: IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) {
                      return QrCodeScreen();
                    }),
                  );
                },
                icon: Icon(Iconsax.scan_barcode_copy),
              ),
              leading: CircleAvatar(
                radius: 25,
              ),
            ),
            SizedBox(height: 20),
            Card(
              child: ListTile(
                title: Text('Profile'),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) {
                      return ProfileScreen();
                    }),
                  );
                },
                trailing: IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) {
                        return ProfileScreen();
                      }),
                    );
                  },
                  icon: Icon(Iconsax.arrow_right_3_copy),
                ),
                leading: IconButton(
                  onPressed: () {},
                  icon: Icon(Iconsax.user),
                ),
              ),
            ),
            SizedBox(height: 10),
            Card(
              child: ListTile(
                title: Text('Theme'),
                leading: IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          actionsAlignment: MainAxisAlignment.center,
                          actions: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Done'),
                            ),
                          ],
                          content: SingleChildScrollView(
                            child: BlockPicker(
                              pickerColor: Color(provider.mainColor),
                              onColorChanged: (value) {
                                print(value.value.toRadixString(12));
                                provider.changeColor(color: value.value);
                              },
                            ),
                          ),
                        );
                      },
                    );
                  },
                  icon: Icon(Iconsax.color_swatch_copy),
                ),
              ),
            ),
            SizedBox(height: 10),
            Card(
              child: ListTile(
                title: Text('Dark Mode'),
                leading: IconButton(
                  onPressed: () {
                    //  provider.changeMode(dark:);
                  },
                  icon: Icon(Iconsax.color_swatch_copy),
                ),
                trailing: Switch(
                  value: provider.themeMode==ThemeMode.dark,
                  onChanged: (value) {
                    provider.changeMode(dark: value);
                  },
                ),
              ),
            ),
            SizedBox(height: 10),
            InkWell(
              onTap: () async {
                // Ensure user is signed in before attempting to sign out
                if (FirebaseAuth.instance.currentUser != null) {
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) {
                      return LoginScreen();
                    }),
                        (_) => false,
                  );
                }
              },
              child: Card(
                child: ListTile(
                  title: Text('Sign Out'),
                  trailing: IconButton(
                    onPressed: () async {
                      // Ensure user is signed in before attempting to sign out
                      if (FirebaseAuth.instance.currentUser != null) {
                        await FirebaseAuth.instance.signOut();
                      }
                    },
                    icon: Icon(Icons.logout),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}