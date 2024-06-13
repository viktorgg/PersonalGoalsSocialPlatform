import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:goals_social_network/models/goal_post.dart';
import 'package:goals_social_network/models/goal_post_review.dart';
import 'package:goals_social_network/providers/progress_posts_provider.dart';
import 'package:goals_social_network/screens/create_update_post_review_screen.dart';
import 'package:goals_social_network/screens/goal_post_review_tiles.dart';
import 'package:goals_social_network/services/goal_post_review_services.dart';
import 'package:provider/provider.dart';

import '../models/auth_user.dart';
import '../models/goal.dart';
import '../providers/goal_provider.dart';
import '../services/auth_user_services.dart';
import '../services/globals.dart';
import '../services/widgets.dart';

class GoalProgressPostTile extends StatefulWidget {
  final Goal goal;
  final GoalPost post;
  final ProgressPostsProvider postsProvider;
  final int index;

  const GoalProgressPostTile(
      {super.key,
      required this.post,
      required this.index,
      required this.goal,
      required this.postsProvider});

  @override
  State<StatefulWidget> createState() {
    return _GoalProgressPostTileState();
  }
}

class _GoalProgressPostTileState extends State<GoalProgressPostTile> {
  List<GoalPostReview>? _reviews;
  AuthUser? _authUser;

  ExpansionTileController tileController = ExpansionTileController();

  getReviews() async {
    _reviews = await GoalPostReviewServices.getGoalPostReviews(widget.post);
    setState(() {});
  }

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
    bool authUserReviewedPost() {
      return _reviews!.any((el) => el.userOwner.id == _authUser!.userId);
    }

    int getGoalPostReviewsCount() {
      List<GoalPost> posts =
          Provider.of<GoalProvider>(context, listen: false).goal!.progressPosts;
      for (GoalPost post in posts) {
        if (post.id == widget.post.id) {
          return post.reviews.length;
        }
      }
      return 0;
    }

    return _authUser == null
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Slidable(
            key: ValueKey(widget.index),
            enabled: widget.goal.userOwner.id == _authUser!.userId,
            endActionPane: ActionPane(
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                  onPressed: (BuildContext context) {
                    widget.postsProvider.deletePost(widget.post);
                    successActionBar("Progress post deleted").show(context);
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
                          'Progress Update #${widget.postsProvider.posts.length - widget.index}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18)),
                      const SizedBox(width: 12),
                      Text(timeAgo(widget.post.updatedAt),
                          style: const TextStyle(
                              fontSize: 12, fontStyle: FontStyle.italic))
                    ]),
                    subtitle: Text(
                      widget.post.description,
                      // maxLines: 2,
                      // overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 15),
                    ),
                    trailing: Wrap(
                      children: [
                        Text(
                          '${getGoalPostReviewsCount()}  ',
                          style: const TextStyle(fontSize: 15),
                        ),
                        const Icon(Icons.feedback_outlined),
                      ],
                    ),
                    onExpansionChanged: (value) {
                      if (value) {
                        getReviews();
                        Provider.of<GoalProvider>(context, listen: false)
                            .setGoal(widget.goal);
                      }
                    },
                    children: [
                      _reviews == null
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : Column(children: [
                              GoalPostReviewTiles(
                                goal: widget.goal,
                                reviews: _reviews!,
                                authUserReviewed: authUserReviewedPost(),
                                post: widget.post,
                                tileController: tileController,
                              ),
                              widget.goal.userOwner.id == _authUser!.userId ||
                                      authUserReviewedPost()
                                  ? const SizedBox.shrink()
                                  : ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        shadowColor: baseColor,
                                        elevation: 3,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(32.0)),
                                        minimumSize: const Size(100, 40),
                                      ),
                                      onPressed: () {
                                        showModalBottomSheet(
                                            isScrollControlled: true,
                                            builder: (BuildContext context) {
                                              return SingleChildScrollView(
                                                  child: Container(
                                                      padding: EdgeInsets.only(
                                                          bottom: MediaQuery.of(
                                                                  context)
                                                              .viewInsets
                                                              .bottom),
                                                      child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .fromLTRB(
                                                                  20.0,
                                                                  20.0,
                                                                  20.0,
                                                                  0.0),
                                                          // content padding
                                                          child:
                                                              CreateUpdatePostReviewScreen(
                                                            goal: widget.goal,
                                                            post: widget.post,
                                                            oldReview: null,
                                                            tileController:
                                                                tileController,
                                                          ))));
                                            },
                                            context: context);
                                      },
                                      child: const Align(
                                        alignment: Alignment.center,
                                        child: Text("Review Progress Update"),
                                      ),
                                    ),
                            ])
                    ])));
  }
}
