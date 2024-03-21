class Friend {
  final int id;
  final String email;
  final String firstName;
  final String lastName;
  //final String profileImageUrl;

  const Friend({required this.id, required this.firstName, required this.lastName, required this.email});

  factory Friend.fromMap(Map friendMap) {
    return Friend(
      id: friendMap['id'],
      firstName: friendMap['firstName'],
      lastName: friendMap['lastName'],
      email: friendMap['email'],
    );
  }
}