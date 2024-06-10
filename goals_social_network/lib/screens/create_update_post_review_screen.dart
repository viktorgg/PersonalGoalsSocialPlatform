import 'package:flutter/material.dart';
import 'package:flutter_3d_choice_chip/flutter_3d_choice_chip.dart';
import 'package:goals_social_network/models/goal_post_review.dart';
import 'package:goals_social_network/providers/goal_provider.dart';
import 'package:goals_social_network/services/goal_post_review_services.dart';
import 'package:goals_social_network/services/widgets.dart';
import 'package:provider/provider.dart';

import '../models/goal.dart';
import '../models/goal_post.dart';
import '../services/globals.dart';

class CreateUpdatePostReviewScreen extends StatefulWidget {
  final Goal goal;
  final GoalPost post;
  final GoalPostReview? oldReview;
  final ExpansionTileController tileController;

  const CreateUpdatePostReviewScreen(
      {super.key,
      required this.goal,
      required this.oldReview,
      required this.post,
      required this.tileController});

  @override
  State<StatefulWidget> createState() {
    return _CreateUpdatePostReviewScreenState();
  }
}

class _CreateUpdatePostReviewScreenState
    extends State<CreateUpdatePostReviewScreen> {
  String _comment = "";
  bool _isApproved = true;

  @override
  void initState() {
    super.initState();
    if (widget.oldReview != null) {
      _comment = widget.oldReview!.comment;
    }
    if (widget.oldReview != null) {
      _isApproved = widget.oldReview!.approved;
    }
  }

  @override
  Widget build(BuildContext context) {
    popDrawer() {
      Provider.of<GoalProvider>(context, listen: false).setGoal(widget.goal);
      widget.tileController.collapse();
      widget.tileController.expand();
      Navigator.of(context, rootNavigator: true).pop();
      successActionBar('Review Updated').show(context);
    }

    createReview() async {
      GoalPostReviewServices.createGoalPostReview(
              _isApproved, _comment, widget.post)
          .then((value) => popDrawer());
    }

    updateReview() async {
      widget.oldReview?.setComment = _comment;
      widget.oldReview?.setApproved = _isApproved;
      GoalPostReviewServices.updateGoalPostReview(widget.oldReview!)
          .then((value) => popDrawer());
    }

    return Container(
      padding: const EdgeInsets.all(25.0),
      child: Wrap(
        runSpacing: 40,
        children: [
          Center(
              child: Text(
            widget.oldReview != null
                ? 'Update Progress Review'
                : 'Review Progress',
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 30, color: baseColor, fontWeight: FontWeight.w500),
          )),
          Column(
            children: [
              Center(
                  child: _isApproved
                      ? const Text('Approved')
                      : const Text('Disapproved')),
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
          TextFormField(
            decoration: const InputDecoration(hintText: "Add comment"),
            autofocus: false,
            initialValue: _comment,
            onChanged: (val) {
              _comment = val;
            },
          ),
          widget.oldReview != null
              ? longButtons('Update Review', updateReview)
              : longButtons('Post Review', createReview)
        ],
      ),
    );
  }
}
