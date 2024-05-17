import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:chatly_app/firebase/firbase_auth.dart';
import 'package:chatly_app/screens/auth/forget_pass_screen.dart';
import 'package:chatly_app/screens/auth/layout_screen.dart';
import 'package:chatly_app/screens/auth/setup_profile.dart';
import 'package:chatly_app/utlis/colors.dart';
import 'package:chatly_app/widgets/awesome_widget.dart';
import 'package:chatly_app/widgets/loading_widget.dart';
import 'package:chatly_app/widgets/reusable_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:chatly_app/utlis/colors.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  bool ispassword = true;
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
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
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                LogoApp(),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Welcome Back',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  'Material Chat App With Ahmed Assem',
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
                  height: 10,
                ),
                CustomTextFormField(
                    validation: (value) {
                      if (value!.isEmpty) {
                        return 'Required Password Field';
                      }
                      return null;
                    },
                    isObscured: widget.ispassword,
                    name: 'Password',
                    prefixIcon: Iconsax.check,
                    editingController: passwordController,
                    suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            widget.ispassword = !widget.ispassword;
                          });
                        },
                        icon: widget.ispassword == false
                            ? Icon(Icons.remove_red_eye)
                            : Icon(Icons.visibility_off_sharp))),
                SizedBox(height: 20),
                Row(
                  children: [
                    Spacer(),
                    GestureDetector(
                      child: Text(
                        'Forget Password',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      onTap: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return ForgetPasswordScreen();
                        }));
                      },
                    )
                  ],
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
                        FirebaseAuth.instance.signInWithEmailAndPassword(
                                email: emailController.text,
                                password: passwordController.text)
                            .then((value)async {
                               FirebaseAuthontication.user=value.user;
                              value.user!.displayName!=null?
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(builder: (context) {
                                    return LayoutApp();
                                  }), (route) => false):
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(builder: (context) {
                                    return SetupProfile();
                                  }), (route) => false);
                        return print('done');
                        }
                                ).onError((error, stackTrace) => AweasomeWidget(
                                context: context,
                                dialogType: DialogType.error,
                                animType: AnimType.rightSlide,
                                title: 'Error',
                                desc: '${error.toString()}',
                                btnCancelOnPress: () {
                                  setState(() {
                                    Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(builder: (context) {
                                      return LoginScreen();
                                    }), (route) => false);
                                  });
                                }));
                      }
                    },
                    child: Text('Login'.toUpperCase()),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryColor,
                        padding: const EdgeInsets.all(16.0),
                        textStyle: const TextStyle(color: kPrimaryColor),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12))),
                  ),
                )),
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                    width: MediaQuery.of(context).size.width,
                    child: OutlinedButton(
                      onPressed: () {
                        FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                                email: emailController.text,
                                password: passwordController.text)
                            .then((value) async {
                          await FirebaseAuthontication.createUser();
                          return AweasomeWidget(
                              context: context,
                              dialogType: DialogType.success,
                              animType: AnimType.rightSlide,
                              title: 'Success',
                              desc: 'Created User Successfully',
                              btnOkOnPress: () {
                                Future.delayed(
                                    Duration(
                                      seconds: 2,
                                    ), () {
                                  setState(() {
                                    Center(
                                      child: CircularProgressIndicator(),
                                    );
                                    Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(builder: (context) {
                                      return LoginScreen();
                                    }), (route) => false);
                                  });
                                });
                              });
                        }).onError((error, stackTrace) {
                          return AweasomeWidget(
                              btnCancelOnPress: () {
                                // Navigator.of(context).pushAndRemoveUntil(
                                //     MaterialPageRoute(builder: (context) {
                                //   return LoginScreen();
                                // }), (route) => false);
                                Navigator.pop(context);
                              },
                              context: context,
                              dialogType: DialogType.error,
                              animType: AnimType.rightSlide,
                              title: 'Error',
                              desc: error.toString(),
                              btnOkOnPress: () {
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(builder: (context) {
                                  return LoginScreen();
                                }), (route) => false);
                              });
                        });
                      },
                      child: Text('Create Account'.toUpperCase(),
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onBackground,
                          )),
                      style: OutlinedButton.styleFrom(
                        //  backgroundColor: kPrimaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
