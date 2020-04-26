import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String _userId;
  String _name;
  String _mobile;
  String _email;
  String _errormsg;

  String get name {
    return _name;
  }

  String get email {
    return _email;
  }

  String get mobile {
    return _mobile;
  }

  String get errorMsg {
    return _errormsg;
  }

  bool get isAuth {
    return _userId != null;
  }

  String get userId {
    return _userId;
  }

  Future<void> login(
      String email, String password, BuildContext context) async {
    try {
      final response = await http.post(
        "$BASE_URL/login",
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(
          {
            "email": email,
            "password": password,
            "type": "cust",
          },
        ),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _userId = data[0]['_id'];
        _name = data[0]['name'];
        _email = data[0]['email'];
        final prefs = await SharedPreferences.getInstance();
        final userData = json.encode(
          {'userId': _userId, 'name': _name, 'email': _email},
        );
        prefs.setString('userData', userData);
      } else {
        print(response.statusCode);
        print(response.body);
        _errormsg = jsonDecode(response.body);
      }
    } catch (e) {
      print(e);
      print('error');
      throw e;
    }
    notifyListeners();
  }

  Future<void> signup(String name, String email, String mobile, String password,
      BuildContext context) async {
    try {
      final response = await http.post("$BASE_URL/cust/newuser",
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode({
            "name": name,
            "email": email,
            "mobileno": mobile,
            "password": password
          }));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _userId = data['_id'];
        _name = data['name'];
        _email = data['email'];
        final prefs = await SharedPreferences.getInstance();
        final userData = json.encode(
          {'userId': _userId, 'name': _name, 'email': _email},
        );
        prefs.setString('userData', userData);
        notifyListeners();
      } else {
        print(response.body);
        print(response.statusCode);
        _errormsg = jsonDecode(response.body)['errmsg'];
      }
    } catch (e) {
      throw e;
    }
    notifyListeners();
  }

  Future<void> logout() async {
    try {
      print(_userId);
      final response = await http.post("$BASE_URL/logout",
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode({"_id": _userId}));
      if (response.statusCode == 200) {
        print(response.body);
        _userId = null;
        final prefs = await SharedPreferences.getInstance();
        prefs.clear();
      } else {
        print(response.statusCode);
        _errormsg = jsonDecode(response.body);
      }
    } catch (e) {
      throw e;
    }
    notifyListeners();
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedUserData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;
    _userId = extractedUserData['userId'];
    _name = extractedUserData['name'];
    _email = extractedUserData['email'];
    notifyListeners();
    return true;
  }
}
