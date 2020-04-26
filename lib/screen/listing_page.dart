import 'package:findmechanice/models/mechanic.dart' show Mechanic;
import 'package:findmechanice/providers/customer.dart';
import 'package:findmechanice/widgets/mechanic_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListingPage extends StatefulWidget {
  static const routeName = "/listing";

  @override
  _ListingPageState createState() => _ListingPageState();
}

class _ListingPageState extends State<ListingPage> {
  List<Mechanic> mechanicList;
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    List searchData = ModalRoute.of(context).settings.arguments as List;
    final cust = Provider.of<Customer>(context, listen: false);
    return Scaffold(
        appBar: AppBar(
          title: Text('Select Mechanic'),
        ),
        body: RefreshIndicator(
          onRefresh: () => cust.getMechanic(searchData[0], searchData[1]),
          child: FutureBuilder(
            future: cust.getMechanic(searchData[0], searchData[1]),
            builder: (context, snapshot) {
              if (snapshot.hasError) return _buildNoMechanicFound(context);
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Center(child: CircularProgressIndicator());
                case ConnectionState.done:
                  return _buildList(context, snapshot.data);
                default:
                  return _buildNoMechanicFound(context);
              }
            },
          ),
        ));
  }

  Widget _buildList(BuildContext context, List<Mechanic> data) {
    if (data.length == 0 || data == null) {
      data = Provider.of<Customer>(context).mechanicList;
    }
    return ListView.builder(
      itemBuilder: (BuildContext context, int i) {
        return MechanicView(
          mechanic: data[i],
        );
      },
      itemCount: data.length,
    );
  }

  _buildNoMechanicFound(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
      alignment: Alignment.topCenter,
      child: Text('No Mechanic Found',
          style: TextStyle(color: Colors.black, fontSize: 16)),
    );
  }
}
