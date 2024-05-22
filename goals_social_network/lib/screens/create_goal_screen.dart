import 'package:flutter/material.dart';
import 'package:goals_social_network/providers/goals_owned_provider.dart';
import 'package:provider/provider.dart';

import '../services/globals.dart';
import '../services/widgets.dart';

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
    createGoal() {
      if (_goalTitle.isNotEmpty) {
        Provider.of<GoalsOwnedProvider>(context, listen: false)
            .createGoal(_goalTitle, _goalDescription);
        Navigator.pop(context);
        successActionBar("Goal created!").show(context);
      } else {
        invalidFormBar("Title needs to be filled").show(context);
      }
    }

    return Container(
      padding: const EdgeInsets.all(20),
      child: Wrap(
        runSpacing: 40,
        children: [
          const Center(
            child: Text(
              'Create new Goal',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 30, color: baseColor, fontWeight: FontWeight.w500),
            ),
          ),
          TextField(
            decoration: const InputDecoration(hintText: "Add title"),
            autofocus: false,
            onChanged: (val) {
              _goalTitle = val;
            },
          ),
          TextField(
            decoration: const InputDecoration(hintText: "Add description"),
            autofocus: false,
            onChanged: (val) {
              _goalDescription = val;
            },
          ),
          longButtons('Create Goal', createGoal)
        ],
      ),
    );
  }
}
