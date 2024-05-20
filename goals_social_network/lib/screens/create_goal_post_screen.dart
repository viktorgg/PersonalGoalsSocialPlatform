import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:goals_social_network/models/goal.dart';
import 'package:goals_social_network/providers/progress_posts_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

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

  MediaType _mediaType = MediaType.image;
  String? imagePath;
  List<XFile> filesAttached = [];

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(25.0),
        child: Column(
            //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const ListTile(
                title: Text(
                  'Post new update on your Progress',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    color: baseColor,
                  ),
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
                TextButton(
                  onPressed: () {
                    showCameraOrGalleyModal();
                    setState(() {
                      _mediaType = MediaType.image;
                    });
                  },
                  style: TextButton.styleFrom(backgroundColor: baseColor),
                  child: const Text(
                    'Attach Image',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    showCameraOrGalleyModal();
                    setState(() {
                      _mediaType = MediaType.video;
                    });
                  },
                  style: TextButton.styleFrom(backgroundColor: baseColor),
                  child: const Text(
                    'Attach Video',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                (imagePath != null)
                    ? Image.file(File(imagePath!))
                    : Container(
                        width: 300,
                        height: 300,
                        color: Colors.grey[300]!,
                      ),
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
                Align(
                  alignment: Alignment.bottomCenter,
                  child: TextButton(
                    onPressed: () {
                      if (_postDescription.isNotEmpty) {
                        Provider.of<ProgressPostsProvider>(context,
                                listen: false)
                            .createPost(_postDescription, widget.goal);
                        Navigator.pop(context);
                        Flushbar(
                          title: "Action",
                          message: "Progress posted!",
                          isDismissible: true,
                          duration: const Duration(seconds: 5),
                          backgroundColor: baseColor,
                          messageColor: Colors.white,
                          messageSize: 20,
                        ).show(context);
                      }
                    },
                    style: TextButton.styleFrom(backgroundColor: baseColor),
                    child: const Text(
                      'Add',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ]))
            ]));
  }

  void pickMedia(ImageSource source) async {
    XFile? file;
    if (_mediaType == MediaType.image) {
      file = await ImagePicker().pickImage(source: source);
    } else {
      file = await ImagePicker().pickVideo(source: source);
    }
    if (file != null) {
      imagePath = file.path;
      if (_mediaType == MediaType.video) {
        imagePath = await VideoThumbnail.thumbnailFile(
            video: file.path,
            imageFormat: ImageFormat.PNG,
            quality: 100,
            maxWidth: 300,
            maxHeight: 300);
      }
      filesAttached.add(file);
      setState(() {});
    }
  }

  void showCameraOrGalleyModal() {
    showModalBottomSheet<dynamic>(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.start,
                direction: Axis.vertical,
                children: [
                  TextButton(
                    onPressed: () {
                      pickMedia(ImageSource.camera);
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                    style: TextButton.styleFrom(backgroundColor: baseColor),
                    child: const Text(
                      'Camera',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  TextButton(
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
                ],
              )
            ],
          );
        });
  }
}
