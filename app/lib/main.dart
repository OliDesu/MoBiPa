import 'package:app/Models/utilisateurRepository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_builder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import './register_page.dart';
import './signin_page.dart';

import 'package:app/Models/user.dart';
import 'package:app/Models/utilisateurRepository.dart';
import 'package:app/Models/driverRepository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // Uncomment this to use the auth emulator for testing
  // await FirebaseAuth.instance.useEmulator('http://localhost:9099');
  runApp(AuthExampleApp());
}

/// The entry point of the application.
///
/// Returns a [MaterialApp].
class AuthExampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserRepo>(create: (_) => UserRepo()),
        ChangeNotifierProvider<UtilisateurRepository>(
          create: (_) => UtilisateurRepository(),
        ),
        ChangeNotifierProvider<DriverRepository>(
          create: (_) => DriverRepository(),
        ),
      ],
      child: MaterialApp(
        title: 'Firebase Example App',
        theme: ThemeData.dark(),
        home: Scaffold(
          body: AuthTypeSelector(),
        ),
      ),
    );
  }
}

/// Provides a UI to select a authentication type page
class AuthTypeSelector extends StatelessWidget {
  // Navigates to a new page
  void _pushPage(BuildContext context, Widget page) {
    Navigator.of(context) /*!*/ .push(
      MaterialPageRoute<void>(builder: (_) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white38,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white38,
        title: new Text('Espace de connexion', textAlign: TextAlign.center),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
              child: new Column(children: [
            Image(image: AssetImage('assets/walking.png')),
          ])),
          Container(
              child: Center(
                  child: Text(
            '\n Bienvenue sur MobiPA \n',
            textAlign: TextAlign.center,
            style: GoogleFonts.raleway(
              fontSize: 32,
            ),
          ))),
          Container(
              height: 60.0,

              margin: EdgeInsets.all(10),
              child : Center(
                child: RaisedButton(
                  onPressed: () {
                    _pushPage(context, SignInPage());
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(80.0)),
                  padding: EdgeInsets.all(0.0),
                  child: Ink(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xfff5497b), Color(0xffeb7c9c)],


                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(30.0)),
                    child: Container(
                      constraints: BoxConstraints(maxWidth: 250.0, minHeight: 50.0),
                      alignment: Alignment.center,
                      child: Text(
                        "Se connecter",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ),
                  ),
                ),
              )

          ),
          Container(
            height: 60.0,
            margin: EdgeInsets.all(10),
            child : Center(
              child: RaisedButton(
                onPressed: () {
                   _pushPage(context, RegisterPage());
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(80.0)),
                padding: EdgeInsets.all(0.0),
                child: Ink(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xff374ABE), Color(0xff64B6FF)],                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(30.0)),
                  child: Container(
                    constraints: BoxConstraints(maxWidth: 250.0, minHeight: 50.0),
                    alignment: Alignment.center,
                    child: Text(
                      "S'inscrire",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ),
                ),
              ),
    )

          ),
        ],
      ),

      /*
            body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                    Container(
                        padding: const EdgeInsets.all(16),
                        alignment: Alignment.center,
                        child: SignInButtonBuilder(
                            icon: Icons.person_add,
                            backgroundColor: Colors.indigo,
                            text: 'Registration',
                            onPressed: () => _pushPage(context, RegisterPage()),
                        ),
                    ),
                    Container(
                        padding: const EdgeInsets.all(16),
                        alignment: Alignment.center,
                        child: SignInButtonBuilder(
                            icon: Icons.verified_user,
                            backgroundColor: Colors.orange,
                            text: 'Sign In',
                            onPressed: () => _pushPage(context, SignInPage()),
                        ),
                    ),
                ],
            ),*/
    );
  }
}
