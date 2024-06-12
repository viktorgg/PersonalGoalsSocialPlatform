import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:goals_social_network/screens/invite_code_screen.dart';
import 'package:provider/provider.dart';

import '../models/auth_user.dart';
import '../providers/auth_provider.dart';
import '../providers/user_provider.dart';
import '../services/globals.dart';
import '../services/validators.dart';
import '../services/widgets.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final formKey = GlobalKey<FormState>();

  final passwordFieldController = TextEditingController();
  late String _firstName, _lastName, _email, _password, _phone;

  @override
  void dispose() {
    passwordFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AuthProvider auth = Provider.of<AuthProvider>(context);

    final firstNameField = TextFormField(
      autofocus: false,
      validator: (value) =>
          value!.isEmpty ? "Please enter your first name" : null,
      onSaved: (value) => _firstName = value!,
      decoration: buildInputDecoration(
          "Enter first name", Icons.account_circle_outlined),
    );

    final lastNameField = TextFormField(
      autofocus: false,
      validator: (value) =>
          value!.isEmpty ? "Please enter your last name" : null,
      onSaved: (value) => _lastName = value!,
      decoration: buildInputDecoration(
          "Enter last name", Icons.account_circle_outlined),
    );

    final emailField = TextFormField(
      autofocus: false,
      validator: (value) =>
          value!.isEmpty ? "Please enter your email" : validateEmail(value),
      onSaved: (value) => _email = value!,
      decoration: buildInputDecoration("Enter email", Icons.email),
    );

    final phoneField = TextFormField(
      autofocus: false,
      onSaved: (value) => _phone = value!,
      decoration:
          buildInputDecoration("Enter phone number", Icons.phone_android),
    );

    final passwordField = TextFormField(
      controller: passwordFieldController,
      autofocus: false,
      obscureText: true,
      validator: (value) =>
          value!.isEmpty ? "Please enter your password" : null,
      onSaved: (value) => _password = value!,
      decoration: buildInputDecoration("Enter password", Icons.lock),
    );

    final confirmPasswordField = TextFormField(
      autofocus: false,
      obscureText: true,
      validator: (value) =>
          value!.isEmpty || value != passwordFieldController.text
              ? "Passwords don't match"
              : null,
      onSaved: (value) => _password = value!,
      decoration: buildInputDecoration("Confirm password", Icons.lock),
    );

    var loading = const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircularProgressIndicator(),
        Text("Signing up ... Please wait")
      ],
    );

    final signInLabel = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        TextButton(
          style: TextButton.styleFrom(
            padding: const EdgeInsets.only(left: 0.0),
          ),
          child: const Text("Sign in",
              style: TextStyle(fontWeight: FontWeight.w300)),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/signin');
          },
        ),
      ],
    );

    signUp() {
      final form = formKey.currentState;
      if (form!.validate()) {
        form.save();
        auth
            .signUp(_firstName, _lastName, _email, _phone, _password)
            .then((response) {
          if (response.containsKey("data")) {
            AuthUser user = response['data'];
            Provider.of<UserProvider>(context, listen: false).setUser(user);
            Navigator.pushAndRemoveUntil(
                context,
                CupertinoPageRoute(
                    builder: (context) => const InviteCodeScreen()),
                (route) => false);
          } else {
            Flushbar(
              title: "Registration failed",
              message: response['message'].toString(),
              duration: const Duration(seconds: 10),
            ).show(context);
          }
        });
      } else {
        invalidFormBar("Please complete the form properly").show(context);
      }
    }

    return Scaffold(
        body: SingleChildScrollView(
            child: Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(color: baseColor),
      child: Column(children: [
        const SizedBox(
          height: 50,
        ),
        const Text(
          "Sign Up",
          style: TextStyle(color: Colors.white, fontSize: 25),
        ),
        const SizedBox(
          height: 30,
        ),
        Expanded(
            child: Container(
          padding: const EdgeInsets.all(30.0),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          ),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                label("First Name"),
                const SizedBox(height: 10.0),
                firstNameField,
                const SizedBox(height: 15.0),
                label("Last Name"),
                const SizedBox(height: 10.0),
                lastNameField,
                const SizedBox(height: 15.0),
                label("Email"),
                const SizedBox(height: 5.0),
                emailField,
                const SizedBox(height: 15.0),
                label("Phone number (Optional)"),
                const SizedBox(height: 5.0),
                phoneField,
                const SizedBox(height: 15.0),
                label("Password"),
                const SizedBox(height: 10.0),
                passwordField,
                const SizedBox(height: 15.0),
                label("Confirm Password"),
                const SizedBox(height: 10.0),
                confirmPasswordField,
                const SizedBox(height: 20.0),
                auth.loggedInStatus == Status.authenticating
                    ? loading
                    : longButtons("Sign Up", signUp),
                signInLabel
              ],
            ),
          ),
        ))
      ]),
    )));
  }
}
