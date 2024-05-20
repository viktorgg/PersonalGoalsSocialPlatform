import 'package:flutter/material.dart';
import 'package:goals_social_network/models/goal_post_review.dart';

import 'globals.dart';

MaterialButton longButtons(String title, Function() action,
    {Color color = const Color(0xfff063057), Color textColor = Colors.white}) {
  return MaterialButton(
    onPressed: action,
    textColor: textColor,
    color: color,
    height: 45,
    minWidth: 600,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10))),
    child: SizedBox(
      width: double.infinity,
      child: Text(
        title,
        textAlign: TextAlign.center,
      ),
    ),
  );
}

label(String title) => Text(title);

InputDecoration buildInputDecoration(String hintText, IconData icon) {
  return InputDecoration(
    prefixIcon: Icon(icon, color: baseColor),
    hintText: hintText,
    contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
  );
}

ListView reviewTiles(List<GoalPostReview> reviews) {
  return ListView.builder(
      physics: const ScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.all(0.0),
      itemCount: reviews.length,
      itemBuilder: (context, i) {
        return ListTile(
          leading: const CircleAvatar(
            backgroundColor: Colors.grey,
            //backgroundImage: new NetworkImage(friendsModel.profileImageUrl),
          ),
          title: Column(children: [
            reviews[i].approved
                ? Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                        '${reviews[i].userOwner.firstName} ${reviews[i].userOwner.lastName} approves the update'))
                : Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                        '${reviews[i].userOwner.firstName} ${reviews[i].userOwner.lastName} disapproves the update')),
            Align(
                alignment: Alignment.centerLeft,
                child: Text(timeAgo(reviews[i].updatedAt),
                    style: const TextStyle(
                        fontSize: 12, fontStyle: FontStyle.italic))),
          ]),
          subtitle: Text(reviews[i].comment,
              style: const TextStyle(fontWeight: FontWeight.bold)),
          trailing: reviews[i].approved
              ? const Icon(Icons.thumb_up_alt_outlined, color: Colors.green)
              : const Icon(Icons.thumb_down_alt_outlined, color: Colors.red),
        );
      });
}
