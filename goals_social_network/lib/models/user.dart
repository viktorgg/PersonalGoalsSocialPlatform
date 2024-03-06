class User {
  final int userId;
  final String firstName;
  final String lastName;
  final String email;
  final String token;

  User({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.token
  });

  factory User.fromMap(Map userMap) {
    return User(
        userId: userMap['id'],
        firstName: userMap['firstName'],
        lastName: userMap['lastName'],
        email: userMap['email'],
        token: userMap['token'],
    );
  }
}