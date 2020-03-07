import 'package:findmechanice/screen/login.dart';
import 'package:flutter/material.dart';

class Menu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      // Important: Remove any padding from the ListView.
      padding: EdgeInsets.zero,
      children: <Widget>[
        DrawerHeader(
          child: Text('Drawer Header'),
          decoration: BoxDecoration(
            color: Theme.of(context).accentColor,
          ),
        ),
        ListTile(
          title: Text('Item 1'),
          onTap: () {
            Navigator.pop(context);
            // Update the state of the app.
            // ...
          },
        ),
        ListTile(
          title: Text('Item 2'),
          onTap: () {
            Navigator.pop(context);
            // Update the state of the app.
            // ...
          },
        ),
      ],
    );
  }
}
