import 'package:flutter/material.dart';
import 'package:goals_social_network/providers/auth_provider.dart';
import 'package:goals_social_network/providers/goals_owned_provider.dart';
import 'package:goals_social_network/providers/user_provider.dart';
import 'package:goals_social_network/screens/feed_screen.dart';
import 'package:goals_social_network/screens/friend_goals_screen.dart';
import 'package:goals_social_network/screens/my_goals_screen.dart';
import 'package:goals_social_network/screens/signin_screen.dart';
import 'package:goals_social_network/screens/signup_screen.dart';
import 'package:goals_social_network/services/auth_user_services.dart';
import 'package:goals_social_network/services/globals.dart';
import 'package:provider/provider.dart';

import 'models/auth_user.dart';
import 'models/user.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Future<AuthUser> getUserData() => AuthUserServices.getUser();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => GoalsOwnedProvider()),
      ],
      child: MaterialApp(
          navigatorKey: NavigationService.navigatorKey,
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
                    } else {
                      AuthUserServices.removeUser();
                    }
                    return const SignInScreen();
                }
              }),
          routes: {
            '/feed': (context) => const FeedScreen(),
            '/signin': (context) => const SignInScreen(),
            '/signup': (context) => const SignUpScreen(),
            '/friendgoals': (context) {
              User arg = ModalRoute.of(context)?.settings.arguments as User;
              return FriendGoalsScreen(
                user: arg,
              );
            },
            '/mygoals': (context) => const MyGoalsScreen(),
          }),
    );
  }
}
