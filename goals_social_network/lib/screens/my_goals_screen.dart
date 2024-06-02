import 'package:flutter/material.dart';
import 'package:goals_social_network/screens/create_goal_screen.dart';
import 'package:goals_social_network/screens/goal_card.dart';
import 'package:goals_social_network/services/user_services.dart';
import 'package:provider/provider.dart';

import '../models/goal.dart';
import '../providers/goals_owned_provider.dart';
import '../services/globals.dart';
import 'common_app_bar.dart';

class MyGoalsScreen extends StatefulWidget {
  const MyGoalsScreen({super.key});

  @override
  State<MyGoalsScreen> createState() => _MyGoalsScreenState();
}

class _MyGoalsScreenState extends State<MyGoalsScreen> {
  List<Goal>? _goalsOwned;

  getGoals() async {
    _goalsOwned = await UserServices.getGoalsOwned();
    Provider.of<GoalsOwnedProvider>(context, listen: false).goalsOwned =
        _goalsOwned!;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getGoals();
  }

  @override
  Widget build(BuildContext context) {
    return _goalsOwned == null
        ? const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : CommonAppBar(
            title: 'My Goals',
            body: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Consumer<GoalsOwnedProvider>(
                    builder: (context, goalsData, child) {
                  return _goalsOwned!.isEmpty
                      ? const Center(
                          child: Text(
                              'No goals created :(\nCreate a new one from the  +  button below.'))
                      : ListView.builder(
                          itemCount: goalsData.goalsOwned.length,
                          itemBuilder: (context, index) {
                            Goal? goal = goalsData.goalsOwned[index];
                            return GoalCard(
                              goal: goal,
                              goalsData: goalsData,
                            );
                          });
                })),
            floatingActionButton: FloatingActionButton(
              backgroundColor: baseColor,
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
              onPressed: () {
                showModalBottomSheet(
                    isScrollControlled: true,
                    context: context,
                    builder: (context) {
                      return AnimatedPadding(
                        duration: const Duration(milliseconds: 150),
                        curve: Curves.easeOut,
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: const CreateGoalScreen(),
                      );
                    });
              },
            ),
          );
  }
}
