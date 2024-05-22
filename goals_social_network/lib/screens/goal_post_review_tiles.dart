import 'package:flutter/material.dart';
import 'package:goals_social_network/providers/post_reviews_provider.dart';
import 'package:goals_social_network/screens/create_update_post_review_screen.dart';
import 'package:goals_social_network/services/widgets.dart';

import '../models/auth_user.dart';
import '../services/auth_user_services.dart';
import '../services/globals.dart';

class GoalPostReviewTiles extends StatefulWidget {
  final PostReviewsProvider reviewsData;
  final bool authUserReviewed;
  final ExpansionTileController tileController;

  const GoalPostReviewTiles(
      {super.key,
      required this.reviewsData,
      required this.authUserReviewed,
      required this.tileController});

  @override
  State<StatefulWidget> createState() {
    return _GoalPostReviewTilesState();
  }
}

class _GoalPostReviewTilesState extends State<GoalPostReviewTiles> {
  int _authUserId = -1;

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
        : ListView.builder(
            physics: const ScrollPhysics(),
            shrinkWrap: true,
            padding: const EdgeInsets.all(0.0),
            itemCount: widget.reviewsData.reviews.length,
            itemBuilder: (context, i) {
              return Column(children: [
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.grey,
                    //backgroundImage: new NetworkImage(friendsModel.profileImageUrl),
                  ),
                  title: Column(children: [
                    widget.reviewsData.reviews[i].approved
                        ? Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                                '${widget.reviewsData.reviews[i].userOwner.firstName} ${widget.reviewsData.reviews[i].userOwner.lastName} approves the update'))
                        : Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                                '${widget.reviewsData.reviews[i].userOwner.firstName} ${widget.reviewsData.reviews[i].userOwner.lastName} disapproves the update')),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                            timeAgo(widget.reviewsData.reviews[i].updatedAt),
                            style: const TextStyle(
                                fontSize: 12, fontStyle: FontStyle.italic))),
                  ]),
                  subtitle: Text(widget.reviewsData.reviews[i].comment,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  trailing: widget.reviewsData.reviews[i].approved
                      ? const Icon(Icons.thumb_up_alt_outlined,
                          color: Colors.green)
                      : const Icon(Icons.thumb_down_alt_outlined,
                          color: Colors.red),
                ),
                if (widget.authUserReviewed &&
                    widget.reviewsData.reviews[i].userOwner.id == _authUserId)
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
                                  tileController: widget.tileController,
                                  oldReview: widget.reviewsData.reviews[i],
                                  post: null,
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
                      onPressed: () {
                        widget.reviewsData
                            .deleteReview(widget.reviewsData.reviews[i]);
                        widget.tileController.collapse();
                        successActionBar('Review Deleted').show(context);
                      },
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
