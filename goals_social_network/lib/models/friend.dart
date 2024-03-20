class Friend {
  final String email;
  final String firstName;
  final String lastName;
  //final String profileImageUrl;

  const Friend({required this.firstName, required this.lastName, required this.email});

  factory Friend.fromMap(Map friendMap) {
    return Friend(
      //userId: userMap['id'],
      firstName: friendMap['firstName'],
      lastName: friendMap['lastName'],
      email: friendMap['email'],
    );
  }
}