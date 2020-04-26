import 'dart:async';
import 'package:findmechanice/constants.dart';
import 'package:findmechanice/models/mechanic.dart';
import 'package:findmechanice/providers/customer.dart';
import 'package:findmechanice/screen/home.dart';
import 'package:findmechanice/screen/modalsheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class ContactScreen extends StatefulWidget {
  static const routeName = '/contact';
  ContactScreen();
  @override
  _ContactScreenState createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  bool isInit = true;
  Timer _timer;
  bool _isLoading = false;

  @override
  void dispose() {
    if (_timer == null) return;
    _timer.cancel();
    super.dispose();
  }

  @override
  void didChangeDependencies() async {
    if (isInit) {
      final cust = Provider.of<Customer>(context, listen: false);
      _timer = Timer.periodic(new Duration(seconds: 2), (_) async {
        if (cust.indicator) {
          _timer.cancel();
          return;
        }
        await cust.checkMechanic();
      });
      isInit = false;
      super.didChangeDependencies();
    }
  }

  @override
  Widget build(BuildContext context) {
    Mechanic mechanic = ModalRoute.of(context).settings.arguments;
    String mechId = mechanic.id;
    bool _indicator = Provider.of<Customer>(context).indicator;

    return Scaffold(
      backgroundColor: Color(0xfff0f0f0),
      appBar: AppBar(
        title: Text('Contact mechanic'),
      ),
      body: !_indicator
          ? Visibility(
              visible: !_indicator,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Container(
                      height: 100,
                      color: Colors.white,
                      margin: EdgeInsets.only(top: 20),
                      child: Center(
                        child: Text(
                          'Wait for Mechanic to reach at Your location...',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 80,
                    ),
                    buildContainer(mechanic),
                  ]),
            )
          : Visibility(
              visible: _indicator,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    color: Colors.white,
                    margin: EdgeInsets.symmetric(vertical: 40),
                    width: double.infinity,
                    child: Text(
                        'Mechanic has reached you! \n\n  Task Once completed Plese click the done button.',
                        textAlign: TextAlign.center,
                        style: dataStyle1),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  buildContainer(mechanic)
                ],
              ),
            ),
      bottomNavigationBar: BottomAppBar(
        child: _indicator
            ? RaisedButton(
                color: Theme.of(context).primaryColor,
                onPressed: () async {
                  setState(() {
                    _isLoading = true;
                  });
                  await Provider.of<Customer>(context, listen: false)
                      .customerDone(mechId);
                  Provider.of<Customer>(context, listen: false)
                      .setIndicator(false);
                  setState(() {
                    _isLoading = true;
                  });
                  Navigator.pushReplacementNamed(context, HomePage.routeName);
//                    await _showModal(context, mechId);
                },
                child: Text(
                  _isLoading ? 'Plaese wait' : 'Done',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Colors.black),
                ),
              )
            : RaisedButton(
                color: Theme.of(context).primaryColor,
                onPressed: _isLoading
                    ? null
                    : () async {
                        setState(() {
                          _isLoading = true;
                        });
                        try {
                          await Provider.of<Customer>(context, listen: false)
                              .handleCancel(mechId);
                          setState(() {
                            _isLoading = false;
                          });
                          Navigator.of(context).pop();
                        } catch (e) {
                          throw e;
                        }
                      },
                child: Text(_isLoading ? 'Please wait' : 'Cancel'),
              ),
      ),
    );
  }

  Container buildContainer(Mechanic mechanic) {
    return Container(
      height: 250,
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'Mechanic Contact Deatils',
              style: dataStyle1,
            ),
            Text(
              mechanic.name,
              style: dataStyle2,
            ),
            Text(mechanic.mobile.toString(), style: dataStyle2),
            Text(mechanic.email, style: dataStyle2),
          ],
        ),
      ),
    );
  }

  _showModal(BuildContext context, String mechId) async {
    String routeName = await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) => ModalSheet(mechId),
    );
    Navigator.of(context).pushReplacementNamed(routeName);
  }
}
