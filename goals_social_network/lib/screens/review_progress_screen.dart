import 'package:flutter/material.dart';
import 'package:flutter_3d_choice_chip/flutter_3d_choice_chip.dart';
import 'package:goals_social_network/models/goal_post.dart';
import 'package:goals_social_network/providers/post_reviews_provider.dart';
import 'package:provider/provider.dart';

import '../services/globals.dart';

class ReviewProgressScreen extends StatefulWidget {
  final GoalPost post;

  const ReviewProgressScreen({super.key, required this.post});

  @override
  State<StatefulWidget> createState() {
    return _ReviewProgressScreenState();
  }
}

class _ReviewProgressScreenState extends State<ReviewProgressScreen> {
  String _comment = "";

  bool _isApproved = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(25.0),
      child: Wrap(
        runSpacing: 40,
        children: [
          const Center(
              child: Text(
            'Review Progress',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 30,
              color: baseColor,
            ),
          )),
          Column(
            children: [
              const Center(child: Text('Approve or disapprove')),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                ChoiceChip3D(
                  style: ChoiceChip3DStyle.blue,
                  selected: _isApproved == true,
                  onUnSelected: () {},
                  height: 50,
                  onSelected: () {
                    setState(() {
                      _isApproved = true;
                    });
                  },
                  child: const Icon(Icons.thumb_up, color: Colors.white),
                ),
                const SizedBox(width: 20),
                ChoiceChip3D(
                  style: ChoiceChip3DStyle.red,
                  selected: _isApproved == false,
                  onSelected: () {
                    setState(() {
                      _isApproved = false;
                    });
                  },
                  onUnSelected: () {},
                  height: 50,
                  child: const Icon(Icons.thumb_down, color: Colors.white),
                ),
              ]),
            ],
          ),
          TextField(
            decoration: const InputDecoration(hintText: "Add comment"),
            autofocus: false,
            onChanged: (val) {
              _comment = val;
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: TextButton(
              onPressed: () {
                Provider.of<PostReviewsProvider>(context, listen: false)
                    .createReview(_isApproved, _comment, widget.post);
                Navigator.of(context, rootNavigator: true).pop();
              },
              style: TextButton.styleFrom(backgroundColor: baseColor),
              child: const Text(
                'Post review',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
