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

ListView reviewTile(List<GoalPostReview> reviews) {
  return ListView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.all(0.0),
      itemCount: reviews.length,
      itemBuilder: (context, i) {
        return ListTile(
          leading: const CircleAvatar(
            backgroundColor: Colors.grey,
            //backgroundImage: new NetworkImage(friendsModel.profileImageUrl),
          ),
          title: reviews[i].approved
              ? Text(
                  '${reviews[i].userOwner.firstName} ${reviews[i].userOwner.lastName} approves the update:')
              : Text(
                  '${reviews[i].userOwner.firstName} ${reviews[i].userOwner.lastName} disapproves the update:'),
          subtitle: Text(reviews[i].comment),
          trailing: reviews[i].approved
              ? const Icon(Icons.thumb_up_alt_outlined, color: Colors.green)
              : const Icon(Icons.thumb_down_alt_outlined, color: Colors.red),
        );
      });
}
