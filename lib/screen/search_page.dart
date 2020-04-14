import 'dart:convert';

import 'package:findmechanice/constants.dart';
import 'package:findmechanice/listing/listing_page.dart';
import 'package:findmechanice/models/mechanic.dart';
import 'package:findmechanice/providers/customers.dart';
import 'package:findmechanice/widgets/dropdown.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String _type = "Car";

  void selectType(String value) {
    setState(() {
      _type = value;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          DropDown(selectType, _type),
          SizedBox(
            height: 20.0,
          ),
          FlatButton.icon(
            color: Theme.of(context).primaryColor,
            onPressed: () async {
              Navigator.of(context).pushNamed(
                ListingPage.routeName,
                arguments: _type,
              );
            },
            icon: Icon(Icons.search),
            label: Text("Search"),
          ),
        ],
      ),
    );
  }
}
