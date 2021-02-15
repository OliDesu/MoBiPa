import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_signin_button/button_builder.dart';
import 'package:app/Models/utilisateur.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;

final FirebaseAuth _auth = FirebaseAuth.instance;

enum RegisterType { USER, DRIVER }

class RegisterPage extends StatefulWidget {
    final String title = 'Registration';

    @override
    State<StatefulWidget> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    final TextEditingController _emailController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();
    final TextEditingController _passwordConfirmController = TextEditingController();
    final TextEditingController _lastNameController = TextEditingController();
    final TextEditingController _firstNameController = TextEditingController();
    final TextEditingController _phoneNumberController = TextEditingController();

    firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instanceFor();
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref().child('images');

    File _image;
    String _uploadedFileURL;

    bool _success;
    String _userEmail = '';

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Text(widget.title),
            ),
            body: Center(
              child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        width: kIsWeb ? 500 : MediaQuery.of(context).size.width * 0.9,
                        height: kIsWeb ? 800 : null,
                        child: _userForm(),
                    ),
                  ),
              ),
            ),
        );
    }

    @override
    void dispose() {
        // Clean up the controller when the Widget is disposed
        _emailController.dispose();
        _passwordController.dispose();
        super.dispose();
    }

    // Example code for registration.
    Future<void> _register() async {
        final User user = (await _auth.createUserWithEmailAndPassword(
            email: _emailController.text,
            password: _passwordController.text,
        ))
            .user;
        Utilisateur newUtilisateur = Utilisateur(user.uid,_firstNameController.text,_lastNameController.text,_phoneNumberController.text);
        FirebaseFirestore.instance.collection('utilisateur').doc(user.uid).set(newUtilisateur.toJson());
        if (user != null) {
            firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref().child('images/${user.uid}');
            firebase_storage.UploadTask uploadTask = ref.putFile(_image);
            uploadTask.whenComplete(() =>
                setState(() {
                    _success = true;
                    _userEmail = user.email;
                })
            );
        } else {
            _success = false;
        }
    }

    Widget _userForm() {
        return Form(
            key: _formKey,
            child: Card(
                child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
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
                            TextFormField(
                                controller: _passwordController,
                                decoration: const InputDecoration(labelText: 'Mot de passe'),
                                validator: (String value) {
                                    if (value.isEmpty) {
                                        return 'Veuillez saisir votre mot de passe';
                                    }
                                    return null;
                                },
                                obscureText: true,
                            ),
                            TextFormField(
                                controller: _passwordConfirmController,
                                decoration: const InputDecoration(labelText: 'Confirmez votre mot de passe'),
                                validator: (String value) {
                                    if (value.isEmpty || value != _passwordController.text) {
                                        return 'Vérifiez votre mot de passe';
                                    }
                                    return null;
                                },
                                obscureText: true,
                            ),
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
                            _image != null ? Image.asset(_image.path, height: 150,)
                                :Container(),
                            _image == null ? ElevatedButton(onPressed: chooseFile, child: Text('Choisissez une photo de profil'))
                                :Container(),
                            Container(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                alignment: Alignment.center,
                                child: SignInButtonBuilder(
                                    icon: Icons.person_add,
                                    backgroundColor: Colors.blueGrey,
                                    onPressed: () async {
                                        if (_formKey.currentState.validate()) {
                                            await _register();
                                        }
                                    },
                                    text: 'Register',
                                ),
                            ),
                            Container(
                                alignment: Alignment.center,
                                child: Text(_success == null
                                    ? ''
                                    : (_success
                                    ? 'Successfully registered $_userEmail'
                                    : 'Registration failed')),
                            )
                        ],
                    ),
                ),
            ),
        );
    }

    Future chooseFile() async {
        await ImagePicker.pickImage(source: ImageSource.gallery).then((image) {
            setState(() {
              _image = image;
            });
        });
    }
}
