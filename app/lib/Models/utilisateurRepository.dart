import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:app/Models/utilisateur.dart';
import 'package:app/Models/firebaseRequest.dart';

class UtilisateurRepository with ChangeNotifier {
    Utilisateur user;


    void initRepo (Utilisateur connected){
        user = connected;
    }

}
