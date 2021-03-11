import 'dart:async';
import 'dart:typed_data';
import 'package:app/Models/firebaseRequest.dart';
import 'package:app/Models/utilisateur.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
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
import 'package:app/Models/driver.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:ui' as ui;


class MyRequest extends StatefulWidget {

    @override
    _MyRequestState createState() => new _MyRequestState();
}

class _MyRequestState extends State<MyRequest> {

    Driver driver;
    String imageUrl;
    bool _successDriver = false;
    bool _successImage = false;

    Map<String, Marker> _markers = {};
    GoogleMapController _controller;
    Location _location = Location();

    Uint8List mapsMarkerIcon;
    Uint8List driverMarkerIcon;


    @override
  void initState() {
    super.initState();
    loadMarkers();
  }

  void loadMarkers() async {
        mapsMarkerIcon = await getBytesFromAsset('assets/maps_marker.png', 100);
        driverMarkerIcon = await getBytesFromAsset('assets/car_icon.png', 50);
  }


    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                centerTitle: true,
                backgroundColor: Colors.white38,
                title: Text('Mon trajet'),
            ),
            body: Container(
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
                                return _buildReturn(context);
                            }
                            return _buildColumn(context, snapshot.data.docs.elementAt(0));
                        }
                    },
                ),
            ),
        );
    }
    Widget _buildReturn(BuildContext context){
        return Column(
            children: [

                Image.asset('assets/notfound.png'),
                Text('Aucun trajet n\'est disponible',style: TextStyle(fontSize: 25),),
            ],
        );
    }
    Widget _buildColumn(BuildContext context, DocumentSnapshot data) {
        Record record = Record.fromSnapshot(data);

        void _onMapCreated(GoogleMapController controller) {
            _controller = controller;
            _markers.clear();
            setState(() {
                final startMarker = Marker(
                    markerId: MarkerId('depart'),
                    position: LatLng(record.startLat, record.startLon),
                    icon: BitmapDescriptor.fromBytes(mapsMarkerIcon),
                    infoWindow: InfoWindow(
                        title: 'Départ',
                        snippet: record.start,
                    ),
                );
                _markers['depart'] = startMarker;
                final destinationMarker = Marker(
                    markerId: MarkerId('Arrivee'),
                    position: LatLng(record.destinationLat, record.destinationLon),
                    icon: BitmapDescriptor.fromBytes(mapsMarkerIcon),
                    infoWindow: InfoWindow(
                        title: 'Arrivée',
                        snippet: record.destination,
                    ),
                );
                _markers['Arrivee'] = destinationMarker;
                final driverMarker = Marker(
                    markerId: MarkerId('driver'),
                    position: LatLng(record.driverLat, record.driverLon),
                    icon: BitmapDescriptor.fromBytes(driverMarkerIcon),
                );
                _markers['driver'] = driverMarker;
            });

            _location.onLocationChanged().listen((l) {
                FirebaseFirestore.instance
                    .collection('requests')
                    .doc(record.reference.id)
                    .update({'passengerLat': l.latitude});
                FirebaseFirestore.instance
                    .collection('requests')
                    .doc(record.reference.id)
                    .update({'passengerLon': l.longitude});
            });
        }

        _getDriver(record.driverId);

        if (!_successDriver || !_successImage) {
            return Center(
                child: CircularProgressIndicator(),
            );
        }

        return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget> [
                Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue),
                        borderRadius: BorderRadius.circular(8.0),
                    ),
                    height: MediaQuery.of(context).size.height/2,
                    child: GoogleMap(
                        onMapCreated: _onMapCreated,
                        initialCameraPosition: CameraPosition(
                            target: LatLng(record.startLat, record.startLon),
                            zoom: 15,
                        ),
                        markers: _markers.values.toSet(),
                        myLocationEnabled: true,
                    ),
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text('Votre conducteur : ',textScaleFactor: 1.2, textAlign: TextAlign.start),
                ),
                Image.network(imageUrl, height: 100, fit: BoxFit.scaleDown),
                Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Container(
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color: Colors.grey,
                                    width: 0.2,
                                ),
                            ),
                        ),
                        width: MediaQuery.of(context).size.width,
                        child:  Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                                Text(driver.firstName + ' ' + driver.lastName, textScaleFactor: 1.2, textAlign: TextAlign.start),
                                Text('Tel : ' + driver.tel, textScaleFactor: 1.2, textAlign: TextAlign.start),
                            ],
                        ),
                    ),
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                        ElevatedButton(
                            onPressed: () => launch("tel://"+driver.tel),
                            child: Text("Appeler"),
                        ),
                    ],
                ),
            ],
        );
    }

    Future<void> _getDriver(String driverId) async {
        await FirebaseFirestore.instance.collection('conducteur').doc(driverId).get()
            .then((value) {
            setState(() {
                driver = Driver.fromJson(value.data());
                _successDriver = true;
            });
        });

        await firebase_storage.FirebaseStorage.instance.ref().child('images/'+driverId).getDownloadURL()
            .then((value) {
            setState(() {
                imageUrl = value;
                _successImage = true;
            });
        });
    }

    Future<Uint8List> getBytesFromAsset(String path, int width) async {
        ByteData data = await rootBundle.load(path);
        ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
        ui.FrameInfo fi = await codec.getNextFrame();
        return (await fi.image.toByteData(format: ui.ImageByteFormat.png)).buffer.asUint8List();
    }
}

class Record {
    final String firstName;
    final String lastName;
    final String start;
    final String destination;
    final double startLat;
    final double startLon;
    final double destinationLat;
    final double destinationLon;
    final double driverLat;
    final double driverLon;
    final String driverId;
    final DocumentReference reference;

    Record.fromMap(Map<String, dynamic> map, {this.reference})
        : assert(map['firstName'] != null),
            assert(map['lastName'] != null),
            assert(map['start'] != null),
            assert(map['destination'] != null),
            assert(map['driverId'] != null),
            assert(map['startLat'] != null),
            assert(map['startLon'] != null),
            assert(map['destinationLat'] != null),
            assert(map['destinationLon'] != null),
            assert(map['driverLat'] != null),
            assert(map['driverLon'] != null),
            firstName = map['firstName'],
            lastName = map['lastName'],
            start = map['start'],
            destination = map['destination'],
            startLat = map['startLat'],
            startLon = map['startLon'],
            destinationLat = map['destinationLat'],
            destinationLon = map['destinationLon'],
            driverId = map['driverId'],
            driverLat = map['driverLat'],
            driverLon = map['driverLon'];

    Record.fromSnapshot(DocumentSnapshot snapshot)
        : this.fromMap(snapshot.data(), reference: snapshot.reference);

    @override
    String toString() => "Trajet<$firstName $lastName\n$start - $destination>";
}
