import 'package:findmechanice/providers/auth.dart';
import 'package:findmechanice/screen/auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screen/search_page.dart';

import '../menu.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context);
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Find Mechanic')),
        actions: <Widget>[
          auth.isAuth
              ? FlatButton(
                  onPressed: () async {
                    try{
                      await Provider.of<Auth>(context, listen: false).logout();
                    }catch(e){
                      print(e);
                    }
                  },
                  child: Text(
                    'logout',
                    style: TextStyle(fontSize: 18),
                  ))
              : FlatButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AuthScreen.routeName);
                  },
                  child: Text('login', style: TextStyle(fontSize: 18)))
        ],
      ),
      drawer: Drawer(
        child: Menu(),
      ),
      body: SearchPage(),
    );
  }
}
