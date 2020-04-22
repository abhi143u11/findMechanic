import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:findmechanice/models/mechanic.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import '../constants.dart';

class Customer with ChangeNotifier {
  List<Mechanic> _mechanic = [];
  double _longitude;
  double _latitude;
  String _address;
  String _userId;
  String _historyId;
  bool _indicator = false;

  Customer(this._userId, this._mechanic);

  bool get indicator {
    return _indicator;
  }

  String get address {
    return address;
  }

  Future<void> getLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.low);
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
              "latitude": _latitude != null ? _latitude : 28.610001,
              "longitude": _longitude != null ? _longitude : 77.230003,
              "type": type.toLowerCase(),
              "toe": toe ? 1 : 0
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
            "latitude": _latitude != null ? _latitude : 28.610001,
            "longitude": _longitude != null ? _longitude : 77.230003,
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
    print("hid $_historyId");
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
        print(indicator);
        notifyListeners();
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      throw e;
    }
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
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      throw e;
    }
    notifyListeners();
  }
}
