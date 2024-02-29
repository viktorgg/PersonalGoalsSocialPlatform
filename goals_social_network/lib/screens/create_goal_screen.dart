import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/goals_data.dart';

class CreateGoalScreen extends StatefulWidget {
  const CreateGoalScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CreateGoalScreenState();
  }
}

class _CreateGoalScreenState extends State<CreateGoalScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String goalTitle = "";
  String goalDescription = "";

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        itemCount: 5,
        itemBuilder: (context, index) => Container(
          padding: const EdgeInsets.all(12.0),
            child: ListView(
              children: [
                const Text(
                  'Create new goal',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.green,
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
                        Provider.of<GoalsData>(context, listen: false)
                            .createGoal(goalTitle, goalDescription);
                        Navigator.pop(context);
                      }
                    },
                    style: TextButton.styleFrom(backgroundColor: Colors.green),
                    child: const Text(
                      'Add',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        separatorBuilder: (context, index) => const SizedBox(
          height: 10,
        )
    );
  }
}