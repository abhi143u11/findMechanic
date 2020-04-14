class Mechanic {
  final String id;
  final String name;
  final String email;
  final int mobile;
  final int distance;
  Mechanic({this.id, this.name, this.email, this.mobile, this.distance});

  factory Mechanic.fromJson(Map<String, dynamic> json) {
    return Mechanic(
        id:json['_id'],
        name: json['name'] as String,
        email: json['email'] as String,
        mobile: json['mobileno'] as int,
        distance: json['distance'] as int);
  }
}
