import 'package:chatly_app/utlis/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LogoApp extends StatelessWidget{
  const LogoApp({
    super.key,
  });

  @override
  Widget build(BuildContext context){
    return SvgPicture.asset("assets/svg/images/n_logo.svg",
        height: 150,
        colorFilter: ColorFilter.mode(kPrimaryColor, BlendMode.srcIn));
  }
}

class CustomTextFormField extends StatelessWidget{
  CustomTextFormField(
      {super.key,
      required this.name,
      required this.prefixIcon,
      required this.editingController,
      this.isObscured = false,
      this.suffixIcon,
      this.onPressed, this.validation});

  @override
  final String name;
  final IconData prefixIcon;
  Widget? suffixIcon;
  final String? Function(String?)? validation;
  final TextEditingController editingController;
  final bool isObscured;
  void Function()? onPressed;
  Widget build(BuildContext context) {
    return TextFormField(
      validator:validation,
      obscureText: isObscured,
      controller: editingController,
      decoration: InputDecoration(
        suffixIcon: suffixIcon,
        contentPadding: const EdgeInsets.all(10),
        prefixIcon: Icon(prefixIcon),
        labelText: name,
        fillColor: kWhiteColor,
        filled: true,
        focusedBorder: OutlineInputBorder(

          borderSide: const BorderSide(color: kPrimaryColor),
          borderRadius:
              BorderRadius.circular(12), // Rounded corners when focused
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(12), // Rounded corners
        ),
      ),
    );
  }
}
