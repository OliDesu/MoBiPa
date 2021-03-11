import 'dart:async';
import 'dart:typed_data';
import 'package:app/Models/firebaseRequest.dart';
import 'package:app/Models/utilisateur.dart';
import 'package:app/homes/home_driver.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:app/Models/firebaseRequest.dart';
import 'package:app/Models/user.dart' as repo;
import 'package:provider/provider.dart';
import 'package:app/Models/driver.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:ui' as ui;


enum Status {
    open,
    processing,
    picked,
    closed
}

class DoRequest extends StatefulWidget {

    @override
    _DoRequestState createState() => new _DoRequestState();
}

class _DoRequestState extends State<DoRequest> {


    Utilisateur passenger;
    String imageUrl;
    bool _successPassenger = false;
    bool _successImage = false;

    Status _status = Status.open;

    Map<String, Marker> _markers = {};
    Set<Polyline> _polylines = {};
    List<LatLng> polylineCoordinates = [];
    PolylinePoints polylinePoints = PolylinePoints();
    GoogleMapController _controller;
    Location _location = Location();

    Uint8List mapsMarkerIcon;
    Uint8List passengerMarkerIcon;

    @override
  void initState() {
    super.initState();
    loadMarkers();
  }

    void loadMarkers() async {
        mapsMarkerIcon = await getBytesFromAsset('assets/maps_marker.png', 100);
        passengerMarkerIcon = await getBytesFromAsset('assets/passenger_marker.png', 75);
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                centerTitle: true,
                backgroundColor: Colors.white38,
                title: Text('Mon trajet'),
                leading: IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => DriverHome()),
                        );
                    },
                ),
            ),
            body: Container(
                child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('requests')
                        .where('driverId', isEqualTo: FirebaseAuth.instance.currentUser.uid)
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
            _polylines.clear();
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
                final passengerMarker = Marker(
                    markerId: MarkerId('passenger'),
                    position: LatLng(record.passengerLat, record.passengerLon),
                    icon: BitmapDescriptor.fromBytes(passengerMarkerIcon),
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

            setPolylines(record);
        }

        _getPassenger(record.passengerId);

        switch (record.status) {
            case 'open' :
                _status = Status.open;
                break;
            case 'processing' :
                _status = Status.processing;
                break;
            case 'picked' :
                _status = Status.picked;
                break;
            case 'closed' :
                _status = Status.closed;
                break;
        }

        if (!_successPassenger || !_successImage) {
            return Center(
                child: CircularProgressIndicator(),
            );
        }

        if (_status == Status.processing) {
            return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                    Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.blue),
                            borderRadius: BorderRadius.circular(8.0),
                        ),
                        height: MediaQuery
                            .of(context)
                            .size
                            .height / 2,
                        child: GoogleMap(
                            onMapCreated: _onMapCreated,
                            initialCameraPosition: CameraPosition(
                                target: LatLng(
                                    record.startLat, record.startLon),
                                zoom: 15,
                            ),
                            markers: _markers.values.toSet(),
                            myLocationEnabled: true,
                        ),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text('Votre passager : ', textScaleFactor: 1.2,
                            textAlign: TextAlign.start),
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
                            width: MediaQuery
                                .of(context)
                                .size
                                .width,
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
                                children: <Widget>[
                                    Text(passenger.firstName + ' ' +
                                        passenger.lastName,
                                        textScaleFactor: 1.2,
                                        textAlign: TextAlign.start),
                                    Text('Tel : ' + passenger.tel,
                                        textScaleFactor: 1.2,
                                        textAlign: TextAlign.start),
                                ],
                            ),
                        ),
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                            ElevatedButton(
                                onPressed: () =>
                                    launch("tel://" + passenger.tel),
                                child: Text("Appeler"),
                            ),
                        ],
                    ),
                    FloatingActionButton(
                        onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    AlertDialog(
                                        title: Text('Validation'),
                                        content: Text(
                                            'Avez-vous bien récupéré ${passenger
                                                .firstName} ?'),
                                        actions: <Widget>[
                                            ElevatedButton(
                                                onPressed: () async {
                                                    await record.reference
                                                        .update(
                                                        {'status': 'picked'});
                                                    Navigator.of(context).push(
                                                        MaterialPageRoute(builder: (_) => DoRequest())
                                                    );
                                                },
                                                child: Text('Oui')
                                            ),
                                            ElevatedButton(
                                                onPressed: () {
                                                    Navigator.of(context).pop();
                                                },
                                                child: Text('Non'))
                                        ],
                                    )
                            );
                        },
                        child: Icon(Icons.check, color: Colors.white),
                        backgroundColor: Colors.green,
                    ),
                ],
            );
        }
        else if (_status == Status.picked) {
            return Stack(
                children: <Widget> [
                    GoogleMap(
                        onMapCreated: _onMapCreated,
                        initialCameraPosition: CameraPosition(
                            target: LatLng(
                                record.startLat, record.startLon),
                            zoom: 15,
                        ),
                        markers: _markers.values.toSet(),
                        polylines: _polylines,
                        myLocationEnabled: true,
                    ),
                    Align(
                        alignment: Alignment.bottomLeft,
                        child: FloatingActionButton(
                            onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                            title: Text('Validation'),
                                            content: Text(
                                                'Avez-vous bien déposé ${passenger
                                                    .firstName} ?'),
                                            actions: <Widget>[
                                                ElevatedButton(
                                                    onPressed: () async {
                                                        await record.reference
                                                            .delete();
                                                        Navigator.of(context).push(
                                                            MaterialPageRoute(builder: (_) => DoRequest())
                                                        );
                                                    },
                                                    child: Text('Oui')
                                                ),
                                                ElevatedButton(
                                                    onPressed: () {
                                                        Navigator.of(context).pop();
                                                    },
                                                    child: Text('Non'))
                                            ],
                                        )
                                );
                            },
                            child: Icon(Icons.check,color: Colors.white),
                            backgroundColor: Colors.blue,
                        ),
                    ),
                ],
            );
        }
        else {
            return Center(
                child: Wrap(
                    children: <Widget>[
                        Container(
                            height: MediaQuery.of(context).size.height*0.20,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Center(
                                child: Align(
                                    alignment: Alignment.center,
                                    child: Text('Vous n\'avez pas de course actuellement'),
                                ),
                            ),
                        ),
                    ],
                ),
            );
        }
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

    Future<Uint8List> getBytesFromAsset(String path, int width) async {
        ByteData data = await rootBundle.load(path);
        ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
        ui.FrameInfo fi = await codec.getNextFrame();
        return (await fi.image.toByteData(format: ui.ImageByteFormat.png)).buffer.asUint8List();
    }

    TValue case2<TOptionType, TValue>(
        TOptionType selectedOption,
        Map<TOptionType, TValue> branches, [
            TValue defaultValue = null,
        ]) {
        if (!branches.containsKey(selectedOption)) {
            return defaultValue;
        }

        return branches[selectedOption];
    }

    void setPolylines(Record record) async {

        List<PointLatLng> result = await
        polylinePoints?.getRouteBetweenCoordinates(
            'AIzaSyADXtEYlr02LSSaESs4-tB2yGh0pdtPu0c',
            record.startLat,
            record.startLon,
            record.destinationLat,
            record.destinationLon);

        if (result.isNotEmpty) {
            result.forEach((PointLatLng point) {
                polylineCoordinates.add(LatLng(point.latitude, point.longitude));
            });
        }

        setState(() {
            Polyline polyline = Polyline(
                polylineId: PolylineId('trajet'),
                color: Colors.blue,
                points: polylineCoordinates
            );
            _polylines.add(polyline);
        });
    }

}

class Record {
    final String status;
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
            assert(map['status'] != null),
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
            status = map['status'],
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
