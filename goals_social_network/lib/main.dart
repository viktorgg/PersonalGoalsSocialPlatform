import 'package:flutter/material.dart';
import 'package:goals_social_network/providers/auth_provider.dart';
import 'package:goals_social_network/providers/goals_provider.dart';
import 'package:goals_social_network/providers/user_provider.dart';
import 'package:goals_social_network/screens/feed_screen.dart';
import 'package:goals_social_network/screens/friend_goals_screen.dart';
import 'package:goals_social_network/screens/signin_screen.dart';
import 'package:goals_social_network/screens/signup_screen.dart';
import 'package:goals_social_network/services/user_services.dart';
import 'package:provider/provider.dart';

import 'models/friend.dart';
import 'models/user.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Future<User> getUserData() => UserServices.getUser();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => GoalsProvider()),
      ],
      child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: FutureBuilder(
              future: getUserData(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return const CircularProgressIndicator();
                  default:
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (snapshot.data?.token == null) {
                      return const SignInScreen();
                    }
                    else {
                      UserServices.removeUser();
                    }
                    return const SignInScreen();
                }
              }),
          routes: {
            '/feed': (context) => const FeedScreen(),
            '/signin': (context) => const SignInScreen(),
            '/signup': (context) => const SignUpScreen(),
            '/friendgoals': (context) {
              Friend arg = ModalRoute.of(context)?.settings.arguments as Friend;
              return FriendGoalsScreen(friend: arg,);
            }
          }),
    );
  }
}
