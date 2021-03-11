

import 'package:flutter/material.dart';
import 'package:contactus/contactus.dart';

class Contact extends StatefulWidget {
  @override
  _Contact createState() => new _Contact();
}

class _Contact extends State<Contact> {


  @override
  void initState()  {
    super.initState();


  }


  void pushPage(BuildContext context, Widget page) {
    Navigator.of(context) /*!*/ .push(
      MaterialPageRoute<void>(builder: (_) => page),
    );
  }


  @override
  Widget build(BuildContext context) {

    return new Scaffold(

        appBar: new AppBar(
    title: new Text("Nous contacter"),
    ),
    body: new MaterialApp(

          debugShowCheckedModeBanner: false,
          home: Scaffold(

            backgroundColor: Colors.white12,
            body: ContactUs(
              cardColor: Colors.white,
              textColor: Colors.teal.shade900,
              logo: AssetImage('assets/mobipa.png'),
              email: 'mobipa@gmail.com',
              emailText: 'Email',
              companyName: 'MobiPA',
              companyColor: Colors.white,
              phoneNumberText: 'Téléphone',
              phoneNumber: '+XXXXXXXXX',
              website: 'https://mobipa.univ-grenoble-alpes.fr/',
              websiteText: 'Site web',
              githubUserName: 'https://github.com/OliDesu/MoBiPa',

              tagLine: 'La Mure',
              taglineColor: Colors.white30,

            ),
          ),
        ),
    );

  }
}
