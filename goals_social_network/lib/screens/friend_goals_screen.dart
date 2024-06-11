import 'package:flutter/material.dart';
import 'package:goals_social_network/screens/common_app_bar.dart';
import 'package:goals_social_network/screens/goal_card.dart';
import 'package:goals_social_network/services/user_services.dart';
import 'package:provider/provider.dart';

import '../models/goal.dart';
import '../models/user.dart';
import '../providers/goals_owned_provider.dart';

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
        : CommonAppBar(
            title: 'Friend Goals',
            floatingActionButton: null,
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
                        );
                      });
                },
              ),
            ),
          );
  }
}
