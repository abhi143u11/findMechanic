import 'package:findmechanice/providers/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'search_page.dart';

import '../menu.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home';

  @override
  _HomePageState createState() => _HomePageState();
}



class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Find Mechanic')),
        actions: <Widget>[
          FlatButton(
            onPressed: () async {
              try {
                await Provider.of<Auth>(context, listen: false).logout();
              } catch (e) {
                print(e);
              }
            },
            child: Text(
              'logout',
              style: TextStyle(fontSize: 18),
            ),
          )
        ],
      ),
      drawer: Drawer(
        child: Menu(),
      ),
      body: SearchPage(),
    );
  }
}


