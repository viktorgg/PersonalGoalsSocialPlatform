import 'package:flutter/material.dart';
import 'package:goals_social_network/screens/friend_goals_screen.dart';
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
              trailing: GestureDetector(
                child: const Icon(Icons.settings),
                onTapDown: (details) => showPopupMenu(context, details, friends![i]),
              ),
            );
          }
      )
    );
  }

  showPopupMenu(BuildContext context, TapDownDetails details, Friend friend){
    showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(
        details.globalPosition.dx,
        details.globalPosition.dy,
        details.globalPosition.dx,
        details.globalPosition.dy),
      items: [
        const PopupMenuItem<String>(
            value: '1',
            child: Text('View goals')),
        const PopupMenuItem<String>(
            value: '2',
            child: Text('Unfollow')),
        const PopupMenuItem<String>(
            value: '3',
            child: Text('View profile')),
      ],
      elevation: 8.0,
    ).then((value) {
      if (value == null) return;
      if(value == "1"){
        Navigator.pushReplacementNamed(context, '/friendgoals', arguments: friend);
      }else if(value == "2"){
        print("2 selected");
      }else{
        print("3 selected");
      }
    });
  }
}