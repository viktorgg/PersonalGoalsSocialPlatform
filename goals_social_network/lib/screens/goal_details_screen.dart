import 'package:flutter/material.dart';
import 'package:goals_social_network/models/auth_user.dart';
import 'package:goals_social_network/models/goal_post.dart';
import 'package:goals_social_network/providers/progress_posts_provider.dart';
import 'package:goals_social_network/screens/goal_progress_post_tile.dart';
import 'package:goals_social_network/services/globals.dart';
import 'package:goals_social_network/services/goal_post_services.dart';
import 'package:provider/provider.dart';

import '../models/goal.dart';
import '../services/auth_user_services.dart';

class GoalDetailsScreen extends StatefulWidget {
  final Goal goal;

  const GoalDetailsScreen({super.key, required this.goal});

  @override
  State<StatefulWidget> createState() {
    return _GoalDetailsScreenState();
  }
}

class _GoalDetailsScreenState extends State<GoalDetailsScreen> {
  List<GoalPost>? _posts;
  late int _authUserId;

  getPosts() async {
    _posts = await GoalPostServices.getGoalPosts(widget.goal);
    Provider.of<ProgressPostsProvider>(context, listen: false).posts = _posts!;
    setState(() {});
  }

  setUserId() async {
    AuthUser currentUser = await AuthUserServices.getUser();
    _authUserId = currentUser.userId;
  }

  @override
  void initState() {
    super.initState();
    getPosts();
    setUserId();
  }

  @override
  Widget build(BuildContext context) {
    return _posts == null
        ? const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              title: const Text("Goal details"),
              actions: [
                InkWell(
                  onTap: () {
                    if (widget.goal.userOwner.id == _authUserId) {
                      Navigator.pushReplacementNamed(context, '/mygoals');
                    } else {
                      Navigator.pushReplacementNamed(context, '/feed');
                    }
                  },
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                )
              ],
            ),
            body: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    elevation: 10,
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.arrow_drop_down_circle),
                          title: Text(
                              '${widget.goal.userOwner.firstName} ${widget.goal.userOwner.lastName}'),
                          subtitle: Text(timeAgo(widget.goal.updatedAt)),
                          // trailing: IconButton(
                          //     alignment: Alignment.topRight,
                          //     onPressed: () {
                          //       goalsData?.deleteGoal(goal);
                          //     },
                          //     icon: const Icon(Icons.close)),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            widget.goal.title,
                            style: TextStyle(
                              color: Colors.black.withOpacity(0.6),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            widget.goal.description,
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
                                // Share.share(
                                //     'check out my website https://example.com',
                                //     subject: 'Look what I made!');
                              },
                              child: const Text('Share'),
                            ),
                          ],
                        ),
                        //Image.asset('assets/card-sample-image.jpg'),
                        //Image.asset('assets/card-sample-image-2.jpg'),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: Text("Progress",
                          style: TextStyle(
                              color: Colors.black.withOpacity(1),
                              fontSize: 20)),
                    ),
                  ),
                  if (Provider.of<ProgressPostsProvider>(context).posts.isEmpty)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'This goal currently has no progress updates\n:(',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.6),
                        ),
                      ),
                    )
                  else
                    Expanded(child: Consumer<ProgressPostsProvider>(
                        builder: (context, postsData, child) {
                      return ListView.builder(
                          // controller: scroll,
                          shrinkWrap: true,
                          padding: const EdgeInsets.all(0.0),
                          itemCount: postsData.posts.length,
                          itemBuilder: (context, i) {
                            return GoalProgressPostTile(
                                post: postsData.posts[i],
                                index: i,
                                userOwner: widget.goal.userOwner);
                          });
                    }))
                ]));
  }
}
