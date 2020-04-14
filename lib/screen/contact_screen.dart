import 'dart:async';
import 'package:findmechanice/providers/customers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'feedback_screen.dart';

class ContactScreen extends StatefulWidget {
  final mechId;
  final historyId;
  ContactScreen({this.mechId, this.historyId});
  @override
  _ContactScreenState createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  bool isContact = false;
  bool isInit = true;
  Timer _timer;

  @override
  void didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    if (isInit) {
      if (!isContact) {
        _timer = Timer.periodic(new Duration(seconds: 1), (timer) async {
          try {
            bool response = await Provider.of<Customers>(context, listen: false)
                .checkMechanic(widget.historyId);
            print(response);
            debugPrint(timer.tick.toString());
            isContact = response;
//            if(isContact) timer.cancel();
          } catch (e) {
            throw e;
          }
        });
      } else {
        setState(() {
          isContact = true;
        });
      }
    }
    isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact mechanic'),
      ),
      body: !isContact
          ? Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Container(
                      margin: EdgeInsets.only(top: 20, left: 20),
                      height: 50.0,
                      child: Text(
                        'Waiting for Mechanic on the Destination to reach',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  LinearProgressIndicator(),
                  Container(
                    color: Theme.of(context).primaryColor,
                    width: double.infinity,
                    child: FlatButton(
                      onPressed: () async {
                        try {
                          await Provider.of<Customers>(context, listen: false)
                              .handleCancel(widget.historyId);
                          Navigator.of(context).pop();
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
                      'Mechanic on the way to perform the task!!',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: Colors.black),
                    ),
                  ),
                ),
                RaisedButton(
                  onPressed: () {
                    var route = MaterialPageRoute(
                        builder: (context) => FeedbackScreen());
                    Navigator.push(context, route);
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
