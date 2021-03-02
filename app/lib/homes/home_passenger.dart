import 'dart:async';
import 'dart:typed_data';
import 'package:app/Models/firebaseRequest.dart';
import 'package:app/Models/utilisateur.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:app/Models/firebaseRequest.dart';
import 'package:app/Models/user.dart' as repo;
import 'package:provider/provider.dart';
import 'package:app/homes/interfaces/account.dart';

class PassengerHome extends StatefulWidget {
  @override
  _PassengerHomeState createState() => new _PassengerHomeState();
}

class _PassengerHomeState extends State<PassengerHome> {
  static final kInitialPosition = LatLng(-33.8567844, 151.213108);

  PickResult selectedPlaceStart;
  PickResult selectedPlaceEnd;
  static final CameraPosition initialLocation = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  Future<Uint8List> getMarker() async {
    ByteData byteData =
        await DefaultAssetBundle.of(context).load("assets/directon_icon.png");
    return byteData.buffer.asUint8List();
  }

  void pushPage(BuildContext context, Widget page) {
    Navigator.of(context) /*!*/ .push(
      MaterialPageRoute<void>(builder: (_) => page),
    );
  }

  Widget _buildPopupDialog(BuildContext context) {
    return new AlertDialog(
      title: const Text('Popup example'),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Voulez vous valider ce trajet ? "),
          Text("Départ : " + selectedPlaceStart.formattedAddress ?? ""),
          Text("Arrivée : " + selectedPlaceEnd.formattedAddress ?? ""),
        ],
      ),
      actions: <Widget>[
        new ElevatedButton(
          onPressed: () async {
            if (selectedPlaceStart != null && selectedPlaceEnd != null) {
              FirebaseRequest order = new FirebaseRequest(
                  selectedPlaceStart.formattedAddress,
                  selectedPlaceEnd.formattedAddress);
              await order.getName(FirebaseAuth.instance.currentUser.uid);
              DocumentReference ref = await FirebaseFirestore.instance
                  .collection('requests')
                  .add(order.toJson());
              Provider.of<repo.UserRepo>(this.context, listen: false).connectedUtilisateur.requests.add(ref.id);
              Provider.of<repo.UserRepo>(this.context, listen: false).updateRequestsUtilisateur();
            }
            Navigator.of(context).pop();
          },
          child: const Text('Valider'),
        ),
        new ElevatedButton(
          onPressed: () async {
            Navigator.of(context).pop();
          },
          child: const Text('Annuler'),
        ),
      ],
    );
  }

  String text = "Ajouter une map ici ";
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
                        pushPage(context,Account());
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
                      title: Text('Conducteurs à proximité'),
                      onTap: () {
                        setState(() {
                          text = "Ajouter interface conducteur";
                        });
                        Navigator.pop(context);
                      }),
                  new ListTile(
                    leading: new Icon(Icons.map),
                    title: Text('Nouveau trajet'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return PlacePicker(
                              apiKey: 'AIzaSyADXtEYlr02LSSaESs4-tB2yGh0pdtPu0c',
                              initialPosition:
                                  _PassengerHomeState.kInitialPosition,
                              useCurrentLocation: true,
                              selectInitialPosition: true,
                              usePlaceDetailSearch: true,
                              onPlacePicked: (result) {
                                selectedPlaceStart = result;
                                Navigator.of(context).pop();
                                setState(() {});
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return PlacePicker(
                                        apiKey:
                                            'AIzaSyADXtEYlr02LSSaESs4-tB2yGh0pdtPu0c',
                                        initialPosition: _PassengerHomeState
                                            .kInitialPosition,
                                        useCurrentLocation: true,
                                        selectInitialPosition: true,
                                        usePlaceDetailSearch: true,
                                        onPlacePicked: (result) {
                                          selectedPlaceEnd = result;

                                          Navigator.of(context).pop();
                                          setState(() {});
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                _buildPopupDialog(context),
                                          );
                                        },
                                      );
                                    },
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      );
                    },
                  ),
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
          title: new Text("Bienvenue ${Provider.of<repo.UserRepo>(this.context, listen: false).connectedUtilisateur.firstName}"),
        ),
        body: new Center(
          child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('requests')
                  .where('passengerId', isEqualTo: FirebaseAuth.instance.currentUser.uid)
                  .where('status', isEqualTo: 'processing')
                  .snapshots(),
              builder: (context, snapshot) {
                  if (!snapshot.hasData) return LinearProgressIndicator();
                  else {
                      if (snapshot.data.size == 0){
                          return Text('RAS');
                      }
                      return Text('On vous prend en charge !');
                  }
              },
          ),
        ));
  }
}
