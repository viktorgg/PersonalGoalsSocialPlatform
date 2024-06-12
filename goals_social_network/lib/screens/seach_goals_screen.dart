import 'package:flutter/material.dart';
import 'package:goals_social_network/screens/goal_card.dart';
import 'package:goals_social_network/services/globals.dart';

import '../models/goal.dart';
import '../services/goal_services.dart';
import '../services/widgets.dart';

class SearchGoalsScreen extends StatefulWidget {
  const SearchGoalsScreen({super.key});

  @override
  State<SearchGoalsScreen> createState() => _SearchGoalsScreenState();
}

class _SearchGoalsScreenState extends State<SearchGoalsScreen> {
  List<Goal> _searchResult = [];

  Future<void> _handleSearch(String input) async {
    _searchResult = await GoalServices.filterGoalsOnTitleContaining(input);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(color: baseColor),
          child: Column(children: [
            const SizedBox(
              height: 50,
            ),
            const Text(
              "Search friend goals by title",
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
            const SizedBox(
              height: 50,
            ),
            Expanded(
              child: Container(
                  padding: const EdgeInsets.all(30.0),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                  ),
                  child: Column(
                    children: [
                      Row(children: [
                        SizedBox(
                          height: 45,
                          width: 300,
                          child: TextField(
                              onChanged: _handleSearch,
                              decoration: buildInputDecoration(
                                  'Search for goals', Icons.search)),
                        ),
                        IconButton(
                            onPressed: () {
                              Navigator.pushReplacementNamed(context, '/feed');
                            },
                            icon: const Icon(Icons.arrow_back)),
                      ]),
                      Expanded(
                          child: ListView.builder(
                              shrinkWrap: true,
                              padding: const EdgeInsets.all(0.0),
                              itemCount: _searchResult.length,
                              itemBuilder: (context, i) {
                                return GoalCard(goal: _searchResult[i]);
                              })),
                    ],
                  )),
            ),
          ])),
    ));
  }
}
