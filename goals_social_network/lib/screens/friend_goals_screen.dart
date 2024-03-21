import 'package:flutter/material.dart';
import 'package:goals_social_network/screens/goal_tile.dart';
import 'package:goals_social_network/services/friends_services.dart';
import 'package:provider/provider.dart';

import '../models/friend.dart';
import '../models/goal.dart';
import '../providers/goals_provider.dart';

class FriendGoalsScreen extends StatefulWidget {
  final Friend friend;

  const FriendGoalsScreen({Key? key, required this.friend}) : super(key: key);

  @override
  State<FriendGoalsScreen> createState() => _FriendGoalsScreenState();
}

class _FriendGoalsScreenState extends State<FriendGoalsScreen> {
  List<Goal>? goals;

  getGoals() async {
    goals = await FriendsServices.getFriendGoals(widget.friend.id);
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
      appBar: AppBar(
        title: Text(
            'Goals of ${widget.friend.firstName} ${widget.friend.lastName} (${goals?.length})',
            style: const TextStyle(
                color: Colors.white
            )),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(50, 62, 72, 1.0),
        iconTheme: const IconThemeData(color: Colors.white),
        leading: InkWell(
          onTap: () {
            Navigator.pushReplacementNamed(context, '/feed');
          },
          child: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Consumer<GoalsProvider>(
          builder: (context, goalsData, child) {
            return ListView.builder(
                itemCount: goals?.length,
                itemBuilder: (context, index) {
                  Goal? goal = goals?[index];
                  return GoalTile(
                    goal: goal!,
                    goalsData: goalsData,
                  );
                });
          },
        ),
      ),
    );
  }
}