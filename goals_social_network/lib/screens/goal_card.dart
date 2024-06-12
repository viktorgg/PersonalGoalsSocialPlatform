import 'package:flutter/material.dart';
import 'package:goals_social_network/providers/goals_followed_provider.dart';
import 'package:goals_social_network/services/goal_invite_services.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../models/goal.dart';
import '../providers/goals_owned_provider.dart';
import '../services/globals.dart';
import '../services/widgets.dart';

class GoalCard extends StatelessWidget {
  final Goal goal;

  final GoalsOwnedProvider? goalsData;

  const GoalCard({super.key, required this.goal, this.goalsData});

  @override
  Widget build(BuildContext context) {
    authUserPopupMenu(BuildContext context, TapDownDetails details) {
      showMenu<String>(
        color: baseColor,
        context: context,
        position: RelativeRect.fromLTRB(
            details.globalPosition.dx,
            details.globalPosition.dy,
            details.globalPosition.dx,
            details.globalPosition.dy),
        items: [
          PopupMenuItem<String>(
              padding: const EdgeInsets.all(4),
              value: '1',
              child: Center(
                  child: Text(
                      goal.done == false
                          ? 'Mark as Done'
                          : 'Mark as In Progress',
                      style: const TextStyle(color: Colors.white)))),
          const PopupMenuItem<String>(
              value: '2',
              child: Center(
                  child:
                      Text('Delete', style: TextStyle(color: Colors.white)))),
        ],
        elevation: 8.0,
      ).then((value) {
        if (value == null) return;
        if (value == "1") {
          goal.toggleStatus();
          goalsData?.updateGoal(goal);
          String msg = goal.done == true
              ? "Goal marked as Done"
              : "Goal marked as In Progress";
          successActionBar(msg).show(context);
        } else if (value == "2") {
          goalsData?.deleteGoal(goal);
          successActionBar("Goal deleted").show(context);
        }
      });
    }

    bool authUserFollowsGoal(Goal goal) {
      return Provider.of<GoalsFollowedProvider>(context, listen: false)
          .goalsFollowed
          .any((el) => el.id == goal.id);
    }

    otherUserPopupMenu(BuildContext context, TapDownDetails details) {
      showMenu<String>(
        color: baseColor,
        context: context,
        position: RelativeRect.fromLTRB(
            details.globalPosition.dx,
            details.globalPosition.dy,
            details.globalPosition.dx,
            details.globalPosition.dy),
        items: [
          PopupMenuItem<String>(
              padding: const EdgeInsets.all(4),
              value: '1',
              child: Center(
                  child: Text(authUserFollowsGoal(goal) ? 'Unfollow' : 'Follow',
                      style: const TextStyle(color: Colors.white)))),
          if (ModalRoute.of(context)?.settings.name != '/friendgoals')
            const PopupMenuItem<String>(
                value: '2',
                child: Center(
                    child: Text('View all user goals',
                        style: TextStyle(color: Colors.white)))),
        ],
        elevation: 8.0,
      ).then((value) {
        if (value == null) return;
        if (value == "1") {
          if (authUserFollowsGoal(goal)) {
            Provider.of<GoalsFollowedProvider>(context, listen: false)
                .unfollowGoal(goal);
            successActionBar('Goal unfollowed').show(context);
          } else {
            Provider.of<GoalsFollowedProvider>(context, listen: false)
                .followGoal(goal);
            successActionBar('Goal followed').show(context);
          }
        } else if (value == "2") {
          Navigator.pushReplacementNamed(context, '/friendgoals',
              arguments: goal.userOwner);
        }
      });
    }

    return Card(
      elevation: 10,
      surfaceTintColor: const Color.fromRGBO(223, 153, 240, 1.0),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          ListTile(
              leading: goal.status > -1
                  ? (goal.status == 0
                      ? const Icon(
                          Icons.trending_flat,
                          color: Colors.grey,
                          size: 50,
                        )
                      : const Icon(Icons.trending_up,
                          color: Colors.green, size: 50))
                  : const Icon(Icons.trending_down,
                      color: Colors.red, size: 50),
              title: Text(
                  '${goal.userOwner.firstName} ${goal.userOwner.lastName}'),
              subtitle: Text(timeAgo(goal.updatedAt)),
              trailing: GestureDetector(
                child: const Icon(Icons.more_vert),
                onTapDown: (details) =>
                    ModalRoute.of(context)?.settings.name == '/mygoals'
                        ? authUserPopupMenu(context, details)
                        : otherUserPopupMenu(context, details),
              )),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              goal.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w400,
                  color: Colors.black.withOpacity(0.8)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              goal.description,
              style: TextStyle(
                fontSize: 18,
                color: Colors.black.withOpacity(0.7),
              ),
            ),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.start,
            children: [
              if (ModalRoute.of(context)?.settings.name == '/mygoals')
                TextButton(
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.only(left: 0.0),
                  ),
                  onPressed: () {
                    String inviteCode = generateRandomString(15);
                    Share.share(
                            'Invitation to follow my goal in GoalsApp! Use the invite code:\n $inviteCode',
                            subject:
                                'Invitation to follow my goal in GoalsApp!')
                        .then((value) =>
                            GoalInviteServices.createInvite(inviteCode, goal));
                  },
                  child: const Text('Share'),
                )
              else
                const SizedBox.shrink(),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/goaldetails',
                      arguments: goal);
                },
                child: const Text('View details'),
              ),
              Text(
                'Progress updates: ${goal.progressPosts.length}',
                style: TextStyle(
                    color: Colors.black.withOpacity(0.7), fontSize: 15),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
