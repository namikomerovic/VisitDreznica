class RegisterRequest {
  RegisterRequest({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.username,
    required this.phoneNumber,
    required this.cityId,
    required this.password,
  });

  final String firstName;
  final String lastName;
  final String email;
  final String username;
  final String? phoneNumber;
  final int cityId;
  final String password;

  Map<String, dynamic> toJson() => {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'username': username,
        'phoneNumber': phoneNumber,
        'cityId': cityId,
        'password': password,
        'passwordConfirmation': password,
      };
}