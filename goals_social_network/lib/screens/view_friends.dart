import 'package:flutter/material.dart';
import 'package:goals_social_network/services/friends_services.dart';

import '../models/friend.dart';

class ViewFriendsScreen extends StatefulWidget {
  const ViewFriendsScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ViewFriendsScreenState();
  }
}

class _ViewFriendsScreenState extends State<ViewFriendsScreen> {
  List<Friend>? friends;

  getFriends() async {
    friends = await FriendsServices.getFriends();
    for (Friend f in friends!) {
      print(f.email);
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getFriends();
  }

  @override
  Widget build(BuildContext context) {
    return friends == null ? const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    )
    : Scaffold(
      appBar: AppBar(
        title: const Text("Friends"),
      ),
      body: ListView.builder(
          shrinkWrap:true,
          padding: const EdgeInsets.all(0.0),

          itemCount: friends?.length,
          itemBuilder: (context, i) {
            return ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.grey,
                //backgroundImage: new NetworkImage(friendsModel.profileImageUrl),
              ),
              title: Text('${friends?[i].firstName} ${friends?[i].lastName}',
              ),
              subtitle: Text(friends![i].email),

              onTap: () {
                setState(() {
                });
              },
            );
          }
      )
    );
  }
}