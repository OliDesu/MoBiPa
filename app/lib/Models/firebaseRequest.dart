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

  FirebaseRequest(String start, String destination) {
    this.start = start;
    this.destination = destination;
    this.status = 'open';
    this.date = DateFormat('y/MM/dd HH:mm').format(new DateTime.now());

    FirebaseFirestore.instance
        .collection('utilisateur')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get()
        .then((value) {
      this.firstName = value.data()['firstName'];
    });
    FirebaseFirestore.instance
        .collection('utilisateur')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get()
        .then((value) {
      this.lastName = value.data()['lastName'];
    });
  }

  factory FirebaseRequest.fromJson(Map<String, dynamic> json) {
    return FirebaseRequest(json['start'], json['destination']);
  }

  Map<String, dynamic> toJson() => {
        'firstName': firstName,
        'lastName': lastName,
        'date': date,
        'status': status,
        'start': start,
        'destination': destination
      };

  void updateFirebaseRequest(String field, String updateValue) {
    FirebaseFirestore.instance
        .collection('requests')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .update({field: updateValue});
  }
}
