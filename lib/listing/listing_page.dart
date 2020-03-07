import 'package:flutter/material.dart';

import '../data.dart';

class ListingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(itemBuilder: (BuildContext context, int i){
      return ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(mechanic[i]['thumbnailUrl']),
        ),
        title: Text(mechanic[i]['title']),
        trailing: Icon(Icons.call),
      );
    }, itemCount: mechanic.length,);
  }
}
