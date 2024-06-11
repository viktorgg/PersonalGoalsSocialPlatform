import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/auth_user.dart';
import '../providers/auth_provider.dart';
import '../providers/user_provider.dart';
import '../services/globals.dart';
import '../services/validators.dart';
import '../services/widgets.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final formKey = GlobalKey<FormState>();

  late String _email, _password;

  @override
  Widget build(BuildContext context) {
    AuthProvider auth = Provider.of<AuthProvider>(context);

    final emailField = TextFormField(
      autofocus: false,
      validator: (value) =>
          value!.isEmpty ? "Please enter your email" : validateEmail(value),
      onSaved: (value) => _email = value!,
      decoration: buildInputDecoration("Enter email", Icons.email),
    );

    final passwordField = TextFormField(
      autofocus: false,
      obscureText: true,
      validator: (value) =>
          value!.isEmpty ? "Please enter your password" : null,
      onSaved: (value) => _password = value!,
      decoration: buildInputDecoration("Enter password", Icons.lock),
    );

    var loading = const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircularProgressIndicator(),
        Text("Authenticating ... Please wait")
      ],
    );

    final signUpLabel = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        TextButton(
          style: TextButton.styleFrom(
            padding: const EdgeInsets.only(left: 0.0),
          ),
          child: const Text("Sign up",
              style: TextStyle(fontWeight: FontWeight.w300)),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/signup');
          },
        ),
      ],
    );

    signIn() {
      final form = formKey.currentState;

      if (form!.validate()) {
        form.save();

        final Future<Map<String, dynamic>> successfulMessage =
            auth.signIn(_email, _password);

        successfulMessage.then((response) {
          if (response.containsKey("data")) {
            AuthUser user = response['data'];
            Provider.of<UserProvider>(context, listen: false).setUser(user);
            Navigator.pushReplacementNamed(context, '/feed');
          } else {
            Flushbar(
              title: "Sign in failed!",
              message: response['message'].toString(),
              duration: const Duration(seconds: 3),
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
      child: Form(
        key: formKey,
        child: Column(children: [
          const SizedBox(
            height: 50,
          ),
          const Text(
            "Sign In",
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
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 15.0),
                  label("Email"),
                  const SizedBox(height: 5.0),
                  emailField,
                  const SizedBox(height: 20.0),
                  label("Password"),
                  const SizedBox(height: 5.0),
                  passwordField,
                  const SizedBox(height: 20.0),
                  auth.loggedInStatus == Status.authenticating
                      ? loading
                      : longButtons("Sign in", signIn),
                  const SizedBox(height: 5.0),
                  signUpLabel
                ],
              ),
            ),
          ),
        ]),
      ),
    )));
  }
}
