class AuthUser {
  final int userId;
  final String firstName;
  final String lastName;
  final String email;
  final String token;

  AuthUser({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.token
  });

  factory AuthUser.fromMap(Map userMap) {
    return AuthUser(
        userId: userMap['id'],
        firstName: userMap['firstName'],
        lastName: userMap['lastName'],
        email: userMap['email'],
        token: userMap['token'],
    );
  }
}