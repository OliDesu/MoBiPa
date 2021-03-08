import 'dart:async';
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
import 'package:app/Models/driver.dart';
import 'package:url_launcher/url_launcher.dart';


class DoRequest extends StatefulWidget {

    @override
    _DoRequestState createState() => new _DoRequestState();
}

class _DoRequestState extends State<DoRequest> {

    Utilisateur passenger;
    String imageUrl;
    bool _successPassenger = false;
    bool _successImage = false;

    Map<String, Marker> _markers = {};
    GoogleMapController _controller;
    Location _location = Location();

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Text('Mon trajet'),
            ),
            body: Container(
                child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('requests')
                        .where('driverId', isEqualTo: FirebaseAuth.instance.currentUser.uid)
                        .where('status', isEqualTo: 'processing')
                        .snapshots(),
                    builder: (context, snapshot) {
                        if (!snapshot.hasData) return LinearProgressIndicator();
                        else {
                            if (snapshot.data.size == 0){
                                return Text('RAS');
                            }
                            return _buildColumn(context, snapshot.data.docs.elementAt(0));
                        }
                    },
                ),
            ),
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
                    infoWindow: InfoWindow(
                        title: 'Départ',
                        snippet: record.start,
                    ),
                );
                _markers['depart'] = startMarker;
                final destinationMarker = Marker(
                    markerId: MarkerId('Arrivee'),
                    position: LatLng(record.destinationLat, record.destinationLon),
                    infoWindow: InfoWindow(
                        title: 'Arrivée',
                        snippet: record.destination,
                    ),
                );
                _markers['Arrivee'] = destinationMarker;
                final passengerMarker = Marker(
                    markerId: MarkerId('passenger'),
                    position: LatLng(record.passengerLat, record.passengerLon),
                    icon: BitmapDescriptor.fromAsset('assets/directon_icon.png'),
                );
                _markers['passenger'] = passengerMarker;
            });

            _location.onLocationChanged().listen((l) {
                FirebaseFirestore.instance
                    .collection('requests')
                    .doc(record.reference.id)
                    .update({'driverLat': l.latitude});
                FirebaseFirestore.instance
                    .collection('requests')
                    .doc(record.reference.id)
                    .update({'driverLon': l.longitude});
            });
        }

        _getPassenger(record.passengerId);

        if (!_successPassenger || !_successImage) {
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
                                Text(passenger.firstName + ' ' + passenger.lastName, textScaleFactor: 1.2, textAlign: TextAlign.start),
                                Text('Téléphone : ' + passenger.tel, textScaleFactor: 1.2, textAlign: TextAlign.start),
                            ],
                        ),
                    ),
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                        ElevatedButton(
                            onPressed: () => launch("tel://"+passenger.tel),
                            child: Text("Appeler"),
                        ),
                    ],
                ),
            ],
        );
    }

    Future<void> _getPassenger(String passengerId) async {
        await FirebaseFirestore.instance.collection('utilisateur').doc(passengerId).get()
            .then((value) {
            setState(() {
                passenger = Utilisateur.fromJson(value.data());
                _successPassenger = true;
            });
        });

        await firebase_storage.FirebaseStorage.instance.ref().child('images/'+passengerId).getDownloadURL()
            .then((value) {
            setState(() {
                imageUrl = value;
                _successImage = true;
            });
        });
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
    final double passengerLat;
    final double passengerLon;
    final String passengerId;
    final DocumentReference reference;

    Record.fromMap(Map<String, dynamic> map, {this.reference})
        : assert(map['firstName'] != null),
            assert(map['lastName'] != null),
            assert(map['start'] != null),
            assert(map['destination'] != null),
            assert(map['passengerId'] != null),
            assert(map['startLat'] != null),
            assert(map['startLon'] != null),
            assert(map['destinationLat'] != null),
            assert(map['destinationLon'] != null),
            assert(map['passengerLat'] != null),
            assert(map['passengerLon'] != null),
            firstName = map['firstName'],
            lastName = map['lastName'],
            start = map['start'],
            destination = map['destination'],
            startLat = map['startLat'],
            startLon = map['startLon'],
            destinationLat = map['destinationLat'],
            destinationLon = map['destinationLon'],
            passengerId = map['passengerId'],
            passengerLat = map['passengerLat'],
            passengerLon = map['passengerLon'];

    Record.fromSnapshot(DocumentSnapshot snapshot)
        : this.fromMap(snapshot.data(), reference: snapshot.reference);

    @override
    String toString() => "Trajet<$firstName $lastName\n$start - $destination>";
}
