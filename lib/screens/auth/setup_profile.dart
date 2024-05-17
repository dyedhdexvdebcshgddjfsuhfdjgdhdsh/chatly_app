import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:chatly_app/firebase/firbase_auth.dart';
import 'package:chatly_app/screens/auth/layout_screen.dart';
import 'package:chatly_app/screens/auth/login_screen.dart';
import 'package:chatly_app/utlis/colors.dart';
import 'package:chatly_app/widgets/awesome_widget.dart';
import 'package:chatly_app/widgets/reusable_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class SetupProfile extends StatefulWidget {
  SetupProfile({super.key});

  State<SetupProfile> createState() => _SetupProfile();
}

class _SetupProfile extends State<SetupProfile> {
  TextEditingController nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              icon: Icon(Iconsax.logout_1))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
              ),
              Text(
                'Welcome Sir',
                style: Theme.of(context).textTheme.displayMedium,
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                'Please Enter Your Name',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(
                height: 20,
              ),
              CustomTextFormField(
                validation: (value) {
                  if (value!.isEmpty) {
                    return 'Required Name Field';
                  }
                  return null;
                },
                name: 'Name',
                prefixIcon: Iconsax.user,
                editingController: nameController,
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                  child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  onPressed: () async {
                    await FirebaseAuth.instance.currentUser!
                        .updateDisplayName(nameController.text)
                        .then((value) => FirebaseAuthontication.createUser());
                    AweasomeWidget(
                        context: context,
                        dialogType: DialogType.success,
                        animType: AnimType.rightSlide,
                        title: 'Success',
                        desc: 'Login is Successfully',
                        btnOkOnPress: () {
                          setState(() {
                            Navigator.pop(context);
                          });
                        });
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) {
                      return LayoutApp();
                    }), (route) => false);
                  },
                  child: Text(
                    'Save'.toUpperCase(),
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryColor,
                      padding: const EdgeInsets.all(5),
                      textStyle: const TextStyle(color: kPrimaryColor),
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
