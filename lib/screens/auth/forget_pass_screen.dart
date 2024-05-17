import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:chatly_app/utlis/colors.dart';
import 'package:chatly_app/widgets/awesome_widget.dart';
import 'package:chatly_app/widgets/reusable_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:iconsax_flutter/iconsax_flutter.dart';

class ForgetPasswordScreen extends StatefulWidget {
  ForgetPasswordScreen({super.key});

  bool ispassword = true;
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreen();
}

class _ForgetPasswordScreen extends State<ForgetPasswordScreen> {
  TextEditingController emailController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(child: LogoApp()),
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: Text(
                    'Rest Password',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Please Enter Your Email',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                SizedBox(
                  height: 20,
                ),
                CustomTextFormField(
                  validation: (value) {
                    if (value!.isEmpty) {
                      return 'Required Email Field';
                    }
                    return null;
                  },
                  name: 'Email',
                  prefixIcon: Iconsax.direct,
                  editingController: emailController,
                ),
                SizedBox(
                  height: 20,
                ),
                Center(
                    child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        FirebaseAuth.instance
                            .sendPasswordResetEmail(email: emailController.text)
                            .then((value) => AweasomeWidget(
                                  context: context,
                                  dialogType: DialogType.success,
                                  animType: AnimType.rightSlide,
                                  title: 'Send Successfully',
                                  desc:
                                      'Email is sent successfully,check Email',
                                )..show())
                            .onError((error, stackTrace) => AweasomeWidget(
                                context: context,
                                title: 'Error',
                                desc:error.toString(),
                                animType: AnimType.rightSlide,
                                dialogType: DialogType.error));
                      }
                    },
                    child: Text('Send Email'.toUpperCase()),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryColor,
                        padding: const EdgeInsets.all(5.0),
                        textStyle: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12))),
                  ),
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
