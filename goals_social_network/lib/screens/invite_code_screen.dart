import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:goals_social_network/services/globals.dart';
import 'package:goals_social_network/services/goal_invite_services.dart';
import 'package:goals_social_network/services/user_services.dart';

import '../services/widgets.dart';

class InviteCodeScreen extends StatefulWidget {
  const InviteCodeScreen({super.key});

  @override
  State<InviteCodeScreen> createState() => _InviteCodeScreenState();
}

class _InviteCodeScreenState extends State<InviteCodeScreen> {
  final formKey = GlobalKey<FormState>();

  late String _code;

  @override
  Widget build(BuildContext context) {
    useCode() {
      final form = formKey.currentState;
      if (form!.validate()) {
        form.save();
        GoalInviteServices.checkInviteExists(_code).then((response) {
          if (response.statusCode == 200) {
            Map responseBody = jsonDecode(response.body);
            UserServices.followGoal(responseBody['goalId']);
            GoalInviteServices.deleteInvite(responseBody['id']).then(
                (value) => Navigator.pushReplacementNamed(context, '/feed'));
            successActionBar('Invitation code used successfully').show(context);
          } else {
            invalidFormBar("Invitation code not valid").show(context);
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
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            const Text(
              "Goal invitation code",
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
            const SizedBox(
              height: 50,
            ),
            Expanded(
              child: Container(
                  padding: const EdgeInsets.all(40.0),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                  ),
                  child: Column(
                    children: [
                      Column(
                        children: [
                          TextFormField(
                            autofocus: false,
                            validator: (value) => value!.isEmpty
                                ? "Enter your invite code"
                                : null,
                            onSaved: (value) => _code = value!,
                            decoration:
                                buildInputDecoration("Enter code", Icons.abc),
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                        ],
                      ),
                      longButtons("Use code", useCode),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          TextButton(
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.only(left: 0.0),
                            ),
                            child: const Text("No code? Continue instead",
                                style: TextStyle(fontWeight: FontWeight.w300)),
                            onPressed: () {
                              Navigator.pushReplacementNamed(context, '/feed');
                            },
                          ),
                        ],
                      )
                    ],
                  )),
            ),
          ],
        ),
      ),
    )));
  }
}
