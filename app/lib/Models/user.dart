import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:app/Models/utilisateur.dart';
import 'package:app/Models/driver.dart';

class UserRepo with ChangeNotifier{
    Utilisateur connectedUtilisateur;
    Driver connectedDriver;

    void utilisateurLogin(Utilisateur loggedIn){
        connectedUtilisateur = loggedIn;
        notifyListeners();
    }

    void driverLogin(Driver loggedIn){
        connectedDriver = loggedIn;
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
            notifyListeners();
        }).catchError((onError) {
            print(onError.toString());
        });
    }

    void updateRequestsUtilisateur() {
        FirebaseFirestore.instance
            .collection('utilisateur')
            .doc(connectedUtilisateur.userId)
            .update({"requests": FieldValue.arrayUnion(connectedUtilisateur.requests)}).then((result) {
            notifyListeners();
        }).catchError((onError) {
            print(onError.toString());
        });
    }

    void updateDriver(String field, String updateValue) {
        FirebaseFirestore.instance
            .collection('conducteur')
            .doc(connectedDriver.userId)
            .update({field: updateValue}).then((result) {
                switch (field) {
                    case "firstName" :
                        connectedDriver.firstName = updateValue;
                        break;
                    case "lastName" :
                        connectedDriver.lastName = updateValue;
                        break;
                    case "tel" :
                        connectedDriver.tel = updateValue;
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
