import 'package:app/Models/utilisateurRepository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_fonts/google_fonts.dart';
import 'homes/home_passenger.dart';
import 'homes/home_driver.dart';
import 'package:app/Models/user.dart' as reposit;
import 'package:app/Models/utilisateur.dart';
import 'package:app/Models/driver.dart';
import './main.dart';
import 'package:provider/provider.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

/// Entrypoint example for various sign-in flows with Firebase.
class SignInPage extends StatefulWidget {
  /// The page title.
  final String title = 'Espace de connexion';

  @override
  State<StatefulWidget> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        backgroundColor: Colors.white38,
        actions: <Widget>[
          Builder(builder: (BuildContext context) {
            return FlatButton(
              textColor: Colors.black,
              onPressed: () async {
                final User user = _auth.currentUser;
                if (user == null) {
                  Scaffold.of(context).showSnackBar(const SnackBar(
                    content: Text('No one has signed in.'),
                  ));
                  return;
                }
                await _signOut();

                final String uid = user.uid;
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text('$uid has successfully signed out.'),
                ));
              },
              child: const Text('Sign out'),
            );
          })
        ],
      ),
      body: Builder(builder: (BuildContext context) {
        return ListView(
          padding: const EdgeInsets.all(8),
          children: <Widget>[
        Container(
        child: new Column(children: [
        Image(image: AssetImage('assets/signin.png')),
        ])),
            _EmailPasswordForm(),
          ],
        );
      }),
    );
  }

  // Example code for sign out.
  Future<void> _signOut() async {
    await _auth.signOut();
  }
}

class _EmailPasswordForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _EmailPasswordFormState();
}

class _EmailPasswordFormState extends State<_EmailPasswordForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _pushPage(BuildContext context, Widget page) {
    Navigator.of(context) /*!*/ .push(
      MaterialPageRoute<void>(builder: (_) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(


        key: _formKey,
        child: Card(
          color: Color.fromRGBO(123, 75, 227, 1),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(

                  alignment: Alignment.center,
                  child: const Text(
                    'Connexion',
                  ),
                ),
                Text('\n'),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  cursorColor: Colors.white,
                  validator: (String value) {
                    if (value.isEmpty) return 'Veuillez entrer votre Email';
                    return null;
                  },
                ),
                Text('\n'),

                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Mot de passe'),
                  validator: (String value) {
                    if (value.isEmpty) return 'Veuillez entrer votre mot de passe';
                    return null;
                  },
                  obscureText: true,
                ),
                Container(
                  padding: const EdgeInsets.only(top: 16),
                  alignment: Alignment.center,

                  child: Container(
                      height: 60.0,
                      margin: EdgeInsets.all(10),
                      child : Center(
                        child: RaisedButton(
                          onPressed: () async {if (_formKey.currentState.validate()) {await _signInWithEmailAndPassword();}},
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(80.0)),
                          padding: EdgeInsets.all(0.0),
                          child: Ink(
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Color(0xff6720fa), Color(0xff9670e6)],                        begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                                borderRadius: BorderRadius.circular(30.0)),
                            child: Container(
                              constraints: BoxConstraints(maxWidth: 250.0, minHeight: 50.0),
                              alignment: Alignment.center,
                              child: Text(
                                "Suivant",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white, fontSize: 15),
                              ),
                            ),
                          ),
                        ),
                      )

                  ),
                ),
              ],
            ),
          ),
        ));
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Example code of how to sign in with email and password.
  Future<void> _signInWithEmailAndPassword() async {
    try {
      final User user = (await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      ))
          .user;

      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('${user.email} signed in'),
        ),
      );
      // Ajouter le choix d'identification
      DocumentSnapshot utilisateur = await FirebaseFirestore.instance
          .collection('utilisateur')
          .doc(user.uid)
          .get();
      if (utilisateur.exists) {
          Utilisateur newUtilisateur = Utilisateur.fromJson(utilisateur.data());
          Provider.of<reposit.UserRepo>(context, listen: false).utilisateurLogin(newUtilisateur);
        _pushPage(context, PassengerHome());
      } else {
          DocumentSnapshot driver = await FirebaseFirestore.instance
              .collection('conducteur')
              .doc(user.uid)
              .get();
          if (driver.exists) {
              Driver newDriver = Driver.fromJson(driver.data());
              Provider.of<reposit.UserRepo>(context, listen: false).driverLogin(newDriver);
              _pushPage(context, DriverHome());
          } else {
              throw 'Error: user not found';
          }
      }
    } catch (e) {
      Scaffold.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to sign in with Email & Password'),
        ),
      );
    }
  }
}
