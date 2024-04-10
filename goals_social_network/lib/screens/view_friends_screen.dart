import 'package:flutter/material.dart';
import 'package:goals_social_network/services/user_services.dart';

import '../models/user.dart';
import '../services/globals.dart';

class ViewFriendsScreen extends StatefulWidget {
  const ViewFriendsScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ViewFriendsScreenState();
  }
}

class _ViewFriendsScreenState extends State<ViewFriendsScreen> {
  List<User>? _friends;

  getFriends() async {
    _friends = await UserServices.getFollowingUsers();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getFriends();
  }

  @override
  Widget build(BuildContext context) {
    return _friends == null
        ? const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              title: const Text("Friends"),
            ),
            body: ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.all(0.0),
                itemCount: _friends?.length,
                itemBuilder: (context, i) {
                  return ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Colors.grey,
                      //backgroundImage: new NetworkImage(friendsModel.profileImageUrl),
                    ),
                    title: Text(
                      '${_friends?[i].firstName} ${_friends?[i].lastName}',
                    ),
                    subtitle: Text(_friends![i].email),
                    onTap: () {
                      setState(() {});
                    },
                    trailing: GestureDetector(
                      child: const Icon(Icons.settings),
                      onTapDown: (details) =>
                          showPopupMenu(context, details, _friends![i]),
                    ),
                  );
                }));
  }

  showPopupMenu(BuildContext context, TapDownDetails details, User friend) {
    showMenu<String>(
      color: baseColor,
      context: context,
      position: RelativeRect.fromLTRB(
          details.globalPosition.dx,
          details.globalPosition.dy,
          details.globalPosition.dx,
          details.globalPosition.dy),
      items: [
        const PopupMenuItem<String>(
            value: '1',
            child: Text('View goals', style: TextStyle(color: Colors.white))),
        const PopupMenuItem<String>(
            value: '2',
            child: Text('Unfollow', style: TextStyle(color: Colors.white))),
        const PopupMenuItem<String>(
            value: '3',
            child: Text('View profile', style: TextStyle(color: Colors.white))),
      ],
      elevation: 8.0,
    ).then((value) {
      if (value == null) return;
      if (value == "1") {
        Navigator.pushReplacementNamed(context, '/friendgoals',
            arguments: friend);
      } else if (value == "2") {
        print("2 selected");
      } else {
        print("3 selected");
      }
    });
  }
}
