import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../services/globals.dart';

enum MediaType {
  image,
  video;
}

class CreateGoalScreen extends StatefulWidget {
  const CreateGoalScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _CreateGoalScreenState();
  }
}

class _CreateGoalScreenState extends State<CreateGoalScreen> {
  String _goalTitle = "";
  String _goalDescription = "";

  MediaType _mediaType = MediaType.image;
  String? imagePath;
  List<XFile> filesAttached = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(25.0),
      child: ListView(
        children: [
          const Text(
            'Create new goal',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 30,
              color: baseColor,
            ),
          ),
          TextField(
            decoration: const InputDecoration(hintText: "Enter title"),
            autofocus: true,
            onChanged: (val) {
              _goalTitle = val;
            },
          ),
          TextField(
            decoration: const InputDecoration(hintText: "Enter description"),
            autofocus: true,
            onChanged: (val) {
              _goalDescription = val;
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
          // (imagePath != null)
          //     ? Image.file(File(imagePath!))
          //     : Container(
          //         width: 300,
          //         height: 300,
          //         color: Colors.grey[300]!,
          //       ),
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
          // Align(
          //   alignment: Alignment.bottomCenter,
          //   child: TextButton(
          //     onPressed: () {
          //       if (_goalTitle.isNotEmpty) {
          //         Provider.of<GoalsOwnedProvider>(context, listen: false)
          //             .createGoal(_goalTitle, _goalDescription);
          //         Navigator.pop(context);
          //       }
          //     },
          //     style: TextButton.styleFrom(backgroundColor: baseColor),
          //     child: const Text(
          //       'Add',
          //       style: TextStyle(color: Colors.white),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
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
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return ListView(
            children: [
              TextButton(
                onPressed: () {
                  pickMedia(ImageSource.camera);
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
                },
                style: TextButton.styleFrom(backgroundColor: baseColor),
                child: const Text(
                  'Gallery',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          );
        });
  }
}
