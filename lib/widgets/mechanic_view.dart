import 'package:findmechanice/models/mechanic.dart';
import 'package:findmechanice/providers/customer.dart';
import 'package:findmechanice/screen/contact_screen.dart';
import 'package:flutter/material.dart';
import 'package:findmechanice/constants.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

class MechanicView extends StatefulWidget {
  const MechanicView({
    Key key,
    @required this.mechanic,
  }) : super(key: key);

  final Mechanic mechanic;

  @override
  _MechanicViewState createState() => _MechanicViewState();
}

class _MechanicViewState extends State<MechanicView> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 20),
      color: Colors.white,
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  widget.mechanic.name,
                  style: widgetStyle1,
                ),
                Text("${(widget.mechanic.distance).toStringAsFixed(1)} Km",
                    style: widgetStyle1),
                Text(
                  "${(widget.mechanic.time).toStringAsFixed(1)} hr",
                  style: widgetStyle1,
                ),
              ],
            ),
            RaisedButton.icon(
                onPressed: () async {
                  await Provider.of<Customer>(context, listen: false)
                      .selectMechanic(widget.mechanic.id);
                  Navigator.of(context).pushNamed(ContactScreen.routeName,
                      arguments: widget.mechanic.id);
                },
                icon: Icon(Icons.account_box),
                label: Text(
                  'Click to Contact',
                  style: widgetStyle1,
                ))
          ],
        ),
      ),
    );
  }
}

//return showDialog(
//context: context,
//builder: (ctx) => AlertDialog(
//title: Text('Are you sure?'),
//content: Text(
//'Do you want to remove the item from the cart?',
//),
//actions: <Widget>[
//FlatButton(
//child: Text('No'),
//onPressed: () {
//Navigator.of(ctx).pop(false);
//},
//),
//FlatButton(
//child: Text('Yes'),
//onPressed: () {
//Navigator.of(ctx).pop(true);
//},
//),
//],
//),
//);
