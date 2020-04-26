import 'package:findmechanice/constants.dart';
import 'package:findmechanice/providers/auth.dart';
import 'package:findmechanice/screen/history.dart';
import 'package:findmechanice/screen/setting.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Menu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final data = Provider.of<Auth>(context);
    return ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        UserAccountsDrawerHeader(
          accountName: Text(
            data.name,
            style: dataStyle2,
          ),
          accountEmail: Text(
            data.email,
            style: dataStyle2,
          ),
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
