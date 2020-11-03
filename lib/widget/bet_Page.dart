import 'dart:io';
import 'dart:math';

import 'package:dev_Bet/model/betPage_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dev_Bet/home.dart';
import 'package:dev_Bet/model/session_bet.dart';
import 'package:dev_Bet/widget/list_pd.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_session/flutter_session.dart';

class BethomePage extends StatefulWidget {
  @override
  _BethomePageState createState() => _BethomePageState();
}

class _BethomePageState extends State<BethomePage> {
  // Field
  String urlPicture;
  String betPrice = "0";
  List<BetPageModel> productModels = List();

  // Method
  @override
  void initState() {
    super.initState();
    readAllData();
  }

  Future<void> readAllData() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    CollectionReference collectionReference =
        firestore.collection("product_Bet");

    // ignore: await_only_futures
    await collectionReference.snapshots().listen((response) {
      // ignore: deprecated_member_use
      List<DocumentSnapshot> snapshots = response.documents;
      for (var snapshot in snapshots) {
        BetPageModel productModel = BetPageModel.fromMap(snapshot.data);
        setState(() {
          productModels.add(productModel);
          checkMail();
        });
      }
    });
  }

  checkMail() async {
    String user_n;
    FirebaseAuth auth = FirebaseAuth.instance;
    if (auth.currentUser != null) {
      print(auth.currentUser.uid);
      user_n = auth.currentUser.uid;
    }
  }

  Future<void> updateBet(String id, int betPrice) async {
    checkMail();
    CollectionReference user =
        FirebaseFirestore.instance.collection('product_Bet');
    return user.doc(id).update({'p_price': betPrice}).then((value) => {});
  }

  Widget show(int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Current Bet ",
            style: TextStyle(
              color: Colors.black,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            )),
        Text(productModels[index].doc,
            style: TextStyle(
              color: Colors.green,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            )),
      ],
    );
  }

  Widget showContent() {
    return SingleChildScrollView(
      child: FutureBuilder(
        future: FlutterSession().get('myData'),
        builder: (context, snapshot) {
          return Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                mySizebox(),
                showName(snapshot.data['pd_name']),
                mySizebox(),
                showImage(snapshot.data['url']),
                mySizebox(),
                showDetail(snapshot.data['detail']),
                mySizebox(),
                Text("Limit Day ",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    )),
                mySizebox(),
                showDeadLine(snapshot.data['time']),
                mySizebox(),
                mySizebox(),
                showPrice(snapshot.data['price']),
                betForm(),
                betButton(snapshot.data['price'], snapshot.data['id']),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget showDetail(String detail) {
    String string = detail;
    if (string.length > 500) {
      string = string.substring(0, 500);
      string = '$string ...';
    }
    return Column(
      children: [
        Text("My Detail ",
            style: TextStyle(
              color: Colors.black,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            )),
        Text(string, style: TextStyle(color: Colors.red[200], fontSize: 18.0)),
      ],
    );
  }

  Widget betForm() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.6,
      child: TextField(
        onChanged: (String string) {
          betPrice = string.trim();
        },
        decoration: InputDecoration(
          helperText: "Please Bet More Than Bet Current",
          labelText: "Bet This Product",
          icon: Icon(Icons.face),
        ),
      ),
    );
  }

  Widget showPrice(int price) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text("Current Bet ",
            style: TextStyle(
              color: Colors.black,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            )),
        Text(price.toString(),
            style: TextStyle(
              color: Colors.green,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            )),
      ],
    );
  }

  Widget showName(String name) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Product Name   ',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            )),
        Text(name,
            style: TextStyle(
              color: Colors.red,
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            )),
      ],
    );
  }

  Widget showImage(String pic) {
    return Container(
      padding: EdgeInsets.all(20.0),
      width: MediaQuery.of(context).size.width * 0.8,
      height: MediaQuery.of(context).size.width * 0.6,
      child: Image.network(pic),
    );
  }

  Widget showDeadLine(String time) {
    return Text(time,
        style: TextStyle(
          color: Colors.green,
          fontSize: 15.0,
          fontWeight: FontWeight.bold,
        ));
  }

  Widget betButton(int price, String urlPic) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: <Widget>[
              RaisedButton.icon(
                color: Colors.red,
                onPressed: () {
                  int bet = int.parse(betPrice);
                  print(price.toString());
                  if (price == bet || price >= bet) {
                    showAlert(
                        " Fail Bet ", " Please Bet More Than Current Bet ");
                  } else if (bet.isNaN) {
                    showAlert("Blank Bet", "Please Fill Every Blank");
                  } else {
                    // upload
                    updateBet(urlPic, bet);
                    setState(() {
                      MaterialPageRoute route = MaterialPageRoute(
                          builder: (value) => ShowListProduct());
                      Navigator.push(context, route);
                    });
                  }
                },
                icon: Icon(Icons.cloud_upload),
                label: Text("Challenge"),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> showAlert(String title, String message) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            )
          ],
        );
      },
    );
  }

  mySizebox() => SizedBox(
        width: 8.0,
        height: 20.0,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pause BET', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              MaterialPageRoute route =
                  MaterialPageRoute(builder: (value) => Homepage());
              Navigator.push(context, route);
            },
          ),
        ],
      ),
      body: Container(
        child: Stack(
          children: <Widget>[
            showContent(),
          ],
        ),
      ),
    );
  }
}
