import 'package:flutter/material.dart';
import 'package:goals_social_network/screens/account_drawer_screen.dart';
import 'package:goals_social_network/screens/goal_card.dart';
import 'package:goals_social_network/screens/view_friends_screen.dart';
import 'package:goals_social_network/services/user_services.dart';

import '../models/goal.dart';
import '../models/user.dart';
import '../services/globals.dart';
import '../services/widgets.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  List<Goal>? _goalsFollowed;

  getGoals() async {
    _goalsFollowed = await UserServices.getGoalsFollowed();
    //Provider.of<GoalsProvider>(context, listen: false).goalsOwned = _goalsFollowed!;
    setState(() {});
  }

  List<User> _apiSearchResult = [];

  Future<void> _handleSearch(String input) async {
    _apiSearchResult = await UserServices.findUsersOnNameContaining(input);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getGoals();
  }

  @override
  Widget build(BuildContext context) {
    return _goalsFollowed == null
        ? const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Scaffold(
            drawer: const Drawer(child: ViewFriendsScreen()),
            endDrawer: const Drawer(child: AccountDrawerScreen()),
            appBar: AppBar(
              title: const Text('Feed', style: TextStyle(color: Colors.white)),
              centerTitle: true,
              backgroundColor: baseColor,
              iconTheme: const IconThemeData(color: Colors.white),
              actions: [
                IconButton(
                  icon: const Icon(Icons.search),
                  tooltip: 'Search for users',
                  onPressed: () {
                    _apiSearchResult.clear();
                    showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return Scaffold(
                              body: Column(
                            children: [
                              SizedBox(
                                height: 45,
                                width: 360,
                                child: TextField(
                                    onChanged: _handleSearch,
                                    decoration: buildInputDecoration(
                                        'Search for users', Icons.search)),
                              ),
                              Expanded(
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      padding: const EdgeInsets.all(0.0),
                                      itemCount: _apiSearchResult.length,
                                      itemBuilder: (context, i) {
                                        return ListTile(
                                          leading: const CircleAvatar(
                                            backgroundColor: Colors.grey,
                                            //backgroundImage: new NetworkImage(friendsModel.profileImageUrl),
                                          ),
                                          title: Text(
                                              '${_apiSearchResult[i].firstName} ${_apiSearchResult[i].lastName}'),
                                          onTap: () {
                                            setState(() {});
                                          },
                                          trailing: GestureDetector(
                                            child: const Icon(Icons.settings),
                                            onTapDown: (details) =>
                                                showPopupMenu(context, details,
                                                    _apiSearchResult[i]),
                                          ),
                                        );
                                      })),
                            ],
                          ));
                        });
                  },
                ),
                Builder(
                  builder: (context) => IconButton(
                    icon: const Icon(Icons.account_circle_outlined),
                    tooltip: 'Profile settings',
                    onPressed: () {
                      Scaffold.of(context).openEndDrawer();
                    },
                  ),
                )
              ],
            ),
            body: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: ListView.builder(
                    itemCount: _goalsFollowed?.length,
                    itemBuilder: (context, index) {
                      Goal? goal = _goalsFollowed?[index];
                      return GoalCard(
                        goal: goal!,
                        //goalsData: null,
                      );
                    })),
          );
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
            child: Text('Follow user', style: TextStyle(color: Colors.white))),
      ],
      elevation: 8.0,
    ).then((value) {
      if (value == null) return;
      if (value == "1") {
        UserServices.followUser(friend.id);
      }
    });
  }
}
