import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:app/Models/driver.dart';
import 'package:app/Models/firebaseRequest.dart';

class DriverRepository with ChangeNotifier {
    Driver user;


    void initRepo (Driver connected){
        user = connected;
    }

}
