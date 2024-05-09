import 'package:flutter/material.dart';
import 'package:goals_social_network/models/auth_user.dart';
import 'package:goals_social_network/models/goal_post.dart';
import 'package:goals_social_network/screens/review_update_screen.dart';
import 'package:goals_social_network/services/globals.dart';
import 'package:goals_social_network/services/goal_post_services.dart';
import 'package:goals_social_network/services/widgets.dart';

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
  List<GoalPost>? posts;
  late int authUserId;

  getPosts() async {
    posts = await GoalPostServices.getGoalPosts(widget.goal);
    setState(() {});
  }

  setUserId() async {
    AuthUser currentUser = await AuthUserServices.getUser();
    authUserId = currentUser.userId;
  }

  @override
  void initState() {
    super.initState();
    getPosts();
    setUserId();
  }

  @override
  Widget build(BuildContext context) {
    return posts == null
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
                    if (widget.goal.userOwner.id == authUserId) {
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
            body: Column(children: [
              Card(
                elevation: 10,
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.arrow_drop_down_circle),
                      title: Text(
                          '${widget.goal.userOwner.firstName} ${widget.goal.userOwner.lastName}'),
                      subtitle: const Text('Some time ago'),
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
                          color: Colors.black.withOpacity(1), fontSize: 20)),
                ),
              ),
              if (posts!.isEmpty)
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
                Expanded(
                    child: ListView.builder(
                        // controller: scroll,
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(0.0),
                        itemCount: posts?.length,
                        itemBuilder: (context, i) {
                          return ExpansionTile(
                              title: Text('Progress Update #${i + 1}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18)),
                              subtitle: Text(
                                posts![i].description,
                                maxLines: 2, //customize your number of lines
                                overflow: TextOverflow
                                    .ellipsis, //add this to set (...) at the end of sentence
                                //style: Styles.listBodyStyle,
                              ),
                              trailing: Wrap(
                                children: [
                                  Text(
                                    '${posts![i].reviews.length}  ',
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                  const Icon(Icons.feedback_outlined),
                                ],
                              ),
                              onExpansionChanged: (value) {
                                if (value) {}
                              },
                              children: [
                                reviewTile(posts![i].reviews),
                                // MaterialButton(
                                //     onPressed: () {},
                                //     textColor: baseColor,
                                //     child: const Align(
                                //       alignment: Alignment.centerRight,
                                //       child: Column(
                                //         crossAxisAlignment:
                                //             CrossAxisAlignment.start,
                                //         children: [
                                //           Text("Review progress"),
                                //         ],
                                //       ),
                                //     )),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    shadowColor: baseColor,
                                    elevation: 3,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(32.0)),
                                    minimumSize:
                                        const Size(100, 40), //////// HERE
                                  ),
                                  onPressed: () {
                                    showModalBottomSheet(
                                        isScrollControlled: true,
                                        context: context,
                                        builder: (context) {
                                          return FractionallySizedBox(
                                            heightFactor: 0.7,
                                            child: ReviewUpdateScreen(
                                                post: posts![i]),
                                          );
                                        });
                                  },
                                  child: const Align(
                                    alignment: Alignment.center,
                                    child: Text("Review progress update"),
                                  ),
                                ),
                              ]);
                        })),
            ]));
  }
}
