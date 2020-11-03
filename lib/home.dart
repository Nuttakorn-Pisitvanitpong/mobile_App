import 'package:dev_Bet/widget/add_list.dart';
import 'package:flutter/material.dart';
import 'package:dev_Bet/widget/list_pd.dart';
import 'login.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  Container showlistButton() => Container(
      width: 250.0,
      child: ClipRRect(
        //ลดเหลี่ยมปุ่ม
        borderRadius: BorderRadius.circular(10),
        child: FlatButton(
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          color: Colors.orange[900],
          onPressed: () {
            MaterialPageRoute materialPageRoute = MaterialPageRoute(
                builder: (BuildContext context) => ShowListProduct());
            Navigator.of(context).pushAndRemoveUntil(
                materialPageRoute, (Route<dynamic> route) => false);
          },
          child: Text(
            'Show Bet List',
            style: TextStyle(color: Colors.white, fontSize: 18.0),
          ),
        ),
      ));

  Container showaddlistButton() => Container(
      width: 250.0,
      child: ClipRRect(
        //ลดเหลี่ยมปุ่ม
        borderRadius: BorderRadius.circular(10),
        child: FlatButton(
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          color: Colors.orange[900],
          onPressed: () {
            MaterialPageRoute materialPageRoute = MaterialPageRoute(
                builder: (BuildContext context) => AddListProduct());
            Navigator.of(context).pushAndRemoveUntil(
                materialPageRoute, (Route<dynamic> route) => false);
          },
          child: Text(
            'Add Bet List',
            style: TextStyle(color: Colors.white, fontSize: 18.0),
          ),
        ),
      ));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black38,
      appBar: AppBar(
        title: Text('Pause BET', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              MaterialPageRoute route =
                  MaterialPageRoute(builder: (value) => Login());
              Navigator.push(context, route);
            },
          ),
        ],
      ),
      body: Container(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          showlistButton(),
          showaddlistButton(),
        ],
      )),
    );
  }
}
