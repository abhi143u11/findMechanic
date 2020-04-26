import 'package:findmechanice/models/mechanic.dart';
import 'package:findmechanice/providers/customer.dart';
import 'package:findmechanice/screen/contact_screen.dart';
import 'package:flutter/material.dart';
import 'package:findmechanice/constants.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
  bool _isLoading = false;
  Razorpay _razorpay;
  @override
  void initState() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(
      Razorpay.EVENT_EXTERNAL_WALLET,
      _handleExternalWallet,
    );
    super.initState();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Do something when payment succeeds
    Fluttertoast.showToast(
        msg: response.paymentId, toastLength: Toast.LENGTH_SHORT);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
    Fluttertoast.showToast(
        msg: response.message, toastLength: Toast.LENGTH_SHORT);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet is selected
    Fluttertoast.showToast(
        msg: response.walletName, toastLength: Toast.LENGTH_SHORT);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  var options = {
    'key': 'rzp_test_K7nwFgKJ6oD387',
    'amount': 100, //in the smallest currency sub-unit.
    'name': 'Azharuddin',
    'description': 'Make Payment',
    'prefill': {'contact': '7217348553', 'email': 'example@example.com'},
    'external': {
      'wallets': ['paytm']
    }
  };

  void checkout() {
    print('hi');
    _razorpay.open(options);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      child: Card(
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
                    style: dataStyle1,
                  ),
                  Text("${(widget.mechanic.distance).toStringAsFixed(1)} Km",
                      style: widgetStyle1),
                  Text(
                    "${(widget.mechanic.time).toStringAsFixed(1)} hr",
                    style: widgetStyle1,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Rating  :   ',
                    style: widgetStyle1,
                  ),
                  Text(
                    '${widget.mechanic.rating.toString()}/5',
                    style: widgetStyle1,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Minimum  Fee  :   ',
                    style: widgetStyle1,
                  ),
                  Text(
                    '${widget.mechanic.chargingfee.toString()}',
                    style: widgetStyle1,
                  ),
                ],
              ),
              RaisedButton.icon(
                  onPressed: _isLoading
                      ? null
                      : () async {
                          _showDialog(context);
                        },
                  icon: Icon(Icons.account_box),
                  label: Text(
                    _isLoading ? 'Please Wait...' : 'Click to Contact',
                    style: dataStyle1,
                  ))
            ],
          ),
        ),
      ),
    );
  }

  _showDialog(BuildContext context) async {
    bool check = await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Are you sure?'),
        content: Text(
          'Do you want to Conatct a Mechanic?',
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('No'),
            onPressed: () {
              Navigator.of(ctx).pop(false);
            },
          ),
          FlatButton(
            child: Text('Yes'),
            onPressed: () {
              Navigator.of(ctx).pop(true);
            },
          ),
        ],
      ),
    );
    if (check) {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<Customer>(context, listen: false)
          .selectMechanic(widget.mechanic.id);
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context)
          .pushNamed(ContactScreen.routeName, arguments: widget.mechanic);
    }
  }
}
