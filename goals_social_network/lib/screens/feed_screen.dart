import 'package:flutter/material.dart';
import 'package:goals_social_network/screens/common_app_bar.dart';
import 'package:goals_social_network/screens/goal_card.dart';
import 'package:goals_social_network/services/user_services.dart';

import '../models/goal.dart';
import '../models/user.dart';
import '../services/globals.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  List<Goal>? _goalsFollowed;

  getGoals() async {
    _goalsFollowed = await UserServices.getGoalsFollowed();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getGoals();
  }

  @override
  Widget build(BuildContext context) {
    return _goalsFollowed == null
        ? const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : CommonAppBar(
            title: 'Feed',
            body: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: ListView.builder(
                    itemCount: _goalsFollowed?.length,
                    itemBuilder: (context, index) {
                      Goal? goal = _goalsFollowed?[index];
                      return GoalCard(
                        goal: goal!,
                      );
                    })),
            floatingActionButton: null,
          );
  }

  showPopupMenu(BuildContext context, TapDownDetails details, User friend) {
    showMenu<String>(
      color: baseColor,
      context: context,
      position: RelativeRect.fromLTRB(
          details.globalPosition.dx,
          details.globalPosition.dy,
          details.globalPosition.dx,
          details.globalPosition.dy),
      items: [
        const PopupMenuItem<String>(
            value: '1',
            child: Text('Follow user', style: TextStyle(color: Colors.white))),
      ],
      elevation: 8.0,
    ).then((value) {
      if (value == null) return;
      if (value == "1") {
        UserServices.followUser(friend.id);
      }
    });
  }
}
