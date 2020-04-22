import 'package:findmechanice/constants.dart';
import 'package:flutter/material.dart';

class DropDown extends StatefulWidget {
  final selectType;
  final type;
  DropDown(this.selectType, this.type);

  @override
  _DropDownState createState() => _DropDownState();
}

class _DropDownState extends State<DropDown> {
  List<DropdownMenuItem> getItem() {
    return <String>['Car', 'Bike', 'Bus', 'Truck', 'Tacter', 'Auto']
        .map<DropdownMenuItem<String>>((String value) {
      return DropdownMenuItem<String>(
        value: value,
        child: Text(
          value,
          style: widgetStyle1,
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.08,
      color: Colors.grey,
      margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.all(5.0),
      child: DropdownButtonHideUnderline(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: DropdownButton<String>(
            value: widget.type,
            icon: Icon(
              Icons.expand_more,
              color: Colors.black,
            ),
            iconSize: 50,
            elevation: 16,
            isDense: true,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 80.0,
              color: Colors.white,
            ),
            underline: Container(
              height: 2,
              color: Colors.black87,
            ),
            onChanged: widget.selectType,
            items: getItem(),
          ),
        ),
      ),
    );
  }
}
