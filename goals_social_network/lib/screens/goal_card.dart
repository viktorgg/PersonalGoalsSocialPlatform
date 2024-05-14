import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../models/goal.dart';
import '../providers/goals_owned_provider.dart';
import '../services/globals.dart';

class GoalCard extends StatelessWidget {
  final Goal goal;

  final GoalsOwnedProvider? goalsData;

  const GoalCard({super.key, required this.goal, this.goalsData});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          ListTile(
              leading: const Icon(Icons.arrow_drop_down_circle),
              title: Text(
                  '${goal.userOwner.firstName} ${goal.userOwner.lastName}'),
              subtitle: Text(timeAgo(goal.updatedAt)),
              trailing: ModalRoute.of(context)?.settings.name == '/mygoals'
                  ? IconButton(
                      alignment: Alignment.topRight,
                      onPressed: () {
                        goalsData?.deleteGoal(goal);
                      },
                      icon: const Icon(Icons.close))
                  : const SizedBox.shrink()),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              goal.title,
              style: TextStyle(
                color: Colors.black.withOpacity(0.6),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              goal.description,
              style: TextStyle(
                color: Colors.black.withOpacity(0.6),
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
                style:
                    TextStyle(color: Colors.black.withOpacity(1), fontSize: 15),
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
