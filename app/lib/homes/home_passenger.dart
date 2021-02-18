import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';

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
          title: new Text("Bienvenue **Ajouter nom utilisateur**"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              selectedPlaceStart == null
                  ? Container()
                  : Text("Adresse de départ : " +
                          selectedPlaceStart.formattedAddress ??
                      ""),
              selectedPlaceEnd == null
                  ? Container()
                  : Text("Adresse d'arrivée : " +
                          selectedPlaceEnd.formattedAddress ??
                      "")
            ],
          ),
        ));
  }
}
