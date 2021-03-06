import 'package:app/Models/utilisateurRepository.dart';
import 'package:app/widget/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import './register_page.dart';
import './signin_page.dart';
import 'package:app/homes/home_driver.dart';
import 'package:app/homes/home_passenger.dart';
import 'package:app/homes/interfaces/account.dart';
import 'package:app/homes/interfaces/contact.dart';
import 'package:app/homes/interfaces/data_management.dart';
import 'package:app/homes/interfaces/doRequest.dart';
import 'package:app/homes/interfaces/myRequest.dart';

import 'package:app/Models/user.dart';
import 'package:app/Models/driverRepository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // Uncomment this to use the auth emulator for testing
  // await FirebaseAuth.instance.useEmulator('http://localhost:9099');
  runApp(MobiPaApp());
}

/// The entry point of the application.
///
/// Returns a [MaterialApp].
class MobiPaApp extends StatelessWidget {
  final ThemeData theme = buildTheme();

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
        title: 'MobiPA App',
        theme: theme,
        initialRoute: '/auth',
        routes: {
            '/auth': (context) => Auth(),
            '/login': (context) => SignInPage(),
            '/register': (context) => RegisterPage(),
            '/driverHome': (context) => DriverHome(),
            '/passengerHome': (context) => PassengerHome(),
            '/account': (context) => Account(),
            '/contact': (context) => Contact(),
            '/data': (context) => Data_Management(),
            '/driverRequest': (context) => DoRequest(),
            '/passengerRequest': (context) => MyRequest(),
        },
      ),
    );
  }
}

/// Provides a UI to select a authentication type page
class Auth extends StatelessWidget {

  // Navigates to a new page
  void _pushPage(BuildContext context, Widget page) {
    Navigator.of(context) /*!*/ .push(
      MaterialPageRoute<void>(builder: (_) => page),
    );
  }

  @override
  Widget build(BuildContext context) {

      return Scaffold(

          appBar: AppBar(
              centerTitle: true,
              backgroundColor: Colors.white38,
              title: new Text('Acceuil', textAlign: TextAlign.center),
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
                                  fontSize: 32,color: Colors.black,
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
                                          colors: [Color(0xff374ABE), Color(0xff64B6FF)],
                                          begin: Alignment.centerLeft,
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
      );
  }
}
