class CreateAddressDto {
  final String street;
  final String city;
  final String state;
  final String zipCode;
  final double latitude;
  final double longitude;

  CreateAddressDto({
    required this.street,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toJson() => {
        'street': street,
        'city': city,
        'state': state,
        'zipCode': zipCode,
        'lat': latitude,
        'lng': longitude,
      };
}
