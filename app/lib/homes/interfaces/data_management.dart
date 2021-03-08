

import 'package:flutter/material.dart';


class Data_Management extends StatefulWidget {
  @override
  _Data_Management createState() => new _Data_Management();
}

class _Data_Management extends State<Data_Management> {


  @override
  void initState()  {
    super.initState();


  }


  void pushPage(BuildContext context, Widget page) {
    Navigator.of(context) /*!*/ .push(
      MaterialPageRoute<void>(builder: (_) => page),
    );
  }

final String data1 = "La société Mobipa, dont le siège est situé à CONFIANCE (96 000) - Rue la Transparence, équipe ses ambulances d’un système de géolocalisation afin d’assurer le suivi et la facturation de la prestation de transport qu’elle effectue. Le système n’a pas pour objet le suivi du temps de travail des salariés et ne permet pas davantage de contrôler les déplacements en-dehors du temps de travail. La base légale du traitement est l’intérêt légitime (cf. article 6.1.f) du Règlement européen sur la protection des données). (NB : la mise en place d’un système de géolocalisation peut également se fonder, par exemple, sur le respect d’une obligation légale ou réglementaire imposant la mise en œuvre du dispositif en raison du type de transport ou de la nature des biens transportés ou encore sur la sûreté ou la sécurité de l’employé lui-même ou des marchandises ou véhicules dont il a la charge). Catégories de données : Identification de l'employé : nom, prénom, coordonnées professionnelles, matricule interne, numéro de plaque d'immatriculation du véhicule ; Données relatives aux déplacements des employés : données de localisation issues de l'utilisation d'un dispositif de géolocalisation, nombre de kilomètres parcourus, historique des déplacements effectués. Destinataire des données : la personne chargée de la gestion du personnel. (NB : la société ABCD étant une TPE (moins de dix salariés), elle ne dispose pas de plusieurs services. Dans une société plus importante, il pourrait y avoir plusieurs catégories de destinataires des données comme, par exemple : Les personnels qui coordonnent, planifient ou suivent les interventions. Les personnels des ressources humaines). Durées de conservation des données : deux mois. Néanmoins, les données peuvent être conservées pour une durée supérieure dans deux cas : pendant un an à des fins de preuve de l'exécution des prestations, s’il n’est pas possible de rapporter cette preuve par un autre moyen ; en cas de contestation des prestations effectuées, jusqu’au règlement de la contestation. Vos droits : Vous pouvez accéder aux données vous concernant ou demander leur effacement. Vous disposez également d'un droit d’opposition, d’un droit de rectification et d’un droit à la limitation du traitement de vos données (cf. cnil.fr pour plus d’informations sur vos droits). Pour exercer ces droits ou pour toute question sur le traitement de vos données dans ce dispositif, vous pouvez contacter gestionpersonnel@abcd.fr. (NB : si la société ABCD avait un DPO, elle indiquerait : Pour exercer ces droits ou pour toute question sur le traitement de vos données dans ce dispositif, vous pouvez contacter notre DPO. Contacter notre DPO par voie électronique : dpo@abcd.fr Contacter notre DPO par courrier postal : Le délégué à la protection des données Société ABCD Rue la Transparence 96 000 CONFIANCE ) Si vous estimez, après nous avoir contactés, que vos droits Informatique et Libertés ne sont pas respectés ou que le dispositif de géolocalisation n’est pas conforme aux règles de protection des données, vous pouvez adresser une réclamation à la CNIL.";
  @override
  Widget build(BuildContext context) {
    return new Scaffold(

      appBar: new AppBar(
        title: new Text("Données des utilisateurs"),
      ),
      body: new SingleChildScrollView(
            child :Container(


                    child: Text(data1,  style: TextStyle(height: 2, fontSize: 15)),



              )

            ),




          );




  }
}
