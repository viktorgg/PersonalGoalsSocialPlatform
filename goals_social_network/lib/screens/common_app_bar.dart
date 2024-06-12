import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:goals_social_network/screens/seach_goals_screen.dart';

import '../services/globals.dart';
import 'account_drawer_screen.dart';
import 'invite_code_screen.dart';

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
  bool isFeedCurrentRoute() {
    return ModalRoute.of(context)?.settings.name == '/feed' ? true : false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                icon: const Icon(Icons.add_card),
                tooltip: 'Use invitation code',
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => const InviteCodeScreen()),
                      (route) => false);
                },
              ),
            ),
            Flexible(
                child: IconButton(
              icon: isFeedCurrentRoute()
                  ? const GlowIcon(
                      Icons.home_filled,
                      glowColor: Colors.white,
                      blurRadius: 10,
                    )
                  : const Icon(Icons.home_filled),
              tooltip: 'Show followed goals',
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
            if (ModalRoute.of(context)?.settings.name == '/feed')
              IconButton(
                icon: const Icon(Icons.search),
                tooltip: 'Search for users',
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => const SearchGoalsScreen()),
                      (route) => false);
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
