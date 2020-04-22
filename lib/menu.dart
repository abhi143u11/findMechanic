import 'package:findmechanice/screen/history.dart';
import 'package:findmechanice/screen/setting.dart';
import 'package:flutter/material.dart';

class Menu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        UserAccountsDrawerHeader(
          accountName: Text("Ashish Rawat"),
          accountEmail: Text("ashishrawat2911@gmail.com"),
          currentAccountPicture: CircleAvatar(
            child: Icon(Icons.account_box),
          ),
        ),
        ListTile(
          title: Text(
            'History',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          onTap: () {
            Navigator.pushNamed(context, History.routeName);
          },
        ),
        ListTile(
          title: Text(
            'Setting',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          onTap: () {
            Navigator.pushNamed(context, Setting.routeName);
          },
        ),
      ],
    );
  }
}
