import 'package:flutter/material.dart';

class PassengerHome extends StatefulWidget {
  @override
  _PassengerHomeState createState() => new _PassengerHomeState();
}

class _PassengerHomeState extends State<PassengerHome> {
  String text = "Ajouter une map ici ";
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        drawer: new Drawer(
          child: new ListView(
            children: <Widget>[
              new Container(
                  child: new DrawerHeader(
                      child: new Container(
                child: Text('Mobipa'),
              ))),
              new Container(
                child: new Column(children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.info),
                      title: Text('Mon compte'),
                      onTap: () {
                        setState(() {
                          text = "Ajouter interface compte";
                        });
                        Navigator.pop(context);
                      }),
                  new ListTile(
                      leading: new Icon(Icons.list),
                      title: Text('Mes trajets'),
                      onTap: () {
                        setState(() {
                          text = "Ajouter interface trajets";
                        });
                        Navigator.pop(context);
                      }),
                  new ListTile(
                      leading: new Icon(Icons.directions_car),
                      title: Text('Conducteurs à proximité'),
                      onTap: () {
                        setState(() {
                          text = "Ajouter interface conducteur";
                        });
                        Navigator.pop(context);
                      }),
                  new ListTile(
                      leading: new Icon(Icons.settings),
                      title: Text('Paramètres'),
                      onTap: () {
                        setState(() {
                          text = "Ajouter interface paramètres";
                        });
                        Navigator.pop(context);
                      }),
                ]),
              )
            ],
          ),
        ),
        appBar: new AppBar(
          title: new Text("Bienvenue **Ajouter nom utilisateur**"),
        ),
        body: new Center(
          child: new Text((text)),
        ));
  }
}
