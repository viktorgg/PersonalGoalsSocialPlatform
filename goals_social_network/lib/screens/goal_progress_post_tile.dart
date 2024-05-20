import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:goals_social_network/models/goal_post.dart';
import 'package:goals_social_network/models/goal_post_review.dart';
import 'package:goals_social_network/providers/post_reviews_provider.dart';
import 'package:goals_social_network/providers/progress_posts_provider.dart';
import 'package:goals_social_network/screens/review_progress_screen.dart';
import 'package:goals_social_network/services/goal_post_review_services.dart';
import 'package:provider/provider.dart';

import '../models/auth_user.dart';
import '../models/user.dart';
import '../services/auth_user_services.dart';
import '../services/globals.dart';
import '../services/widgets.dart';

class GoalProgressPostTile extends StatefulWidget {
  final GoalPost post;
  final int index;
  final User userOwner;

  const GoalProgressPostTile(
      {super.key,
      required this.post,
      required this.index,
      required this.userOwner});

  @override
  State<StatefulWidget> createState() {
    return _GoalProgressPostTileState();
  }
}

class _GoalProgressPostTileState extends State<GoalProgressPostTile> {
  List<GoalPostReview>? _reviews;
  int _authUserId = -1;

  getReviews() async {
    _reviews = await GoalPostReviewServices.getGoalPostReviews(widget.post);
    Provider.of<PostReviewsProvider>(context, listen: false).reviews =
        _reviews!;
    setState(() {});
  }

  setUserId() async {
    AuthUser currentUser = await AuthUserServices.getUser();
    _authUserId = currentUser.userId;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    setUserId();
  }

  @override
  Widget build(BuildContext context) {
    return _authUserId == -1
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Slidable(
            key: ValueKey(widget.index),
            endActionPane: ActionPane(
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                  onPressed: (BuildContext context) {
                    Provider.of<ProgressPostsProvider>(context, listen: false)
                        .deletePost(widget.post);
                    Flushbar(
                      title: "Action",
                      message: "Progress post deleted!",
                      isDismissible: true,
                      duration: const Duration(seconds: 5),
                      backgroundColor: baseColor,
                      messageColor: Colors.white,
                      messageSize: 20,
                    ).show(context);
                  },
                  backgroundColor: const Color(0xFFFE4A49),
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                  label: 'Delete',
                ),
              ],
            ),
            child: Theme(
                data: ThemeData().copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                    title: Row(children: [
                      Text(
                          'Progress Update #${Provider.of<ProgressPostsProvider>(context, listen: false).posts.length - widget.index}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18)),
                      const SizedBox(width: 12),
                      Text(timeAgo(widget.post.updatedAt),
                          style: const TextStyle(
                              fontSize: 12, fontStyle: FontStyle.italic))
                    ]),
                    subtitle: Text(
                      widget.post.description,
                      maxLines: 2, //customize your number of lines
                      overflow: TextOverflow
                          .ellipsis, //add this to set (...) at the end of sentence
                      style: const TextStyle(fontSize: 15),
                    ),
                    trailing: Wrap(
                      children: [
                        Text(
                          '${widget.post.reviews.length}  ',
                          style: const TextStyle(fontSize: 15),
                        ),
                        const Icon(Icons.feedback_outlined),
                      ],
                    ),
                    onExpansionChanged: (value) {
                      if (value) {
                        getReviews();
                      }
                    },
                    children: [
                      Consumer<PostReviewsProvider>(
                          builder: (context, reviewsData, child) {
                        return reviewTiles(reviewsData.reviews);
                      }),
                      if (widget.userOwner.id != _authUserId)
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
                                    child: ReviewProgressScreen(
                                      post: widget.post,
                                    ),
                                  );
                                });
                          },
                          child: const Align(
                            alignment: Alignment.center,
                            child: Text("Review progress update"),
                          ),
                        ),
                    ])));
  }
}
