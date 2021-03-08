import 'dart:async';
import 'dart:typed_data';
import 'package:app/Models/firebaseRequest.dart';
import 'package:app/Models/utilisateur.dart';
import 'package:app/homes/interfaces/data_management.dart';
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
import 'package:app/homes/interfaces/contact.dart';
import 'package:app/homes/interfaces/myRequest.dart';

class PassengerHome extends StatefulWidget {
  @override
  _PassengerHomeState createState() => new _PassengerHomeState();
}

class _PassengerHomeState extends State<PassengerHome> {
  static final kInitialPosition = LatLng(-33.8567844, 151.213108);

  PickResult selectedPlaceStart;
  PickResult selectedPlaceEnd;

  Location location = new Location();

  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;

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
      title: const Text('Voulez vous valider ce trajet ? '),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
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
                  selectedPlaceEnd.formattedAddress,
                  selectedPlaceStart.geometry.location.lat,
                  selectedPlaceStart.geometry.location.lng,
                  selectedPlaceEnd.geometry.location.lat,
                  selectedPlaceEnd.geometry.location.lng);
              await order.getName(FirebaseAuth.instance.currentUser.uid);
              DocumentReference ref = await FirebaseFirestore.instance
                  .collection('requests')
                  .add(order.toJson());
              Provider.of<repo.UserRepo>(this.context, listen: false)
                  .connectedUtilisateur
                  .requests
                  .add(ref.id);
              Provider.of<repo.UserRepo>(this.context, listen: false)
                  .updateRequestsUtilisateur();

              _serviceEnabled = await location.serviceEnabled();
              if (!_serviceEnabled) {
                  _serviceEnabled = await location.requestService();
                  if(!_serviceEnabled) {
                      return;
                  }
              }

              _permissionGranted = await location.hasPermission();
              if (_permissionGranted == PermissionStatus.DENIED) {
                  _permissionGranted = await location.requestPermission();
                  if (_permissionGranted != PermissionStatus.GRANTED) {
                      return;
                  }
              }

              _locationData = await location.getLocation();

              await FirebaseFirestore.instance.collection('requests').doc(ref.id).update(
                  {'passengerLat': _locationData.latitude});

              await FirebaseFirestore.instance.collection('requests').doc(ref.id).update(
                  {'passengerLon': _locationData.longitude});

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

  Widget _buildPopUpData(BuildContext context) {
    return new AlertDialog(
      title: const Text('Voulez vous valider ce trajet ? '),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
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
                  selectedPlaceEnd.formattedAddress,
                  selectedPlaceStart.geometry.location.lat,
                  selectedPlaceStart.geometry.location.lng,
                  selectedPlaceEnd.geometry.location.lat,
                  selectedPlaceEnd.geometry.location.lng);
              await order.getName(FirebaseAuth.instance.currentUser.uid);
              DocumentReference ref = await FirebaseFirestore.instance
                  .collection('requests')
                  .add(order.toJson());
              Provider.of<repo.UserRepo>(this.context, listen: false)
                  .connectedUtilisateur
                  .requests
                  .add(ref.id);
              Provider.of<repo.UserRepo>(this.context, listen: false)
                  .updateRequestsUtilisateur();
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

  final String description =
      " En plus d'être une plateforme de transport solidaire, MobiPA offre la possibilité de vous accompagner dans vos premières démarches. N'hésitez pas à nous poser vos questions ! ";
  final String description1 =
      "La nouvelle plateforme MobiPA est là pour aider au maximum les personnes agées dans le besoin à se déplacer sur des trajets court. ";
  String text = "blabla";

  @override
  bool descTextShowFlag = false;
  bool descTextShowFlag1 = false;

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
                        pushPage(context, Account());
                      }),
                  new ListTile(
                      leading: new Icon(Icons.list),
                      title: Text('Mes trajets'),
                      onTap: () {
                        pushPage(context, MyRequest());
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
          title: new Text(
              "Bienvenue ${Provider.of<repo.UserRepo>(this.context, listen: false).connectedUtilisateur.firstName}"),
        ),
        body: new SingleChildScrollView(
            child: Column(children: [
          Container(
            child: Text(
              'Actualités',
              style: TextStyle(height: 2, fontSize: 30),
            ),
          ),
          Container(
              child: new Column(children: [
            Image(image: AssetImage('assets/voiture.png')),
          ])),
          Container(
            child: Column(
              children: <Widget>[
                new Container(
                    child: new Column(children: [
                  Text(
                    'Besoin de plus d\'informations ?',
                    style: TextStyle(height: 2, fontSize: 25),
                  ),
                ])),
                Container(
                  margin: EdgeInsets.all(16.0),
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(description,
                          maxLines: descTextShowFlag ? 8 : 1,
                          textAlign: TextAlign.start),
                      InkWell(
                        onTap: () {
                          setState(() {
                            descTextShowFlag = !descTextShowFlag;
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            descTextShowFlag
                                ? Text(
                                    "Moins afficher",
                                    style: TextStyle(color: Colors.white38),
                                  )
                                : Text("Tout afficher",
                                    style: TextStyle(color: Colors.white38))
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                    child: Row(children: <Widget>[
                  FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.white)),
                    color: Colors.grey,
                    textColor: Colors.white,
                    padding: EdgeInsets.all(8.0),
                    onPressed: () {
                      pushPage(context, Contact());
                    },
                    child: Text(
                      "     Contactez nous    ".toUpperCase(),
                      style: TextStyle(
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                  FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.white)),
                    color: Colors.grey,
                    textColor: Colors.white,
                    padding: EdgeInsets.all(8.0),
                    onPressed: () {
                      pushPage(context, Data_Management());

                    },
                    child: Text(
                      "Utilisation des données".toUpperCase(),
                      style: TextStyle(
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                ])),
                Container(
                  child: Text('\n'),
                ),
              ],
            ),
          ),
          Container(
              child: new Column(children: [
            Image(image: AssetImage('assets/driver.png')),
          ])),
          Container(
            child: Column(
              children: <Widget>[
                new Container(
                    child: new Column(children: [
                  Text(
                    'Conducteur',
                    style: TextStyle(height: 2, fontSize: 25),
                  ),
                ])),
                Container(
                  margin: EdgeInsets.all(16.0),
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(description1,
                          maxLines: descTextShowFlag1 ? 8 : 1,
                          textAlign: TextAlign.start),
                      InkWell(
                        onTap: () {
                          setState(() {
                            descTextShowFlag1 = !descTextShowFlag1;
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            descTextShowFlag1
                                ? Text(
                                    "Moins afficher",
                                    style: TextStyle(color: Colors.white38),
                                  )
                                : Text("Tout afficher",
                                    style: TextStyle(color: Colors.white38))
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                    child: Row(children: <Widget>[
                  FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.white)),
                    color: Colors.grey,
                    textColor: Colors.white,
                    padding: EdgeInsets.all(8.0),
                    onPressed: () {},
                    child: Text(
                      "     Devenir Conducteur   ".toUpperCase(),
                      style: TextStyle(
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                ])),
              ],
            ),
          ),
        ])));
  }

}
