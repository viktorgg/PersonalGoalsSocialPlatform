import 'package:flutter/material.dart';
import 'package:flutter_3d_choice_chip/flutter_3d_choice_chip.dart';
import 'package:goals_social_network/models/goal_post_review.dart';
import 'package:goals_social_network/providers/post_reviews_provider.dart';
import 'package:goals_social_network/services/widgets.dart';
import 'package:provider/provider.dart';

import '../models/goal_post.dart';
import '../services/globals.dart';

class CreateUpdatePostReviewScreen extends StatefulWidget {
  final GoalPost? post;
  final GoalPostReview? oldReview;
  final ExpansionTileController tileController;

  const CreateUpdatePostReviewScreen(
      {super.key,
      required this.tileController,
      required this.oldReview,
      required this.post});

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
    createReview() {
      Provider.of<PostReviewsProvider>(context, listen: false)
          .createReview(_isApproved, _comment, widget.post!);
      widget.tileController.collapse();
      Navigator.of(context, rootNavigator: true).pop();
      successActionBar('Progress Review Posted').show(context);
    }

    updateReview() {
      widget.oldReview?.setComment = _comment;
      widget.oldReview?.setApproved = _isApproved;
      Provider.of<PostReviewsProvider>(context, listen: false)
          .updateReview(widget.oldReview!);
      widget.tileController.collapse();
      Navigator.of(context, rootNavigator: true).pop();
      successActionBar('Review Updated').show(context);
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
