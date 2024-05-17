import 'package:chatly_app/firebase/firbase_auth.dart';
import 'package:chatly_app/firebase/fire_database.dart';
import 'package:chatly_app/main.dart';
import 'package:chatly_app/models/chat_user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProviderApp extends ChangeNotifier {

  ThemeMode themeMode = ThemeMode.system;
  int mainColor = 0xff9400D3;
   ChatUserModel? me;
   String? nameGroup;
  getUserDetails()async{
    String myUserId= FireData.myId;
    await FireData.firestore.collection('users').doc(myUserId).get().then((value){
      me=ChatUserModel.fromJson(value.data()!);
    });
    FirebaseMessaging.instance.requestPermission();
    FirebaseMessaging.instance.getToken().then((value){
      if(value!=null){
        me!.pushToken!=value;
       FirebaseAuthontication.getToken(token: value);
      }
    });
    notifyListeners();
  }
  changeMode({required bool dark}) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    themeMode = dark ? ThemeMode.dark : ThemeMode.light;
    sharedPreferences.setBool('dark', themeMode == ThemeMode.dark);
    notifyListeners();
  }

  changeColor({required int color}) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    mainColor = color;
    sharedPreferences.setInt('color', mainColor);
    notifyListeners();
  }

  getDataPref() async {
    final SharedPreferences sharedPreferences =
    await SharedPreferences.getInstance();
    bool isDark = sharedPreferences.getBool('dark') ?? false;
    themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    mainColor = sharedPreferences.getInt('color')??0xff9400D3;
    notifyListeners();
  }
}
