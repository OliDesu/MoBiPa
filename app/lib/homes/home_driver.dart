import 'dart:async';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class DriverHome extends StatefulWidget {
  @override
  _DriverHomeState createState() => new _DriverHomeState();
}

class UserList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _DriverHomeState();
  }
}


// ignore: must_be_immutable
class _ListPageStates extends StatelessWidget{
  @override

 var firestoreInstance = FirebaseFirestore.instance;

  List<dynamic> orders = [];

  Future fetchOrders() async {
    QuerySnapshot qn = await firestoreInstance
        .collection('requests')
        .where('status',isEqualTo: 'open')
        .get();
    return qn.docs;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body :
     Container(
    child: FutureBuilder(
    future: fetchOrders(),
    // ignore: non_constant_identifier_names
    builder: (_,snapshot){
    if(snapshot.connectionState == ConnectionState.waiting){
    return Center(
    child: Text("Loading ...")
    );
    } else{
    return ListView.builder(
    itemCount: snapshot.data.length,
    itemBuilder: (_, index){
    return ListTile(
    title: Text(snapshot.data[index]["start"]),

    );
    });
    }
    }),
    ),
    );

  }




}
class _DriverHomeState extends State<DriverHome> {
  Marker marker;
  Circle circle;

  final firestoreInstance = FirebaseFirestore.instance;

  List<dynamic> orders = [];

  Future fetchOrders() async {
    QuerySnapshot qn = await firestoreInstance.collection("requests").get();
    return qn.docs;
  }

  String text = "Ajouter actualités ici ";
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        drawer: new Drawer(
          child: new ListView(
            children: <Widget>[
              new Container(
                  child: new DrawerHeader(
                      child: new Container(
                child: Text('Mobipa'),
              ))),
              new Container(
                child: new Column(children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.info),
                      title: Text('Mon compte'),
                      onTap: () {
                        setState(() {
                          text = "Ajouter interface compte";
                        });
                        Navigator.pop(context);
                      }),
                  new ListTile(
                      leading: new Icon(Icons.list),
                      title: Text('Mes trajets'),
                      onTap: () {
                        setState(() {
                          text = "Ajouter interface trajets";
                        });
                        Navigator.pop(context);
                      }),
                  new ListTile(
                      leading: new Icon(Icons.directions_car),
                      title: Text('Trajets disponibles'),
                      onTap: () {
                      Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => _ListPageStates()),
                      );
                      }),
                  new ListTile(
                      leading: new Icon(Icons.settings),
                      title: Text('Paramètres'),
                      onTap: () {
                        setState(() {
                          text = "Ajouter interface paramètres";
                        });
                        Navigator.pop(context);
                      }),
                ]),
              )
            ],
          ),
        ),
        appBar: new AppBar(
          title: new Text("Bienvenue **Ajouter nom utilisateur**"),
        ),
        body: new Center(
          child: new Text((text)),
        ));
  }
}
