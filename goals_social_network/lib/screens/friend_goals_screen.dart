import 'package:flutter/material.dart';
import 'package:goals_social_network/screens/goal_card.dart';
import 'package:goals_social_network/services/user_services.dart';
import 'package:provider/provider.dart';

import '../models/goal.dart';
import '../models/user.dart';
import '../providers/goals_owned_provider.dart';
import '../services/globals.dart';

class FriendGoalsScreen extends StatefulWidget {
  final User user;

  const FriendGoalsScreen({super.key, required this.user});

  @override
  State<FriendGoalsScreen> createState() => _FriendGoalsScreenState();
}

class _FriendGoalsScreenState extends State<FriendGoalsScreen> {
  List<Goal>? _goals;

  getGoals() async {
    _goals = await UserServices.getFollowingUserGoals(widget.user.id);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getGoals();
  }

  @override
  Widget build(BuildContext context) {
    return _goals == null
        ? const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              title: Text(
                  'Goals of ${widget.user.firstName} ${widget.user.lastName} (${_goals?.length})',
                  style: const TextStyle(color: Colors.white)),
              centerTitle: true,
              backgroundColor: baseColor,
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
              child: Consumer<GoalsOwnedProvider>(
                builder: (context, goalsData, child) {
                  return ListView.builder(
                      itemCount: _goals?.length,
                      itemBuilder: (context, index) {
                        Goal? goal = _goals?[index];
                        return GoalCard(
                          goal: goal!,
                          //goalsData: goalsData,
                        );
                      });
                },
              ),
            ),
          );
  }
}
