import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:goals_social_network/models/goal_post.dart';
import 'package:goals_social_network/models/goal_post_review.dart';
import 'package:goals_social_network/providers/post_reviews_provider.dart';
import 'package:goals_social_network/providers/progress_posts_provider.dart';
import 'package:goals_social_network/screens/create_update_post_review_screen.dart';
import 'package:goals_social_network/screens/goal_post_review_tiles.dart';
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

  ExpansionTileController tileController = ExpansionTileController();

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
    getReviews();
    setUserId();
  }

  @override
  Widget build(BuildContext context) {
    bool authUserReviewed() {
      return _reviews!.any((el) => el.userOwner.id == _authUserId);
    }

    return _authUserId == -1 || _reviews == null
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Slidable(
            key: ValueKey(widget.index),
            enabled: widget.userOwner.id == _authUserId,
            endActionPane: ActionPane(
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                  onPressed: (BuildContext context) {
                    Provider.of<ProgressPostsProvider>(context, listen: false)
                        .deletePost(widget.post);
                    successActionBar("Progress post deleted!").show(context);
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
                    controller: tileController,
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
                        return GoalPostReviewTiles(
                            reviewsData: reviewsData,
                            authUserReviewed: authUserReviewed(),
                            tileController: tileController);
                      }),
                      widget.userOwner.id == _authUserId || authUserReviewed()
                          ? const SizedBox.shrink()
                          : ElevatedButton(
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
                                        duration:
                                            const Duration(milliseconds: 150),
                                        curve: Curves.easeOut,
                                        padding: EdgeInsets.only(
                                            bottom: MediaQuery.of(context)
                                                .viewInsets
                                                .bottom),
                                        child: CreateUpdatePostReviewScreen(
                                          post: widget.post,
                                          tileController: tileController,
                                          oldReview: null,
                                        ),
                                      );
                                    });
                              },
                              child: const Align(
                                alignment: Alignment.center,
                                child: Text("Review Progress Update"),
                              ),
                            ),
                    ])));
  }
}
