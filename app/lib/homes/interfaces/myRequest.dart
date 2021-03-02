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


class MyRequest extends StatefulWidget {

    @override
    _MyRequestState createState() => new _MyRequestState();
}

class _MyRequestState extends State<MyRequest> {
    Completer<GoogleMapController> _controller = Completer();

    Driver driver;
    String imageUrl;
    bool _successDriver = false;
    bool _successImage = false;

    static final CameraPosition _kGooglePlex = CameraPosition(
        target: LatLng(37.42796133580664, -122.085749655962),
        zoom: 14.4746,
    );

    static final CameraPosition _kLake = CameraPosition(
        bearing: 192.8334901395799,
        target: LatLng(37.43296265331129, -122.08832357078792),
        tilt: 59.440717697143555,
        zoom: 19.151926040649414
    );

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
                        .where('passengerId', isEqualTo: FirebaseAuth.instance.currentUser.uid)
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
                        initialCameraPosition: _kGooglePlex,
                        onMapCreated: (GoogleMapController controller) {
                            _controller.complete(controller);
                        },
                    ),
                ),
                Image.network(imageUrl, height: 100, fit: BoxFit.scaleDown,),
                Container(
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                color: Colors.grey,
                                width: 0.2,
                            ),
                        )
                    ),
                    width: MediaQuery.of(context).size.width,
                    child: Text(driver.firstName + ' ' + driver.lastName, textScaleFactor: 1.2, textAlign: TextAlign.start),
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
}

class Record {
    final String firstName;
    final String lastName;
    final String start;
    final String destination;
    final String driverId;
    final DocumentReference reference;

    Record.fromMap(Map<String, dynamic> map, {this.reference})
        : assert(map['firstName'] != null),
            assert(map['lastName'] != null),
            assert(map['start'] != null),
            assert(map['destination'] != null),
            assert(map['driverId'] != null),
            firstName = map['firstName'],
            lastName = map['lastName'],
            start = map['start'],
            destination = map['destination'],
            driverId = map['driverId'];

    Record.fromSnapshot(DocumentSnapshot snapshot)
        : this.fromMap(snapshot.data(), reference: snapshot.reference);

    @override
    String toString() => "Trajet<$firstName $lastName\n$start - $destination>";
}
