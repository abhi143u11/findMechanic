import 'package:findmechanice/models/mechanic.dart';
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
  bool _isInit = true;
  bool isLoading = true;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (_isInit) {
      await Provider.of<Customer>(context).getLocation();
    }
    _isInit = false;
  }

  Future<List<Mechanic>> _refreshList(List data) async {
    List<Mechanic> mechalist =
        await Provider.of<Customer>(context, listen: false)
            .getMechanic(data[0], data[1]);
    return mechalist;
  }

  @override
  Widget build(BuildContext context) {
    List searchData = ModalRoute.of(context).settings.arguments as List;
    return Scaffold(
        appBar: AppBar(
          title: Text('Select Mechanic'),
        ),
        backgroundColor: Color(0xfff0f0f0),
        body: FutureBuilder(
          future: _refreshList(searchData),
          builder: (context, snapshot) {
            if (snapshot.hasError) return _buildNoMechanicFound(context);
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Center(child: CircularProgressIndicator());
              case ConnectionState.done:
                return RefreshIndicator(
                    onRefresh: () => _refreshList(searchData),
                    child: _buildList(context, snapshot.data));
              default:
                return _buildNoMechanicFound(context);
            }
          },
        ));
  }

  Widget _buildList(BuildContext context, List<Mechanic> data) {
    print("length ${data.length}");
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
