// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:testingbloc_course/strings.dart' show enterYourEmail;

class EmailTextField extends StatelessWidget {
  final TextEditingController emailController;
  const EmailTextField({
    Key? key,
    required this.emailController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      autocorrect: false,
      decoration: const InputDecoration(hintText: enterYourEmail),
    );
  }
}
