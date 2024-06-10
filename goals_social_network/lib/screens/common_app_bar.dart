import 'package:flutter/material.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:goals_social_network/screens/view_friends_screen.dart';

import '../models/user.dart';
import '../services/globals.dart';
import '../services/user_services.dart';
import '../services/widgets.dart';
import 'account_drawer_screen.dart';

class CommonAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final Widget body;
  final FloatingActionButton? floatingActionButton;

  const CommonAppBar({
    super.key,
    required this.body,
    required this.title,
    required this.floatingActionButton,
  });

  @override
  State<StatefulWidget> createState() {
    return _CommonAppBarState();
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CommonAppBarState extends State<CommonAppBar> {
  List<User> _apiSearchResult = [];

  bool isFeedCurrentRoute() {
    return ModalRoute.of(context)?.settings.name == '/feed' ? true : false;
  }

  Future<void> _handleSearch(String input) async {
    _apiSearchResult = await UserServices.findUsersOnNameContaining(input);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
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
              child:
                  Text('Follow user', style: TextStyle(color: Colors.white))),
        ],
        elevation: 8.0,
      ).then((value) {
        if (value == null) return;
        if (value == "1") {
          UserServices.followUser(friend.id);
        }
      });
    }

    return Scaffold(
      drawer: const Drawer(child: ViewFriendsScreen()),
      endDrawer: const Drawer(child: AccountDrawerScreen()),
      appBar: AppBar(
        title: Text(widget.title, style: const TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: baseColor,
        iconTheme: const IconThemeData(color: Colors.white),
        leadingWidth: 120,
        leading: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.people_outline),
                tooltip: 'My friends',
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
            ),
            Flexible(
                child: IconButton(
              icon: isFeedCurrentRoute()
                  ? const GlowIcon(
                      Icons.dynamic_feed,
                      glowColor: Colors.white,
                      size: 30,
                      blurRadius: 20,
                    )
                  : const Icon(Icons.dynamic_feed),
              tooltip: 'Show feed',
              onPressed: () {
                if (!isFeedCurrentRoute()) {
                  Navigator.pushReplacementNamed(context, '/feed');
                }
              },
            ))
          ],
        ),
        actions: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
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
                                        onTapDown: (details) => showPopupMenu(
                                            context,
                                            details,
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
          ])
        ],
      ),
      body: widget.body,
      floatingActionButton: widget.floatingActionButton,
    );
  }
}
