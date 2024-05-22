import 'package:flutter/material.dart';
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
    showPopupMenu(BuildContext context, TapDownDetails details) {
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
              child:
                  Text('Mark as Done', style: TextStyle(color: Colors.white))),
          const PopupMenuItem<String>(
              value: '2',
              child: Text('Delete', style: TextStyle(color: Colors.white))),
        ],
        elevation: 8.0,
      ).then((value) {
        if (value == null) return;
        if (value == "1") {
          goal.toggle();
          goalsData?.updateGoal(goal);
        } else if (value == "2") {
          goalsData?.deleteGoal(goal);
          successActionBar("Goal deleted!").show(context);
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
            leading: const CircleAvatar(
              backgroundColor: Colors.grey,
            ),
            title:
                Text('${goal.userOwner.firstName} ${goal.userOwner.lastName}'),
            subtitle: Text(timeAgo(goal.updatedAt)),
            trailing: ModalRoute.of(context)?.settings.name == '/mygoals'
                ? GestureDetector(
                    child: const Icon(Icons.more_vert),
                    onTapDown: (details) => showPopupMenu(context, details),
                  )
                : const SizedBox.shrink(),
            // ModalRoute.of(context)?.settings.name == '/mygoals'
            //     ? IconButton(
            //         alignment: Alignment.topRight,
            //         onPressed: () {
            //           goalsData?.deleteGoal(goal);
            //           successActionBar("Goal deleted!").show(context);
            //         },
            //         icon: const Icon(Icons.close))
            //     : const SizedBox.shrink(),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              goal.title,
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
                    Share.share('check out my website https://example.com',
                        subject: 'Look what I made!');
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
          //Image.asset('assets/card-sample-image.jpg'),
          //Image.asset('assets/card-sample-image-2.jpg'),
        ],
      ),
    );
  }
}
