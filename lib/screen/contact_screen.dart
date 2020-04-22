import 'dart:async';
import 'package:findmechanice/providers/customer.dart';
import 'package:findmechanice/screen/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ContactScreen extends StatefulWidget {
  static const routeName = '/contact';
  ContactScreen();
  @override
  _ContactScreenState createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  bool _indicator = false;
  bool isInit = true;
  Timer _timer;

  @override
  void deactivate() {
    _timer.cancel();
    super.deactivate();
  }

  @override
  void didChangeDependencies() async {
    if (isInit) {
      _indicator = Provider.of<Customer>(context, listen: false).indicator;
      if (!_indicator) {
        _timer = Timer.periodic(new Duration(seconds: 2), (_) async {
          try {
            await Provider.of<Customer>(context, listen: false).checkMechanic();
            _indicator =
                Provider.of<Customer>(context, listen: false).indicator;
            if (_indicator) setState(() {});
          } catch (e) {
            print(e.toString());
            throw e;
          }
        });
      } else {
        setState(() {});
      }
    }
    isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    String mechId = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact mechanic'),
      ),
      body: !_indicator
          ? Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Container(
                      margin: EdgeInsets.only(top: 20, left: 20),
                      height: 50.0,
                      child: Text(
                        'Waiting for Mechanic...',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    color: Theme.of(context).primaryColor,
                    width: double.infinity,
                    child: FlatButton(
                      onPressed: () async {
                        try {
                          await Provider.of<Customer>(context, listen: false)
                              .handleCancel(mechId);
                          Navigator.of(context).pop(true);
                        } catch (e) {
                          throw e;
                        }
                      },
                      child: Text('Cancel'),
                    ),
                  )
                ])
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                    width: double.infinity,
                    child: Text(
                      'Mechanic is performing  the task!! Once completed Plese click the done button.',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                RaisedButton(
                  onPressed: () async {
                    await Provider.of<Customer>(context, listen: false)
                        .customerDone(mechId);
                    Navigator.pushReplacementNamed(context, HomePage.routeName);
                  },
                  child: Text(
                    'Done',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Colors.black),
                  ),
                ),
              ],
            ),
    );
  }
}
