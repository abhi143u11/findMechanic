import 'package:findmechanice/screen/contact_screen.dart';
import 'package:findmechanice/screen/listing_page.dart';
import 'package:findmechanice/providers/auth.dart';
import 'package:findmechanice/providers/customer.dart';
import 'package:findmechanice/screen/auth_screen.dart';
import 'package:findmechanice/screen/history.dart';
import 'package:findmechanice/screen/setting.dart';
import 'package:findmechanice/screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screen/home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => Auth(),
          ),
          ChangeNotifierProxyProvider<Auth, Customer>(
            update: (context, auth, prevCust) => Customer(
              auth.userId,
              prevCust == null ? [] : prevCust.mechanicList,
            ),
          ),
        ],
        child: Consumer<Auth>(
          builder: (context, auth, _) => MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Customer',
            theme: ThemeData(primarySwatch: Colors.amber),
            home: auth.isAuth
                ? HomePage()
                : FutureBuilder(
                    future: auth.tryAutoLogin(),
                    builder: (context, snapshot) =>
                        snapshot.connectionState == ConnectionState.waiting
                            ? SplashScreen()
                            : AuthScreen(),
                  ),
            routes: {
              HomePage.routeName: (context) => HomePage(),
              AuthScreen.routeName: (context) => AuthScreen(),
              ListingPage.routeName: (context) => ListingPage(),
              History.routeName: (context) => History(),
              Setting.routeName: (context) => Setting(),
              ContactScreen.routeName: (context) => ContactScreen()
            },
          ),
        ));
  }
}
