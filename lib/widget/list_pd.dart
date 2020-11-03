import 'package:dev_Bet/home.dart';

import 'package:dev_Bet/model/product_select.dart';
import 'package:dev_Bet/model/session_bet.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_session/flutter_session.dart';

import 'bet_Page.dart';

class ShowListProduct extends StatefulWidget {
  @override
  _ShowListProductState createState() => _ShowListProductState();
}

class _ShowListProductState extends State<ShowListProduct> {
  // Field
  List<ProductselectModel> productModels = List();

  String a;
  // Method
  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    readAllData();
  }

  Future<void> createSesstion(String x) async {
    var session = FlutterSession();
    await session.set('url', x);
  }

  checkMail() async {
    String user_n;
    FirebaseAuth auth = FirebaseAuth.instance;
    if (auth.currentUser != null) {
      print(auth.currentUser.uid);
      user_n = auth.currentUser.uid;
    }
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
        ProductselectModel productModel =
            ProductselectModel.fromMap(snapshot.data);
        setState(() {
          productModels.add(productModel);
          checkMail();
        });
      }
    });
  }

  Future<void> saveData(int price, String url, String detail, String pd_name,
      String time, String id) async {
    Data myData = Data(
        price: price,
        url: url,
        detail: detail,
        pd_name: pd_name,
        time: time,
        id: id);
    await FlutterSession().set('myData', myData);
  }

  Widget showImage(int index) {
    return Container(
      padding: EdgeInsets.all(20.0),
      width: MediaQuery.of(context).size.width * 0.5,
      height: MediaQuery.of(context).size.width * 0.5,
      child: InkWell(
          onTap: () {
            String url_ = productModels[index].p_ImagePath;
            String de_tail_ = productModels[index].p_detail;
            String pd_name = productModels[index].p_name;
            DateTime time = productModels[index].p_timeBet.toDate();
            int price_ = productModels[index].p_price;
            String id = productModels[index].p_id;
            saveData(price_, url_, de_tail_, pd_name, time.toString(), id);
            MaterialPageRoute route =
                MaterialPageRoute(builder: (value) => BethomePage());
            Navigator.push(context, route);
          },
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                image: DecorationImage(
                  image: NetworkImage(productModels[index].p_ImagePath),
                  fit: BoxFit.cover,
                )),
          )),
      //Image.network(productModels[index].pathImage),
    );
  }

  Widget showPrice(int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Current Bet ",
            style: TextStyle(
              color: Colors.black,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            )),
        Text(productModels[index].p_price.toString(),
            style: TextStyle(
              color: Colors.green,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            )),
      ],
    );
  }

  Widget showName(int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(productModels[index].p_name,
            style: TextStyle(
              color: Colors.red,
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            )),
      ],
    );
  }

  Widget showDeadLine(int index) {
    DateTime time = productModels[index].p_timeBet.toDate();
    print(time);
    return Text(time.toString(),
        style: TextStyle(
          color: Colors.green,
          fontSize: 15.0,
          fontWeight: FontWeight.bold,
        ));
  }

  Widget showText(int index) {
    return Container(
      padding: EdgeInsets.only(right: 20.0),
      width: MediaQuery.of(context).size.width * 0.5,
      height: MediaQuery.of(context).size.width * 0.5,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          showName(index),
          showDetail(index),
          Text(
            'End Time',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          showDeadLine(index),
          showPrice(index),
        ],
      ),
    );
  }

  Widget showDetail(int index) {
    String string = productModels[index].p_detail;
    if (string.length > 50) {
      string = string.substring(0, 50);
      string = '$string ...';
    }
    return Text(string,
        style: TextStyle(color: Colors.red[200], fontSize: 18.0));
  }

  Widget showListView(int index) {
    return Row(
      children: <Widget>[
        showImage(index),
        showText(index),
      ],
    );
  }

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
          child: ListView.builder(
        itemCount: productModels.length,
        itemBuilder: (BuildContext buildContext, int index) {
          return //Text(productModels[index].pathImage);
              showListView(index);
        },
      )),
    );
  }
}
