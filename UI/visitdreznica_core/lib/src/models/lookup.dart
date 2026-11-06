class LookupItem {
  LookupItem({required this.id, required this.name, this.description});

  final int id;
  final String name;
  final String? description;

  factory LookupItem.fromJson(Map<String, dynamic> json) => LookupItem(
        id: json['id'] as int,
        name: json['name'] as String,
        description: json['description'] as String?,
      );
}