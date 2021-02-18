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

    FirebaseRequest(String firstName, String lastName, String start, String destination)
        : firstName = firstName, lastName = lastName, date = DateFormat('y/MM/dd HH:mm').format(new DateTime.now()), status = 'open', start = start, destination = destination;

    factory FirebaseRequest.fromJson(Map<String, dynamic> json){
        return FirebaseRequest(
            json['firstName'],
            json['lastName'],
            json['start'],
            json['destination']
        );
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
