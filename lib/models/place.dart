class Place {
  final String id;
  final double lat;
  final double long;
  final String name;
  final String type;
  final String? slogan;
  final String? phone;
  final String? schedule;

  Place({
    required this.id,
    required this.lat,
    required this.long,
    required this.name,
    required this.type,
    this.slogan,
    this.phone,
    this.schedule,
  });

  const Place.empty({
    this.id = "",
    this.lat = 0,
    this.long = 0,
    this.name = "",
    this.type = "",
    this.slogan = "",
    this.phone = "",
    this.schedule = "",
  });
}
