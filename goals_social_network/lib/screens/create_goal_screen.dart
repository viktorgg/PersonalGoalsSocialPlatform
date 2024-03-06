import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/goals_provider.dart';

class CreateGoalScreen extends StatefulWidget {
  const CreateGoalScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CreateGoalScreenState();
  }
}

class _CreateGoalScreenState extends State<CreateGoalScreen> {
  String goalTitle = "";
  String goalDescription = "";

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
                color: Color.fromRGBO(50, 62, 72, 1.0),
              ),
            ),
            TextField(
              decoration: const InputDecoration(
                  hintText: "Enter the title of your goal"),
              autofocus: true,
              onChanged: (val) {
                goalTitle = val;
              },
            ),
            TextField(
              decoration: const InputDecoration(
                  hintText: "Enter the description of your goal"),
              autofocus: true,
              onChanged: (val) {
                goalDescription = val;
              },
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child:  TextButton(
                onPressed: () {
                  if (goalTitle.isNotEmpty) {
                    Provider.of<GoalsProvider>(context, listen: false)
                        .createGoal(goalTitle, goalDescription);
                    Navigator.pop(context);
                  }
                },
                style: TextButton.styleFrom(backgroundColor: const Color.fromRGBO(50, 62, 72, 1.0)),
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