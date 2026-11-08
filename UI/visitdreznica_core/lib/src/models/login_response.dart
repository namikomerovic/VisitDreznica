class LoginResponse {
  LoginResponse({
    required this.token,
    required this.expiresAt,
    required this.userId,
    required this.username,
    required this.fullName,
    required this.roles,
  });

  final String token;
  final DateTime expiresAt;
  final int userId;
  final String username;
  final String fullName;
  final List<String> roles;

  String get firstName => fullName.split(' ').first;

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
    token: json['token'] as String,
    expiresAt: DateTime.parse(json['expiresAt'] as String).toLocal(),
    userId: json['userId'] as int,
    username: json['username'] as String,
    fullName: json['fullName'] as String,
    roles: (json['roles'] as List<dynamic>).map((x) => x.toString()).toList(),
  );

  LoginResponse copyWith({String? fullName}) => LoginResponse(
    token: token,
    expiresAt: expiresAt,
    userId: userId,
    username: username,
    fullName: fullName ?? this.fullName,
    roles: roles,
  );
}
