import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../providers/auth_provider.dart';
import '../providers/user_provider.dart';
import '../services/validators.dart';
import '../services/widgets.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final formKey = GlobalKey<FormState>();

  late String _firstName, _lastName, _email, _password;

  get emailField => null;

  @override
  Widget build(BuildContext context) {
    AuthProvider auth = Provider.of<AuthProvider>(context);

    final firstNameField = TextFormField(
      autofocus: false,
      validator: (value) => value!.isEmpty ? "Please enter your first name" : null,
      onSaved: (value) => _firstName = value!,
      decoration: buildInputDecoration("Confirm password", Icons.account_circle_outlined),
    );

    final lastNameField = TextFormField(
      autofocus: false,
      validator: (value) => value!.isEmpty ? "Please enter your last name" : null,
      onSaved: (value) => _lastName = value!,
      decoration: buildInputDecoration("Confirm password", Icons.account_circle_outlined),
    );

    final emailField = TextFormField(
      autofocus: false,
      validator: (value) => value!.isEmpty ? "Please enter your email" : validateEmail(value),
      onSaved: (value) => _email = value!,
      decoration: buildInputDecoration("Confirm password", Icons.email),
    );

    final passwordField = TextFormField(
      autofocus: false,
      obscureText: true,
      validator: (value) {
        if (value!.isEmpty) {
          return "Please enter password";
        } else {
          _password = value;
          return null;
        }
      },
      onSaved: (value) => _password = value!,
      decoration: buildInputDecoration("Confirm password", Icons.lock),
    );

    final confirmPasswordField = TextFormField(
      autofocus: false,
      obscureText: true,
      validator: (value) => value! != _password ? "Passwords don't match!" : null,
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
          child: const Text("Sign in", style: TextStyle(fontWeight: FontWeight.w300)),
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
        auth.signUp(_firstName, _lastName, _email, _password).then((response) {
          if (response.containsKey("data")) {
            User user = response['data'];
            Provider.of<UserProvider>(context, listen: false).setUser(user);
            Navigator.pushReplacementNamed(context, '/feed');
          } else {
            Flushbar(
              title: "Registration failed!",
              message: response['message'].toString(),
              duration: const Duration(seconds: 10),
            ).show(context);
          }
        });
      } else {
        Flushbar(
          title: "Invalid form!",
          message: "Please complete the form properly",
          duration: const Duration(seconds: 10),
        ).show(context);
      }
    }

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset : false,
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(40.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 15.0),
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
        ),
      ),
    );
  }
}