import 'package:findmechanice/constants.dart';
import 'package:findmechanice/providers/auth.dart';
import 'package:findmechanice/providers/customer.dart';
import 'package:findmechanice/screen/listing_page.dart';
import 'package:findmechanice/widgets/dropdown.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../menu.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _type = "Car";
  bool _toe = false;
  bool _isInit = true;


  void selectType(String value) {
    setState(() {
      _type = value;
    });
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (_isInit) {
      await Provider.of<Customer>(context, listen: false).getLocation();
    }
    _isInit = false;
  }


  @override
  Widget build(BuildContext context) {
    final data = Provider.of<Auth>(context);
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Find Mechanic')),
        actions: <Widget>[
          IconButton(
            tooltip: 'logout',
            onPressed: () async {
              try {
                await Provider.of<Auth>(context, listen: false).logout();
              } catch (e) {
                print(e);
              }
            },
            icon: Icon(Icons.subdirectory_arrow_right),
          )
        ],
      ),
      drawer: Drawer(
        child: Menu(),
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * .2, top: 20),
                  padding: EdgeInsets.all(8),
                  child: Text(
                    'Welcome ${data.name}',
                    style: dataStyle1,
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(8),
                  margin: EdgeInsets.only(left: 20),
                  child: Text(
                    'Search Mechanic of Your choice',
                    style: dataStyle2,
                  ),
                ),
                SizedBox(
                  height: 60,
                ),
                DropDown(selectType, _type),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Do you Required tow?',
                        style: widgetStyle1,
                      ),
                      Checkbox(
                        value: _toe,
                        onChanged: (value) {
                          setState(() {
                            _toe = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: FlatButton.icon(
          color: Theme.of(context).primaryColor,
          onPressed: () async {
            Navigator.of(context).pushNamed(
              ListingPage.routeName,
              arguments: [_type, _toe],
            );
          },
          icon: Icon(Icons.search),
          label: Text("Search"),
        ),
      ),
    );
  }
}
