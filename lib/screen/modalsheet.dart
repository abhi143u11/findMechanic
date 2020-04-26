import 'package:findmechanice/constants.dart';
import 'package:findmechanice/providers/customer.dart';
import 'package:findmechanice/screen/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ModalSheet extends StatefulWidget {
  String mechId;
  ModalSheet(this.mechId);

  @override
  _ModalSheetState createState() => _ModalSheetState();
}

class _ModalSheetState extends State<ModalSheet> {
  int rating = 0;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
              padding: EdgeInsets.all(16),
              child: Text(
                'Take a minute to give Feedback',
                style: dataStyle1,
              )),
          TextFormField(
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              labelText: 'Give rating between 1-5',
              alignLabelWithHint: true,
            ),
            onChanged: (value) {
              setState(() {
                rating = int.parse(value);
              });
            },
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * .15,
          ),
          RaisedButton(
            onPressed: _isLoading
                ? null
                : () async {
              setState(() {
                _isLoading = true;
              });
              await Provider.of<Customer>(context, listen: false)
                  .handleRating(rating, widget.mechId);
              setState(() {
                _isLoading = false;
              });
              Navigator.pushReplacementNamed(context, HomePage.routeName);
            },
            color: Theme.of(context).primaryColor,
            child: Text('Submit'),
          )
        ],
      ),
    );
  }
}