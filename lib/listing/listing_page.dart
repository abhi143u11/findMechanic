import 'package:findmechanice/models/mechanic.dart';
import 'package:findmechanice/providers/customers.dart';
import 'package:findmechanice/screen/contact_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListingPage extends StatefulWidget {
  static const routeName = "listing";


  @override
  _ListingPageState createState() => _ListingPageState();
}

class _ListingPageState extends State<ListingPage> {
  List<Mechanic> mechanicList;
  bool _isInit = true;
  bool isLoading = true;

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      final customer = Provider.of<Customers>(context);
      String type  = ModalRoute.of(context).settings.arguments as String;
      await customer.getLocation();
      customer.getMechanic(type).then((_) {
        setState(() {
          isLoading = false;
        });
      });
    }
    _isInit = false;
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    List<Mechanic> mechanicList = Provider.of<Customers>(context).mechanicList;
    return Scaffold(
        appBar: AppBar(
          title: Text('Select Mechanic'),
        ),
        backgroundColor: Colors.grey,
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemBuilder: (BuildContext context, int i) {
                  var mech = mechanicList[i];
                  return GestureDetector(
                    onTap: () async {
                      final response =
                          await Provider.of<Customers>(context, listen: false)
                              .selectMechanic(mech.id);
                      String historyId = response;
                      var route = MaterialPageRoute(
                          builder: (context) => ContactScreen(
                              mechId: mech.id, historyId: historyId));
                      Navigator.push(context, route);
                    },
                    child: Card(
                      color: Colors.white,
                      elevation: 2,
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Icon(Icons.supervised_user_circle),
                        ),
                        subtitle: Text('Available'),
                        isThreeLine: true,
                        title: Text(
                          mechanicList[i].name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                        trailing:
                            Text("${mechanicList[i].distance.toString()} Km"),
                      ),
                    ),
                  );
                },
                itemCount: mechanicList.length,
              ));
  }
}
