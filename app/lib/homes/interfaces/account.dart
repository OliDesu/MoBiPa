import 'dart:async';
import 'dart:typed_data';
import 'package:app/Models/firebaseRequest.dart';
import 'package:app/Models/utilisateur.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_signin_button/button_builder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:app/Models/firebaseRequest.dart';
import 'package:app/Models/user.dart' as repo;
import 'package:provider/provider.dart';

class Account extends StatefulWidget {
  @override
  _AccountState createState() => new _AccountState();
}

class _AccountState extends State<Account> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  @override
  void initState()  {
    super.initState();
    initData();


  }
  Future <void>initData() async{
  final User user = _auth.currentUser;
  DocumentSnapshot utilisateur = await FirebaseFirestore.instance
      .collection('utilisateur')
      .doc(user.uid)
      .get();
  if (utilisateur.exists) {
    _emailController.text = FirebaseAuth.instance.currentUser.email;
    _firstNameController.text = Provider.of<repo.UserRepo>(this.context, listen: false).connectedUtilisateur.firstName;
    _lastNameController.text = Provider.of<repo.UserRepo>(this.context, listen: false).connectedUtilisateur.lastName;
    _phoneNumberController.text = Provider.of<repo.UserRepo>(this.context, listen: false).connectedUtilisateur.tel;
  }
  else{
    _emailController.text = FirebaseAuth.instance.currentUser.email;
    _firstNameController.text = Provider.of<repo.UserRepo>(this.context, listen: false).connectedDriver.firstName;
    _lastNameController.text = Provider.of<repo.UserRepo>(this.context, listen: false).connectedDriver.lastName;
    _phoneNumberController.text = Provider.of<repo.UserRepo>(this.context, listen: false).connectedDriver.tel;
  }
}

  void pushPage(BuildContext context, Widget page) {
    Navigator.of(context) /*!*/ .push(
      MaterialPageRoute<void>(builder: (_) => page),
    );
  }

  Future<void> _update() async {
    final User user = _auth.currentUser;

    user.updateEmail("user@example.com");

    DocumentSnapshot utilisateur = await FirebaseFirestore.instance
        .collection('utilisateur')
        .doc(user.uid)
        .get();
    if (utilisateur.exists) {
      Provider.of<repo.UserRepo>(context, listen: false).updateUtilisateur('firstName', _firstNameController.text);
      Provider.of<repo.UserRepo>(context, listen: false).updateUtilisateur('lastName', _lastNameController.text);
      Provider.of<repo.UserRepo>(context, listen: false).updateUtilisateur('tel', _phoneNumberController.text);
      user.updateEmail(_emailController.text);


    }
    else{
      Provider.of<repo.UserRepo>(context, listen: false).updateDriver('firstName', _firstNameController.text);
      Provider.of<repo.UserRepo>(context, listen: false).updateDriver('lastName', _lastNameController.text);
      Provider.of<repo.UserRepo>(context, listen: false).updateDriver('tel', _phoneNumberController.text);
      user.updateEmail(_emailController.text);
    }


  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(

        appBar: new AppBar(
          backgroundColor: Colors.white38,
          centerTitle: true,

          title: new Text("Mon compte "),
        ),
        body: new Form(
      key: _formKey,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Image.asset('assets/account.png'),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (String value) {
                  if (value.isEmpty) {
                    return 'Veuillez entrer du texte';
                  }
                  return null;
                },
              ),
Text('\n'),
              TextFormField(
                controller: _lastNameController,
                decoration: const InputDecoration(labelText: 'Nom de famille'),
                validator: (String value) {
                  if (value.isEmpty) {
                    return 'Veuillez indiquer votre nom de famille';
                  }
                  return null;
                },
              ),
              Text('\n'),
              TextFormField(
                controller: _firstNameController,
                decoration: const InputDecoration(labelText: 'Prénom'),
                validator: (String value) {
                  if (value.isEmpty) {
                    return 'Veuillez indiquer votre prénom';
                  }
                  return null;
                },
              ),
              Text('\n'),
              TextFormField(
                controller: _phoneNumberController,
                decoration: const InputDecoration(labelText: 'Numéro de téléphone'),
                validator: (String value) {
                  if (value.isEmpty) {
                    return 'Veuillez indiquer votre numéro de téléphone';
                  }
                  return null;
                },
              ),


              Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                alignment: Alignment.center,
                child: RaisedButton(
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      await _update();
                    }
                    Navigator.pop(context);
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(60.0)),
                  padding: EdgeInsets.all(0.0),
                  child: Ink(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0x6e46e3), Color(0x6e46e3)],


                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(30.0)),
                    child: Container(
                      constraints: BoxConstraints(maxWidth: 200.0, minHeight: 50.0),
                      alignment: Alignment.center,
                      child: Text(
                        "Sauvegarder",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,

              )
            ],
          ),
        ),
      ),
    ));
  }
}


