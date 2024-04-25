import 'package:flutter/material.dart';
import 'package:goals_social_network/models/goal_post.dart';
import 'package:goals_social_network/services/goal_post_services.dart';
import 'package:goals_social_network/services/widgets.dart';

import '../models/goal.dart';

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

  getPosts() async {
    posts = await GoalPostServices.getGoalPosts(widget.goal);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getPosts();
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
            ),
            body: ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.all(0.0),
                itemCount: posts?.length,
                itemBuilder: (context, i) {
                  return Column(
                    children: [
                      ExpansionTile(
                          leading: const CircleAvatar(
                            backgroundColor: Colors.grey,
                            //backgroundImage: new NetworkImage(friendsModel.profileImageUrl),
                          ),
                          title: Text('Progress Update #${i + 1}'),
                          subtitle: Text(posts![i].description),
                          children: [
                            reviewTile(posts![i].reviews),
                          ]),
                    ],
                  );
                  // return ListTile(
                  //   leading: const CircleAvatar(
                  //     backgroundColor: Colors.grey,
                  //     //backgroundImage: new NetworkImage(friendsModel.profileImageUrl),
                  //   ),
                  //   title: Text(
                  //     'Progress Update #${i + 1}',
                  //   ),
                  //   subtitle: Text(posts![i].description),
                  //   onTap: () {
                  //     setState(() {});
                  //   },
                  //   trailing: GestureDetector(
                  //     child: const Icon(Icons.settings),
                  //     onTapDown: (details) =>
                  //         //showPopupMenu(context, details, _friends![i]),
                  //   ),
                  // );
                }));
  }
}
