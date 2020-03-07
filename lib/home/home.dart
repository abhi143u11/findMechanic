import 'package:findmechanice/listing/listing_page.dart';
import 'package:findmechanice/screen/login.dart';
import 'package:flutter/material.dart';

import '../menu.dart';

class HomePage extends StatelessWidget {
  final String title;
  HomePage({this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(title)),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.supervised_user_circle),
            onPressed: (){
                var routeName = MaterialPageRoute(builder : (context) => Login());
                Navigator.push(context, routeName);
            },
          )
        ],

      ),
      drawer: Drawer(
        child: Menu(),
      ),
      body: ListingPage(),
    );
  }
}
