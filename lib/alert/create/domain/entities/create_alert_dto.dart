class CreateAlertDto {
  final int categoryId;
  final String description;
  final double lat;
  final double long;
  final String image;

  CreateAlertDto({
    required this.categoryId,
    required this.description,
    required this.lat,
    required this.long,
    required this.image,
  });

  Map<String, dynamic> toJson() {
    return {
      'categoryId': categoryId,
      'description': description,
      'lat': lat,
      'long': long,
      'image': image,
    };
  }
}
