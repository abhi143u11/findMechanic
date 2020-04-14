import 'package:findmechanice/listing/listing_page.dart';
import 'package:findmechanice/providers/auth.dart';
import 'package:findmechanice/providers/customers.dart';
import 'package:findmechanice/screen/auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'home/home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: Auth(),
          ),
          ChangeNotifierProvider.value(
            value: Customers(),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Find Mechanic',
          theme: ThemeData(primarySwatch: Colors.amber),
          home: HomePage(),
          routes: {
            AuthScreen.routeName: (context) => AuthScreen(),
            ListingPage.routeName: (context) => ListingPage(),
          },
        ));
  }
}
