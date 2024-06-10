import 'package:flutter/material.dart';
import 'package:goals_social_network/models/goal_post.dart';
import 'package:goals_social_network/models/goal_post_review.dart';
import 'package:goals_social_network/screens/create_update_post_review_screen.dart';
import 'package:goals_social_network/services/goal_post_review_services.dart';
import 'package:goals_social_network/services/widgets.dart';
import 'package:provider/provider.dart';

import '../models/auth_user.dart';
import '../models/goal.dart';
import '../providers/goal_provider.dart';
import '../services/auth_user_services.dart';
import '../services/globals.dart';

class GoalPostReviewTiles extends StatefulWidget {
  final Goal goal;
  final GoalPost post;
  final List<GoalPostReview> reviews;
  final bool authUserReviewed;
  final ExpansionTileController tileController;

  const GoalPostReviewTiles(
      {super.key,
      required this.goal,
      required this.reviews,
      required this.authUserReviewed,
      required this.post,
      required this.tileController});

  @override
  State<StatefulWidget> createState() {
    return _GoalPostReviewTilesState();
  }
}

class _GoalPostReviewTilesState extends State<GoalPostReviewTiles> {
  AuthUser? _authUser;

  setAuthUser() async {
    AuthUser currentUser = await AuthUserServices.getUser();
    _authUser = currentUser;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    setAuthUser();
  }

  @override
  Widget build(BuildContext context) {
    refreshParentState() {
      Provider.of<GoalProvider>(context, listen: false).setGoal(widget.goal);
      widget.tileController.collapse();
      widget.tileController.expand();
      successActionBar('Review Deleted').show(context);
    }

    deleteReview(int id) async {
      GoalPostReviewServices.deleteGoalPostReview(id)
          .then((value) => refreshParentState());
    }

    return _authUser == null
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : ListView.builder(
            physics: const ScrollPhysics(),
            shrinkWrap: true,
            padding: const EdgeInsets.all(0.0),
            itemCount: widget.reviews.length,
            itemBuilder: (context, i) {
              return Column(children: [
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.grey,
                    //backgroundImage: new NetworkImage(friendsModel.profileImageUrl),
                  ),
                  title: Column(children: [
                    widget.reviews[i].approved
                        ? Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                                '${widget.reviews[i].userOwner.firstName} ${widget.reviews[i].userOwner.lastName} approves the update'))
                        : Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                                '${widget.reviews[i].userOwner.firstName} ${widget.reviews[i].userOwner.lastName} disapproves the update')),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text(timeAgo(widget.reviews[i].updatedAt),
                            style: const TextStyle(
                                fontSize: 12, fontStyle: FontStyle.italic))),
                  ]),
                  subtitle: Text(widget.reviews[i].comment,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  trailing: widget.reviews[i].approved
                      ? const Icon(Icons.thumb_up_alt_outlined,
                          color: Colors.green)
                      : const Icon(Icons.thumb_down_alt_outlined,
                          color: Colors.red),
                ),
                if (widget.authUserReviewed &&
                    widget.reviews[i].userOwner.id == _authUser!.userId)
                  Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shadowColor: baseColor,
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32.0)),
                        minimumSize: const Size(100, 40),
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
                                    bottom: MediaQuery.of(context)
                                        .viewInsets
                                        .bottom),
                                child: CreateUpdatePostReviewScreen(
                                  goal: widget.goal,
                                  oldReview: widget.reviews[i],
                                  post: widget.post,
                                  tileController: widget.tileController,
                                ),
                              );
                            });
                      },
                      child: const Align(
                        alignment: Alignment.center,
                        child: Text("Edit Review"),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shadowColor: baseColor,
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32.0)),
                        minimumSize: const Size(100, 40),
                      ),
                      onPressed: () => deleteReview(widget.reviews[i].id),
                      child: const Align(
                        alignment: Alignment.center,
                        child: Text("Delete Review"),
                      ),
                    )
                  ]),
              ]);
            });
  }
}
