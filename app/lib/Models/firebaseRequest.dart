import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FirebaseRequest {
  String firstName;
  String lastName;
  String date;
  String status;
  String start;
  String destination;
  double startLat;
  double startLon;
  double destinationLat;
  double destinationLon;
  double passengerLat;
  double passengerLon;
  double driverLat;
  double driverLon;
  String driverId;
  String passengerId;

  FirebaseRequest(String start, String destination, double startLat, double startLon, double destinationLat, double destinationLon) {
    this.start = start;
    this.destination = destination;
    this.startLat = startLat;
    this.startLon = startLon;
    this.destinationLat = destinationLat;
    this.destinationLon = destinationLon;
    this.passengerLat = null;
    this.passengerLon = null;
    this.driverLat = null;
    this.driverLon = null;
    this.status = 'open';
    this.passengerId = FirebaseAuth.instance.currentUser.uid;
    this.driverId = null;
    this.date = DateFormat('y/MM/dd HH:mm').format(new DateTime.now());
  }

  factory FirebaseRequest.fromJson(Map<String, dynamic> json) {
    return FirebaseRequest(json['start'], json['destination'], json['startLat'], json['startLon'], json['destinationLat'], json['destinationLon']);
  }

  Map<String, dynamic> toJson() => {
        'firstName': firstName,
        'lastName': lastName,
        'date': date,
        'status': status,
        'start': start,
        'driverId': driverId,
        'passengerId': passengerId,
        'destination': destination,
        'startLat': startLat,
        'startLon': startLon,
        'destinationLat': destinationLat,
        'destinationLon': destinationLon,
        'passengerLat': passengerLat,
        'passengerLon': passengerLon,
        'driverLat': driverLat,
        'driverLon': driverLon
      };

  void updateFirebaseRequest(String field, String updateValue, String id) {
    FirebaseFirestore.instance
        .collection('requests')
        .doc(id)
        .update({field: updateValue});
  }

  Future<bool> getName(String userId) async {
    return FirebaseFirestore.instance
        .collection('utilisateur')
        .doc(userId)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        this.firstName = documentSnapshot.data()['firstName'];
        this.lastName = documentSnapshot.data()['lastName'];
        return true;
      } else {
        print('Document does not exist in the database');
        return false;
      }
    });
  }


  Future<bool> getRequest() async {
    return FirebaseFirestore.instance
        .collection('requests')
        .where('status',isEqualTo: 'open')
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
          this.firstName=querySnapshot.docs.first.data()['firstName'];
          this.lastName=querySnapshot.docs.first.data()['lastName'];
          this.destination=querySnapshot.docs.first.data()['destination'];
          this.date=querySnapshot.docs.first.data()['date'];
          this.start=querySnapshot.docs.first.data()['start'];
          this.startLat=querySnapshot.docs.first.data()['startLat'];
          this.startLon=querySnapshot.docs.first.data()['startLon'];
          this.destinationLat=querySnapshot.docs.first.data()['destinationLat'];
          this.destinationLon=querySnapshot.docs.first.data()['destinationLon'];
          this.passengerLat=querySnapshot.docs.first.data()['passengerLat'];
          this.passengerLon=querySnapshot.docs.first.data()['passengerLon'];
          this.driverLat=querySnapshot.docs.first.data()['driverLat'];
          this.driverLat=querySnapshot.docs.first.data()['driverLon'];


        return true;
      } else {
        print('Document does not exist in the database');
        return false;
      }
    });
  }



}
