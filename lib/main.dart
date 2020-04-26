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
            ),
          ),
        ],
        child: Consumer<Auth>(
          builder: (context, auth, _) => ChangeNotifierProvider(
            create: (context) => Customer(auth.userId),
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Customer',
              theme: ThemeData(
                scaffoldBackgroundColor: Color(0xff11173B),
                primaryColor: Color(0xff11173B),
                accentColor: Color(0xffF94B66),
                cardColor: Color(0xff272A4E),
                buttonColor: Color(0xffF94B66),
                fontFamily: 'Georgia',
                textTheme: TextTheme(
                  headline: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  title: TextStyle(
                    fontSize: 24.0,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.bold,
                  ),
                  body1: TextStyle(
                    fontSize: 18.0,
                    fontStyle: FontStyle.values[0],
                  ),
                ),
              ),
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
          ),
        ));
  }
}
