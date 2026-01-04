class Alert {
  final int id;
  final String category;
  final String description;
  final String createAt;
  final String categoryIcon;
  final double lat;
  final double lng;
  final int userId;
  final String? userName;

  Alert({
    required this.id,
    required this.category,
    required this.description,
    required this.createAt,
    required this.categoryIcon,
    required this.lat,
    required this.lng,
    required this.userId,
    this.userName,
  });

  factory Alert.fromJson(Map<String, dynamic> json) {
    return Alert(
      id: json['id'] ?? 0,
      category: json['category'] ?? '',
      description: json['description'] ?? '',
      createAt: json['createAt'] ?? '',
      categoryIcon: json['categoryIcon'] ?? '',
      lat: double.parse(json['lat'] as String), // Converte para double
      lng: double.parse(json['long'] as String), // Converte para double
      userId: json['userId'] ?? 0,
      userName: json['userName'] ?? '',
    );
  }
}
