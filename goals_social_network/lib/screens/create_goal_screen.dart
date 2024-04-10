import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/goals_owned_provider.dart';
import '../services/globals.dart';

class CreateGoalScreen extends StatefulWidget {
  const CreateGoalScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _CreateGoalScreenState();
  }
}

class _CreateGoalScreenState extends State<CreateGoalScreen> {
  String _goalTitle = "";
  String _goalDescription = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      child: ListView(
        children: [
          const Text(
            'Create new goal',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 30,
              color: baseColor,
            ),
          ),
          TextField(
            decoration:
                const InputDecoration(hintText: "Enter the title of your goal"),
            autofocus: true,
            onChanged: (val) {
              _goalTitle = val;
            },
          ),
          TextField(
            decoration: const InputDecoration(
                hintText: "Enter the description of your goal"),
            autofocus: true,
            onChanged: (val) {
              _goalDescription = val;
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: TextButton(
              onPressed: () {
                if (_goalTitle.isNotEmpty) {
                  Provider.of<GoalsOwnedProvider>(context, listen: false)
                      .createGoal(_goalTitle, _goalDescription);
                  Navigator.pop(context);
                }
              },
              style: TextButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(50, 62, 72, 1.0)),
              child: const Text(
                'Add',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
