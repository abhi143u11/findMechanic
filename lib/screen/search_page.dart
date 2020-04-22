import 'dart:convert';

import 'package:findmechanice/constants.dart';
import 'package:findmechanice/screen/listing_page.dart';
import 'package:findmechanice/models/mechanic.dart';
import 'package:findmechanice/providers/customer.dart';
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
  bool _toe = false;

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              DropDown(selectType, _type),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Do you Required tow?',
                      style: widgetStyle1,
                    ),
                    Checkbox(
                      value: _toe,
                      onChanged: (value) {
                        setState(() {
                          _toe = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          FlatButton.icon(
            color: Theme.of(context).primaryColor,
            onPressed: () async {
              Navigator.of(context).pushNamed(
                ListingPage.routeName,
                arguments: [_type, _toe],
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
