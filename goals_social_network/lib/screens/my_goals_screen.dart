import 'package:flutter/material.dart';
import 'package:goals_social_network/screens/create_goal_screen.dart';
import 'package:goals_social_network/screens/goal_card.dart';
import 'package:goals_social_network/services/user_services.dart';
import 'package:provider/provider.dart';

import '../models/goal.dart';
import '../providers/goals_owned_provider.dart';
import '../services/auth_user_services.dart';
import '../services/globals.dart';

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
        : Scaffold(
            appBar: AppBar(
              title:
                  const Text('My Goals', style: TextStyle(color: Colors.white)),
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
              actions: [
                IconButton(
                  icon: const Icon(Icons.logout),
                  tooltip: 'Sign out',
                  onPressed: () {
                    AuthUserServices.removeUser();
                    Navigator.pushReplacementNamed(context, '/signin');
                  },
                ),
              ],
            ),
            body: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Consumer<GoalsOwnedProvider>(
                    builder: (context, goalsData, child) {
                  return ListView.builder(
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
