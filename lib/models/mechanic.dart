class Mechanic {
  final String id;
  final String name;
  final String email;
  final String address;
  final int mobile;
  final String type;
  final time;
  final distance;
  final bool organisation;
  final int rating;
  final int chargingfee;
  Mechanic(
      {this.id,
      this.name,
      this.email,
      this.address,
      this.mobile,
      this.time,
      this.distance,
      this.organisation,
      this.rating,
      this.type,
      this.chargingfee});
  factory Mechanic.fromJson(Map<String, dynamic> json) {
    return Mechanic(
        id: json['_id'] as String,
        name: json['name'] as String,
        email: json['email'] as String,
        address: json['address'],
        mobile: json['mobileno'] as int,
        time: json['time'] / 3600,
        distance: json['distance'] / 1000,
        rating: json['rating'] as int,
        type: json['type'] as String,
        chargingfee: json['chargingfee']);
  }
}
