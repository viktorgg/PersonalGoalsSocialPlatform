import 'dart:io';

import 'package:flutter/material.dart';
import 'package:goals_social_network/models/goal.dart';
import 'package:goals_social_network/providers/goal_provider.dart';
import 'package:goals_social_network/providers/progress_posts_provider.dart';
import 'package:goals_social_network/services/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../services/globals.dart';

enum MediaType {
  image,
  video;
}

class CreateGoalPostScreen extends StatefulWidget {
  final Goal goal;

  const CreateGoalPostScreen({super.key, required this.goal});

  @override
  State<StatefulWidget> createState() {
    return _CreateGoalPostScreenState();
  }
}

class _CreateGoalPostScreenState extends State<CreateGoalPostScreen> {
  String _postDescription = "";

  String? imagePath;
  List<XFile> filesAttached = [];

  @override
  Widget build(BuildContext context) {
    createProgressPost() {
      if (_postDescription.isNotEmpty) {
        Provider.of<ProgressPostsProvider>(context, listen: false)
            .createPost(_postDescription, widget.goal);
        Provider.of<GoalProvider>(context, listen: false).setGoal(widget.goal);
        Navigator.of(context).pop(context);
        successActionBar("Progress posted").show(context);
      } else {
        invalidFormBar("Description needs to be filled").show(context);
      }
    }

    return Container(
        padding: const EdgeInsets.all(25.0),
        child: Column(children: [
          const ListTile(
            title: Text(
              'Post new update on your Progress',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 30, color: baseColor, fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
              child: ListView(children: [
            TextField(
              decoration: const InputDecoration(
                  hintText: "Enter description for your progress"),
              autofocus: false,
              onChanged: (val) {
                _postDescription = val;
              },
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: TextButton(
                onPressed: () {
                  showCameraOrGalleyModal();
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: baseColor, width: 2),
                ),
                child: const Text(
                  'Attach Image',
                  style: TextStyle(color: baseColor),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            (imagePath != null)
                ? Image.file(File(imagePath!))
                : const SizedBox.shrink(),
            if (filesAttached.isNotEmpty)
              const Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text('Attached media', textAlign: TextAlign.left),
                  Divider()
                ],
              ),
            ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.all(0.0),
                itemCount: filesAttached.length,
                itemBuilder: (context, i) {
                  return Padding(
                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                      child: SizedBox(
                        height: 40,
                        child: Center(child: Text(filesAttached[i].name)),
                      ));
                }),
            longButtons('Post Progress', createProgressPost)
          ]))
        ]));
  }

  void pickMedia(ImageSource source) async {
    XFile? file;
    file = await ImagePicker().pickImage(source: source);
    if (file != null) {
      imagePath = file.path;
      filesAttached.add(file);
      setState(() {});
    }
  }

  void showCameraOrGalleyModal() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Wrap(direction: Axis.vertical, children: [
              SizedBox(
                  width: 300,
                  child: TextButton(
                    onPressed: () {
                      pickMedia(ImageSource.camera);
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                    style: TextButton.styleFrom(backgroundColor: baseColor),
                    child: const Text(
                      'Camera',
                      style: TextStyle(color: Colors.white),
                    ),
                  )),
              SizedBox(
                width: 300,
                child: TextButton(
                  onPressed: () {
                    pickMedia(ImageSource.gallery);
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                  style: TextButton.styleFrom(backgroundColor: baseColor),
                  child: const Text(
                    'Gallery',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ])
          ]);
        });
  }
}
