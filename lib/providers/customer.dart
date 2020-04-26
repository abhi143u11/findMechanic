import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:findmechanice/models/mechanic.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import '../constants.dart';

class Customer with ChangeNotifier {
  double _longitude;
  double _latitude;
  String _userId;
  String _historyId;
  bool _indicator = false;
  List<Mechanic> _mechanic = [];

  Customer(this._userId);
  bool get indicator => _indicator;

  void setIndicator(bool value){
    _indicator = value;
    notifyListeners();
  }


  Future<void> getLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print(position.longitude);
    print(position.latitude);
    _longitude = position.longitude;
    _latitude = position.latitude;
    notifyListeners();
  }

  List<Mechanic> get mechanicList {
    return [..._mechanic];
  }

  Future<List<Mechanic>> getMechanic(String type, bool toe) async {
    if (type == "Auto") type = "autoer";
    print(toe);
    print(type.toLowerCase());
    try {
      final response = await http.post("$BASE_URL/cust/mechalist",
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode(
            {
              'latitude' : _latitude,
              'longitude':_longitude,
              'type': type.toLowerCase(),
              'toe': toe ? 1 : 0
            },
          ));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as List<dynamic>;
        List<Mechanic> data =
            jsonData.map<Mechanic>((json) => Mechanic.fromJson(json)).toList();
        _mechanic = data;
        print(response.body);
        return data;
      } else {
        print("error code is ${response.statusCode}");
      }
    } catch (error) {
      throw error;
    }
    notifyListeners();
  }

  Future<void> selectMechanic(String mechId) async {
    Mechanic data = _mechanic.firstWhere((mech) => mech.id == mechId);
    print("customer app $mechId");
    try {
      final response = await http.post("$BASE_URL/cust/selectmecha",
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode({
            "mechaid": mechId,
            "latitude": _latitude,
            "longitude": _longitude,
            "custid": _userId,
            "type": data.type,
            "time": data.time,
            "distance": data.distance
          }));
      if (response.statusCode == 200) {
        _historyId = jsonDecode(response.body);
        print("tap mechanic his genereted $_historyId");
      } else {
        print("error code is ${response.statusCode}");
      }
    } catch (e) {
      throw e;
    }
    notifyListeners();
  }

  Future<void> checkMechanic() async {
    try {
      final response = await http.post("$BASE_URL/cust/checkpoint",
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode({"historyid": _historyId}));
      if (response.statusCode == 200) {
        print(response.body);
        final jsonData = jsonDecode(response.body);
        _indicator = jsonData[0] == 0 ? false : true;
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      throw e;
    }
    notifyListeners();
  }


  Future<void> handleCancel(String mechId) async {
    print("mechId $mechId");
    try {
      final response = await http.post("$BASE_URL/cust/cencel",
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode({"_id": mechId})); //custId
      if (response.statusCode == 200) {
        print(response.body);
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      throw e;
    }
  }

  Future<void> handleRating(int rating, String mechId) async {
    try {
      final response = await http.post("$BASE_URL/cust/cencel",
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode({
            "_id": mechId,
            "historyid": _historyId,
            "rating": 5
          }));
      if (response.statusCode == 200) {
        print(response.body);
        print(response.statusCode);
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      throw e;
    }
  }

  Future<void> customerDone(String mechId) async {
    print(mechId);
    try {
      final response = await http.post("$BASE_URL/cust/done",
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode({
            "_id": mechId,
          }));
      if (response.statusCode == 200) {
        print(response.statusCode);
        _indicator = false;
        print('cust done called');
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      throw e;
    }
    notifyListeners();
  }
}
