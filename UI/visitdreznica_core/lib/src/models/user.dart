class AppUser {
  AppUser({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.username,
    required this.phoneNumber,
    required this.cityId,
    required this.cityName,
    required this.isActive,
    required this.createdAt,
    required this.hasImage,
    required this.roles,
  });

  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String username;
  final String? phoneNumber;
  final int cityId;
  final String cityName;
  final bool isActive;
  final DateTime createdAt;
  final bool hasImage;
  final List<String> roles;

  String get fullName => '$firstName $lastName';

  factory AppUser.fromJson(Map<String, dynamic> json) => AppUser(
        id: json['id'] as int,
        firstName: json['firstName'] as String,
        lastName: json['lastName'] as String,
        email: json['email'] as String,
        username: json['username'] as String,
        phoneNumber: json['phoneNumber'] as String?,
        cityId: json['cityId'] as int,
        cityName: json['cityName'] as String,
        isActive: json['isActive'] as bool,
        createdAt: DateTime.parse(json['createdAt'] as String),
        hasImage: json['hasImage'] as bool,
        roles: (json['roles'] as List<dynamic>).map((x) => x.toString()).toList(),
      );
}

class UserUpsertRequest {
  UserUpsertRequest({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.username,
    required this.phoneNumber,
    required this.cityId,
    required this.roleIds,
    required this.isActive,
    this.password,
  });

  final String firstName;
  final String lastName;
  final String email;
  final String username;
  final String? phoneNumber;
  final int cityId;
  final List<int> roleIds;
  final bool isActive;
  final String? password;

  Map<String, dynamic> toInsertJson() => {
        ..._common(),
        'password': password,
        'passwordConfirmation': password,
      };

  Map<String, dynamic> toUpdateJson() => {
        ..._common(),
        'newPassword': password,
        'newPasswordConfirmation': password,
      };

  Map<String, dynamic> _common() => {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'username': username,
        'phoneNumber': phoneNumber,
        'cityId': cityId,
        'roleIds': roleIds,
        'isActive': isActive,
      };
}

class UserSearch {
  UserSearch({this.text, this.roleId, this.isActive});

  final String? text;
  final int? roleId;
  final bool? isActive;

  Map<String, dynamic> toQuery({required int page, required int pageSize}) {
    final trimmed = text?.trim();

    return {
      'page': page,
      'pageSize': pageSize,
      if (trimmed != null && trimmed.isNotEmpty) 'text': trimmed,
      if (roleId != null) 'roleId': roleId,
      if (isActive != null) 'isActive': isActive,
    };
  }
}