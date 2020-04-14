import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:findmechanice/models/mechanic.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import '../constants.dart';

class Customers with ChangeNotifier {
  List<Mechanic> _mechanic = [];
  double _longitude;
  double _latitude;

  Future<void> getLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print(position);
    _longitude = position.longitude;
    _latitude = position.latitude;
    List<Placemark> placemark =
        await Geolocator().placemarkFromCoordinates(52.2165157, 6.9437819);
    notifyListeners();
  }

  Future<void> getMechanic(String type) async {
    try {
      final response = await http.post("$BASE_URL/cust/mechalist",
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode({
            "longitude": 11.499931,
            "latitude": 48.149853,
            "type": "car",
            "toe": 0
          }));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as List<dynamic>;
        List<Mechanic> data =
            jsonData.map<Mechanic>((json) => Mechanic.fromJson(json)).toList();
        _mechanic = data;
      } else {
        print("error code is ${response.statusCode}");
      }
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }

  Future<String> selectMechanic(String mechId) async {
    try {
      final response = await http.post("$BASE_URL/cust/selectmecha",
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode({
            "mechaid": "5e90b40e19edb07968c1069f",
            "longitude": _longitude,
            "latitude": _latitude,
            "custid": "5e8cc5d8b7d0bf0a8027de36",
            "type": "car",
            "time": 0,
            "distance": 1
          }));
      if (response.statusCode == 200) {
        print(response.body);
        return jsonDecode(response.body);
      } else {
        print("error code is ${response.statusCode}");
      }
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }

  Future<bool> checkMechanic(String historyId) async {
    print(historyId);
    print('hid');
    try {
      final response = await http.post("$BASE_URL/cust/checkpoint",
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode({"historyid": historyId}));
      if (response.statusCode == 200) {
        bool checkValue = response.body[1].toString() == '1' ? true : false;
        return checkValue;
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      throw e;
    }
  }

  Future<void> handleCancel(String historyId) async {
    try {
      final response = await http.post("$BASE_URL/cust/cencel",
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode({"_id": "5e8368cab49e582d24c11e51"}));
      if (response.statusCode == 200) {
        print(response.body);
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      throw e;
    }
  }

  List<Mechanic> get mechanicList {
    return [..._mechanic];
  }
}
