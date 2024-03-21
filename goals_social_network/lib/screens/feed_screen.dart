import 'package:flutter/material.dart';
import 'package:goals_social_network/screens/goal_tile.dart';
import 'package:goals_social_network/screens/view_friends_screen.dart';
import 'package:provider/provider.dart';

import '../models/goal.dart';
import '../providers/goals_provider.dart';
import '../services/goal_services.dart';
import 'create_goal_screen.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  List<Goal>? goals;

  getGoals() async {
    goals = await GoalServices.getGoals();
    Provider.of<GoalsProvider>(context, listen: false).goals = goals!;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getGoals();
  }

  @override
  Widget build(BuildContext context) {
    return goals == null ? const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    )
    : Scaffold(
        drawer: const Drawer(
            child: ViewFriendsScreen()),
        appBar: AppBar(
          title: Text(
            'My Goals (${Provider.of<GoalsProvider>(context).goals.length})',
            style: const TextStyle(
              color: Colors.white
          )),
          centerTitle: true,
          backgroundColor: const Color.fromRGBO(50, 62, 72, 1.0),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Consumer<GoalsProvider>(
            builder: (context, goalsData, child) {
              return ListView.builder(
                  itemCount: goalsData.goals.length,
                  itemBuilder: (context, index) {
                    Goal goal = goalsData.goals[index];
                    return GoalTile(
                      goal: goal,
                      goalsData: goalsData,
                    );
                  });
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color.fromRGBO(50, 62, 72, 1.0),
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
          onPressed: () {
            showModalBottomSheet(
                context: context,
                builder: (context) {
                  return const CreateGoalScreen();
                });
          },
        ),
      );
  }
}