import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../models/goal.dart';
import '../providers/goals_owned_provider.dart';

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
            title: Text(goal.title),
            trailing: IconButton(
                alignment: Alignment.topRight,
                onPressed: () {
                  goalsData?.deleteGoal(goal);
                },
                icon: const Icon(Icons.close)),
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
              TextButton(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.only(left: 0.0),
                ),
                onPressed: () {
                  Share.share('check out my website https://example.com',
                      subject: 'Look what I made!');
                },
                child: const Text('ACTION 1'),
              ),
              TextButton(
                onPressed: () {
                  // DO STH
                },
                child: const Text('ACTION 2'),
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
