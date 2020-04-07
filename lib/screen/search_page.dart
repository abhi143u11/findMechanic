import 'dart:convert';

import 'package:findmechanice/constants.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  double _longitude;
  double _latitude;
  String _cityName;

  void getLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    _longitude = position.longitude;
    _latitude = position.latitude;
    List<Placemark> placemark =
        await Geolocator().placemarkFromCoordinates(52.2165157, 6.9437819);
//    print(placemark[0].name);
  }

  Future<void> getMechanicList() async {
    try {
        final response = await http.post("$BASE_URL/cust/mechalist",
            headers: {
              'Content-Type': 'application/json',
            },
            body: json.encode({
              "longitude": _longitude,
              "latitude": _latitude,
              "type": "car",
              "toe": 0
            }));
        if (response.statusCode == 200) {
          print(response.body);
        } else {
          print(response.statusCode);
          print('err');
        }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocation();
    getMechanicList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: TextField(
      decoration: InputDecoration(
          border: InputBorder.none, hintText: 'Enter a search term'),
    ));
  }
}
