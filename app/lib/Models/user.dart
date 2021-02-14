import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:app/Models/utilisateur.dart';

class UserRepo with ChangeNotifier{
    Utilisateur connectedUtilisateur;

    void studentLogin(Utilisateur loggedInUtilisateur) {
        connectedUtilisateur = loggedInUtilisateur;
        notifyListeners();
    }

    void updateUtilisateur(String field, String updateValue) {
        FirebaseFirestore.instance
            .collection('utilisateur')
            .doc(connectedUtilisateur.userId)
            .update({field: updateValue}).then((result) {
            switch (field) {
                case "firstName":
                    connectedUtilisateur.firstName = updateValue;
                    break;
                case "lastName":
                    connectedUtilisateur.lastName = updateValue;
                    break;
                case "tel":
                    connectedUtilisateur.tel = updateValue;
                    break;
            }
            print("Update $field : $updateValue");
            notifyListeners();
        }).catchError((onError) {
            print("onError");
        });
    }
}
class User {
    String userId;
    String firstName;
    String lastName;
    String tel;

    User (String userId, String firstName, String lastName, String tel) : userId = userId, firstName = firstName, lastName = lastName, tel = tel;
}
