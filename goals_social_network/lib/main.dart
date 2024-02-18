import 'package:flutter/material.dart';
import 'package:goals_social_network/screens/create_goal_screen.dart';
import 'package:goals_social_network/task_tile.dart';
import 'package:provider/provider.dart';
import 'package:goals_social_network/models/goals_data.dart';
import 'package:goals_social_network/services/database_services.dart';

import 'models/goal.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GoalsData>(
      create: (context) => GoalsData(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MyHomePage(title: 'Goals social platform'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Goal>? goals;

  getGoals() async {
    goals = await DatabaseServices.getGoals();
    Provider.of<GoalsData>(context, listen: false).goals = goals!;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getGoals();
  }

  @override
  Widget build(BuildContext context) {
    return goals == null
        ? const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    )
        : Scaffold(
      appBar: AppBar(
        title: Text(
          'My goals list (${Provider.of<GoalsData>(context).goals.length})',
        ),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Consumer<GoalsData>(
          builder: (context, tasksData, child) {
            return ListView.builder(
                itemCount: tasksData.goals.length,
                itemBuilder: (context, index) {
                  Goal task = tasksData.goals[index];
                  return TaskTile(
                    task: task,
                    tasksData: tasksData,
                  );
                });
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        child: const Icon(
          Icons.add,
        ),
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: (context) {
                return const CreateGoalScreen();
              });
        },
      ),
    );
  }
}
