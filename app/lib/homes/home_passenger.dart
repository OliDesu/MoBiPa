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
  StreamSubscription _locationSubscription;
  PickResult selectedPlace;
  Location _locationTracker = Location();
  Marker marker;
  Circle circle;
  GoogleMapController _controller;

  static final CameraPosition initialLocation = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  Future<Uint8List> getMarker() async {
    ByteData byteData =
        await DefaultAssetBundle.of(context).load("assets/directon_icon.png");
    return byteData.buffer.asUint8List();
  }

  void getCurrentLocation() async {
    try {
      Uint8List imageData = await getMarker();
      var location = await _locationTracker.getLocation();

      updateMarkerAndCircle(location, imageData);

      if (_locationSubscription != null) {
        _locationSubscription.cancel();
      }

      _locationSubscription =
          _locationTracker.onLocationChanged().listen((newLocalData) {
        if (_controller != null) {
          _controller.animateCamera(CameraUpdate.newCameraPosition(
              new CameraPosition(
                  bearing: 192.8334901395799,
                  target: LatLng(newLocalData.latitude, newLocalData.longitude),
                  tilt: 0,
                  zoom: 18.00)));
          updateMarkerAndCircle(newLocalData, imageData);
        }
      });
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint("Permission Denied");
      }
    }
  }

  void updateMarkerAndCircle(LocationData newLocalData, Uint8List imageData) {
    LatLng latlng = LatLng(newLocalData.latitude, newLocalData.longitude);
    this.setState(() {
      marker = Marker(
          markerId: MarkerId("home"),
          position: latlng,
          rotation: newLocalData.heading,
          draggable: false,
          zIndex: 2,
          flat: true,
          anchor: Offset(0.5, 0.5),
          icon: BitmapDescriptor.fromBytes(imageData));
      circle = Circle(
          circleId: CircleId("car"),
          radius: newLocalData.accuracy,
          zIndex: 1,
          strokeColor: Colors.blue,
          center: latlng,
          fillColor: Colors.blue.withAlpha(70));
    });
  }

  @override
  void dispose() {
    if (_locationSubscription != null) {
      _locationSubscription.cancel();
    }
    super.dispose();
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
              ElevatedButton(
                child: Text("Load Google Map"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return PlacePicker(
                          apiKey: 'AIzaSyA_urDwozM-H397Dp0uof3Us1zx3oo1aOQ',
                          initialPosition: _PassengerHomeState.kInitialPosition,
                          useCurrentLocation: true,
                          selectInitialPosition: true,

                          //usePlaceDetailSearch: true,
                          onPlacePicked: (result) {
                            selectedPlace = result;
                            Navigator.of(context).pop();
                            setState(() {});
                          },
                        );
                      },
                    ),
                  );
                },
              ),
              selectedPlace == null
                  ? Container()
                  : Text(selectedPlace.formattedAddress ?? ""),
            ],
          ),
        ));
  }
}
