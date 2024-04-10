class User {
  final int id;
  final String email;
  final String firstName;
  final String lastName;
  final String phone;
  //final String profileImageUrl;

  const User({required this.id, required this.firstName, required this.lastName, required this.email, required this.phone});

  factory User.fromMap(Map userMap) {
    return User(
      id: userMap['id'],
      firstName: userMap['firstName'],
      lastName: userMap['lastName'],
      email: userMap['email'],
      phone: userMap['phone'],
    );
  }
}