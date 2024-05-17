import 'package:chatly_app/provider/provider.dart';
import 'package:chatly_app/screens/auth/layout_screen.dart';
import 'package:chatly_app/screens/auth/login_screen.dart';
import 'package:chatly_app/screens/auth/setup_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options:DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProviderApp(),
      child: Consumer<ProviderApp>(
        builder: (context, value, child) {
          return MaterialApp(
            themeMode: value.themeMode,
            darkTheme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Color(value.mainColor)),
            ),
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Color(value.mainColor), brightness: Brightness.dark),
            ),
            home: StreamBuilder(
              stream: FirebaseAuth.instance.userChanges(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return FirebaseAuth.instance.currentUser!.displayName!.isEmpty ||
                      FirebaseAuth.instance.currentUser?.displayName == ""
                      ? SetupProfile()
                      : LayoutApp();
                } else {
                  return LoginScreen();
                }
              },
            ),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}


// class Home extends StatefulWidget {
//   const Home({super.key});
//
//   @override
//   State<Home> createState() => _HomeState();
// }
//
// class _HomeState extends State<Home> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar:AppBar(title:Text('chat'),),
//       floatingActionButton:FloatingActionButton(onPressed:(){},child:Icon(Icons.add),),
//       body:Column(
//         mainAxisAlignment:MainAxisAlignment.center,
//         children: [
//           Center(
//             child: Card(
//               child:Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: CircleAvatar(),
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }

