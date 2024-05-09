import 'package:flutter/material.dart';
import 'package:flutter_3d_choice_chip/flutter_3d_choice_chip.dart';
import 'package:goals_social_network/models/goal_post.dart';
import 'package:image_picker/image_picker.dart';

import '../services/globals.dart';
import '../services/goal_post_review_services.dart';

class ReviewUpdateScreen extends StatefulWidget {
  final GoalPost post;

  const ReviewUpdateScreen({super.key, required this.post});

  @override
  State<StatefulWidget> createState() {
    return _ReviewUpdateScreenState();
  }
}

class _ReviewUpdateScreenState extends State<ReviewUpdateScreen> {
  String _comment = "";

  bool _isApproved = true;
  String? imagePath;
  List<XFile> filesAttached = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(25.0),
      child: ListView(
        children: [
          const Text(
            'Review the progress update',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 30,
              color: baseColor,
            ),
          ),
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
            const SizedBox(
              width: 20,
            ),
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
          TextField(
            decoration: const InputDecoration(hintText: "Add comment"),
            autofocus: true,
            onChanged: (val) {
              _comment = val;
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: TextButton(
              onPressed: () {
                GoalPostReviewServices.createGoalPostReview(
                    _isApproved, _comment, widget.post);
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(backgroundColor: baseColor),
              child: const Text(
                'Post',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
