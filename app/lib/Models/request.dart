import 'dart:math';
import 'package:intl/intl.dart';
import 'package:app/Models/utilisateur.dart';
import 'package:app/Models/trelloClient.dart';
import 'package:app/Models/trelloCard.dart';
import 'package:app/Models/trelloList.dart';
import 'package:app/Models/trelloLabel.dart';

enum RequestStatus { nonPrisEnCharge, enCours, effectue }

class Request {
    String title;

    Utilisateur utilisateur;
    TrelloList etat;
    RequestStatus status = RequestStatus.nonPrisEnCharge;
    TrelloCard card;
    String date;
    String start;
    String destination;
    String name;


    Request(this.title, this.utilisateur, this.date, this.start, this.destination);

    Request.fromCard(TrelloCard card) {
        var regexp, match;
        this.title = card.name;

        regexp = RegExp(r'Prénom : (.+)');
        match = regexp.firstMatch(card.desc);
        this.name = match != null ? match.group(1) : '';
        this.card = card;

        regexp = RegExp(r'Départ : (.+)');
        match = regexp.firstMatch(card.desc);
        this.start = match != null ? match.group(1) : '';

        regexp = RegExp(r'Destination : (.+)');
        match = regexp.firstMatch(card.desc);
        this.destination = match != null ? match.group(1) : '';

        regexp = RegExp(r'Date : (.+)');
        match = regexp.firstMatch(card.desc);
        this.date = match != null ? match.group(1) : '';

    }

    Future<bool> postOnTrello(TrelloClient client, TrelloLabel label) async {
        DateTime now = new DateTime.now();
        String requestDate = DateFormat('y/MM/dd HH:mm').format(now);

        String description = 'Prénom : ' +
            utilisateur.firstName +
            '\nNom : ' +
            utilisateur.lastName +
            '\nDate : ' +
            requestDate +
            '\nDépart : ' +
            start +
            '\nDestination : ' +
            destination;

        card = await client.addCard(etat, title, description, label);
        return card != null;
    }

    Future<bool> delOnTrello(TrelloClient client) async {
        bool success = await client.deleteCard(card.id);
        return success != null;
    }


}
