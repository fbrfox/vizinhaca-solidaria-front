class Address {
  final int id;
  final String street;
  final String city;
  final String state;
  final String zipCode;
  final double latitude;
  final double longitude;

  Address({
    required this.id,
    required this.street,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.latitude,
    required this.longitude,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'],
      street: json['street'],
      city: json['city'],
      state: json['state'],
      zipCode: json['zipCode'],
      latitude: json['lat'],
      longitude: json['lng'],
    );
  }
}
