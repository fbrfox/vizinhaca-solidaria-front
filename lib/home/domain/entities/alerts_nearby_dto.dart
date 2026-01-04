class AlertsNearbyDto {
  final double lat;
  final double long;

  AlertsNearbyDto({
    required this.lat,
    required this.long,
  });

  String toQueryString() {
    return 'lat=${lat.toString()}&lgn=${long.toString()}';
  }
}
