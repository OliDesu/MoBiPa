import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:app/Models/utilisateur.dart';

class UserRepo {
    Utilisateur connectedUtilisateur;

    void studentLogin(Student loggedInStudent) {
        connectedUtilisateur = loggedInStudent;
    }
}

class User {
    String userId;
    String firstName;
    String lastName;
    String tel;

    User (String userId, String firstName, String lastName, String tel) : userId = userId, firstName = firstName, lastName = lastName, tel = tel;
}
