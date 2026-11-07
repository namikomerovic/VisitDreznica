class City {
  City({required this.id, required this.name, required this.postalCode, required this.countryId, required this.countryName});

  final int id;
  final String name;
  final String? postalCode;
  final int countryId;
  final String countryName;

  factory City.fromJson(Map<String, dynamic> json) => City(
        id: json['id'] as int,
        name: json['name'] as String,
        postalCode: json['postalCode'] as String?,
        countryId: json['countryId'] as int,
        countryName: json['countryName'] as String,
      );
}