import 'package:flutter/material.dart';
import 'package:goals_social_network/models/auth_user.dart';
import 'package:goals_social_network/models/goal_post.dart';
import 'package:goals_social_network/providers/goal_provider.dart';
import 'package:goals_social_network/providers/progress_posts_provider.dart';
import 'package:goals_social_network/screens/common_app_bar.dart';
import 'package:goals_social_network/screens/goal_progress_post_tile.dart';
import 'package:goals_social_network/services/globals.dart';
import 'package:goals_social_network/services/goal_post_services.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../models/goal.dart';
import '../services/auth_user_services.dart';
import '../services/goal_invite_services.dart';
import 'create_goal_post_screen.dart';

class GoalDetailsScreen extends StatefulWidget {
  final Goal goal;

  const GoalDetailsScreen({super.key, required this.goal});

  @override
  State<StatefulWidget> createState() {
    return GoalDetailsScreenState();
  }
}

class GoalDetailsScreenState extends State<GoalDetailsScreen> {
  List<GoalPost>? _posts;
  AuthUser? _authUser;

  getActualGoalAndPosts() async {
    Provider.of<GoalProvider>(context, listen: false).goal = widget.goal;
    _posts = await GoalPostServices.getGoalPosts(widget.goal);
    Provider.of<ProgressPostsProvider>(context, listen: false).posts = _posts!;
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
    getActualGoalAndPosts();
    setAuthUser();
  }

  @override
  Widget build(BuildContext context) {
    return _posts == null || _authUser == null
        ? const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : CommonAppBar(
            title: 'Goal Details',
            floatingActionButton: null,
            body: Consumer<GoalProvider>(builder: (context, goalData, child) {
              return Container(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Card(
                          elevation: 30,
                          surfaceTintColor:
                              const Color.fromRGBO(223, 153, 240, 1.0),
                          clipBehavior: Clip.antiAlias,
                          child: Column(
                            children: [
                              ListTile(
                                leading: goalData.goal!.status > -1
                                    ? (goalData.goal!.status == 0
                                        ? const Icon(
                                            Icons.trending_flat,
                                            color: Colors.grey,
                                            size: 50,
                                          )
                                        : const Icon(Icons.trending_up,
                                            color: Colors.green, size: 50))
                                    : const Icon(Icons.trending_down,
                                        color: Colors.red, size: 50),
                                title: Text(
                                    '${goalData.goal!.userOwner.firstName} ${goalData.goal!.userOwner.lastName}'),
                                subtitle:
                                    Text(timeAgo(goalData.goal!.updatedAt)),
                                // trailing:
                                // IconButton(
                                //     alignment: Alignment.topRight,
                                //     onPressed: () {
                                //       Navigator.pushReplacementNamed(
                                //           context, '/mygoals');
                                //     },
                                //     icon: const Icon(Icons.arrow_back)),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                  goalData.goal!.title,
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black.withOpacity(0.8)),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                  goalData.goal!.description,
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black.withOpacity(0.7),
                                  ),
                                ),
                              ),
                              ButtonBar(
                                alignment: MainAxisAlignment.start,
                                children: [
                                  if (widget.goal.userOwner.id ==
                                      _authUser?.userId)
                                    TextButton(
                                      style: TextButton.styleFrom(
                                        padding:
                                            const EdgeInsets.only(left: 0.0),
                                      ),
                                      onPressed: () {
                                        String inviteCode =
                                            generateRandomString(15);
                                        Share.share(
                                                'Invitation to follow my goal in GoalsApp! Use the invite code:\n $inviteCode',
                                                subject:
                                                    'Invitation to follow my goal in GoalsApp!')
                                            .then((value) =>
                                                GoalInviteServices.createInvite(
                                                    inviteCode, widget.goal));
                                      },
                                      child: const Text('Share'),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Progress",
                                      style: TextStyle(
                                          color: Colors.black.withOpacity(1),
                                          fontSize: 20)),
                                  if (goalData.goal!.userOwner.id ==
                                      _authUser!.userId)
                                    TextButton(
                                        style: ButtonStyle(
                                            padding: MaterialStateProperty.all<EdgeInsets>(
                                                const EdgeInsets.all(10)),
                                            foregroundColor:
                                                MaterialStateProperty.all<Color>(
                                                    Colors.white),
                                            backgroundColor:
                                                MaterialStateProperty.all<Color>(
                                                    baseColor),
                                            shape: MaterialStateProperty.all<
                                                    RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(10.0)))),
                                        onPressed: () => showModalBottomSheet(
                                            isScrollControlled: true,
                                            context: context,
                                            builder: (context) {
                                              return FractionallySizedBox(
                                                heightFactor: 0.6,
                                                child: CreateGoalPostScreen(
                                                  goal: goalData.goal!,
                                                ),
                                              );
                                            }),
                                        child: const Icon(Icons.add))
                                ]),
                          ),
                        ),
                        if (Provider.of<ProgressPostsProvider>(context)
                            .posts
                            .isEmpty)
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
                                shrinkWrap: true,
                                padding: const EdgeInsets.all(0.0),
                                itemCount: postsData.posts.length,
                                itemBuilder: (context, i) {
                                  return GoalProgressPostTile(
                                    goal: widget.goal,
                                    post: postsData.posts[i],
                                    index: i,
                                    postsProvider: postsData,
                                  );
                                });
                          }))
                      ]));
            }));
  }
}
