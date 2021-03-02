import 'dart:async';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:app/Models/user.dart' as repo;
import 'package:provider/provider.dart';
import 'package:app/homes/interfaces/account.dart';

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

class DetailPage extends StatefulWidget {
  final DocumentSnapshot post;
  DetailPage({this.post});

  @override
  _DetailPageState createState() => _DetailPageState();





}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.post["start"]),
      ),
      body: Container(
        child: Card(
          child: ListTile(

            title: Text(widget.post["firstName"] +" "+ widget.post["lastName"]),
            subtitle: Text(widget.post["date"] +"\n" "Adresse de départ : "+widget.post["start"]+"\n"+"Adresse d'arrivée : "+widget.post["destination"]+"\n" )
            ,

          ),
        ),
      ),
    );
  }
}


class _ListPageStates extends StatelessWidget {
  @override
  var firestoreInstance = FirebaseFirestore.instance;



  Future fetchOrders() async {
    QuerySnapshot qn = await firestoreInstance
        .collection('requests')
        .where('status', isEqualTo: 'open')
        .get();
    return qn.docs;
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("Trajets disponibles"),
      ),
      body: Container(
        child: FutureBuilder(
            future: fetchOrders(),
            // ignore: non_constant_identifier_names
            builder: (_, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: Text("Loading ..."));
              } else {
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (_, index) {
                      return ListTile(
                        title: Text(snapshot.data[index]["start"]),
                        onTap: (){
                          Navigator.push(context,MaterialPageRoute(builder:(context) =>DetailPage(post:snapshot.data[index],)));
                        }

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


  void pushPage(BuildContext context, Widget page) {
    Navigator.of(context) /*!*/ .push(
      MaterialPageRoute<void>(builder: (_) => page),
    );
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
                    Material(
                        child: ListTile(
                            leading: new Icon(Icons.info),
                            title: Text('Mon compte'),
                            onTap: () {
                            pushPage(context,Account());
                            }),

                            ),

                  Material(
                      child: ListTile(
                          leading: new Icon(Icons.list),
                          title: Text('Mes trajets'),
                          onTap: () {
                              setState(() {
                                  text = "Ajouter interface trajets";
                              });
                              Navigator.pop(context);
                          }),
                  ),
                    Material(
                        child: ListTile(
                            leading: new Icon(Icons.directions_car),
                            title: Text('Trajets disponibles'),
                            onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(
                                        builder: (context) {
                                            return StreamBuilder<QuerySnapshot>(
                                                stream: FirebaseFirestore.instance.collection('requests').where('status', isEqualTo: 'open').snapshots(),
                                                builder: (context, snapshot) {
                                                    if (!snapshot.hasData) return LinearProgressIndicator();
                                                    return _buildList(context, snapshot.data.docs);
                                                },
                                            );
                                        }
                                    ),
                                );
                            }),
                    ),
                  Material(
                      child: ListTile(
                          leading: new Icon(Icons.settings),
                          title: Text('Paramètres'),
                          onTap: () {
                              setState(() {
                                  text = "Ajouter interface paramètres";
                              });
                              Navigator.pop(context);
                          }),
                  ),
                ]),
              )
            ],
          ),
        ),
        appBar: new AppBar(
          title: new Text("Bienvenue ${Provider.of<repo.UserRepo>(this.context, listen: false).connectedDriver.firstName}"),
        ),
        body: new Center(
          child: new Text((text)),
        ));
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot){
      return Scaffold(
        appBar: new AppBar(
          title : Text("Trajets disponibles"),
        ),
        body:

        ListView(
            padding: const EdgeInsets.only(top: 20.0),
            children: snapshot.map((data) => _buildListItem(context, data)).toList(),

        ),
      );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
      final record = Record.fromSnapshot(data);

      return Padding(
          key: ValueKey(record.firstName),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
              ),
              child: Material(
                  child: ListTile(
                      title: Text(record.firstName + ' ' + record.lastName),
                      subtitle: Text(record.start + ' - ' + record.destination),
                      onTap: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                  title: Text("Validez-vous ce trajet ?"),
                                  content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                          Text("Passager : ${record
                                              .firstName} ${record.lastName}"),
                                          Text("Départ : ${record.start}"),
                                          Text("Arrivée : ${record.destination}"),
                                      ],
                                  ),
                                  actions: <Widget>[
                                      ElevatedButton(
                                          onPressed: () async {
                                              await record.reference.update(
                                                  {'status': 'processing'});
                                              await record.reference.update(
                                                  {'driverId': FirebaseAuth.instance.currentUser.uid });
                                              Navigator.of(context).pop();
                                          },
                                          child: Text("Valider"),
                                      ),
                                      ElevatedButton(
                                          onPressed: () {
                                              Navigator.of(context).pop();
                                          },
                                          child: Text("Annuler"),
                                      ),
                                  ],
                              ),
                          );
                      },
                  ),
              ),
          ),
      );
  }
}

class Record {
    final String firstName;
    final String lastName;
    final String start;
    final String destination;
    final DocumentReference reference;

    Record.fromMap(Map<String, dynamic> map, {this.reference})
        : assert(map['firstName'] != null),
            assert(map['lastName'] != null),
            assert(map['start'] != null),
            assert(map['destination'] != null),
            firstName = map['firstName'],
            lastName = map['lastName'],
            start = map['start'],
            destination = map['destination'];

    Record.fromSnapshot(DocumentSnapshot snapshot)
        : this.fromMap(snapshot.data(), reference: snapshot.reference);

    @override
    String toString() => "Trajet<$firstName $lastName\n$start - $destination>";
}
